import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jobprogress/common/libraries/global.dart';
import 'package:jobprogress/common/models/launchdarkly/flag_model.dart';
import 'package:jobprogress/common/models/launchdarkly/flags.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/subscriber_details.dart';
import 'package:jobprogress/core/config/app_env.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:launchdarkly_flutter_client_sdk/launchdarkly_flutter_client_sdk.dart';

/// [LDService] helps in interacting with Launch Darkly. It is responsible for
/// 1. Setting up and initializing the SDK
/// 2. Setting up the contexts
/// 3. Listening to flag changes
class LDService {

  /// [ldFlagsStream] is a broadcast stream for listening to flag changes and their data
  /// this single stream can have multiple subscribers to it listening to flag changes in real-time
  static StreamController<LDFlagModel> ldFlagsStream = StreamController<LDFlagModel>.broadcast();

  /// [isInitialized] is used to check if Launch Darkly SDK is initialized or not
  static bool isInitialized = false;

  /// [ldClient] is used to initialize the Launch Darkly SDK
  static LDClient? ldClient;

  /// [flagsChangedStream] is used to listen to flag changes in real-time
  static StreamSubscription<FlagsChangedEvent>? flagsChangedStream;

  /// [init] is responsible for setting up the SDK and contexts
  static Future<void> init() async {
    try {
      // Check if Launch Darkly SDK is already initialized.
      // If it's already initialized no need to initialize it again and overwrite the context
      if (isInitialized) return;
      // Setting up the Launch Darkly SDK as per App Environment
      LDConfig config = LDConfig(
          AppEnv.envConfig[CommonConstants.ldMobileKey],
          AutoEnvAttributes.disabled,
      );

      // Creating a builder instance to set up contexts
      LDContextBuilder builder = LDContextBuilder();
      // Building all the contexts
      LDService.setUpContexts(builder);
      LDContext context = builder.build();
      // Initializing the Launch Darkly SDK
      ldClient = LDClient(config, context);
      ldClient?.start().timeout(const Duration(seconds: 30));
      // Additional delay for Launch Darkly SDK to initialize
      await Future<void>.delayed(const Duration(seconds: 1));
      // Setting up flags data and listening to flag changes
      await LDService.setUpFlagsData();
      await LDService.addFlagsListener();
      debugPrint('LAUNCH DARKLY INITIATED SUCCESSFULLY');
    } catch (e) {
      rethrow;
    } finally {
      isInitialized = true;
    }
  }

  /// [setUpContexts] is responsible for setting up all the contexts along with data
  static void setUpContexts(LDContextBuilder builder) {
    LDService.buildUserContext(builder);
    LDService.buildCompanyContext(builder);
    LDService.buildCompanyIntegrationsContext(builder);
  }

  static void buildUserContext(LDContextBuilder builder) {
    final userDetails = AuthService.userDetails;
    // If user details are not available no need to set-up user context
    if (userDetails == null) return;
    // Building user kind with data
    builder.kind('user', userDetails.id.toString())
        .setString('userEmail', userDetails.email.toString())
        .setNum('userId', num.tryParse(userDetails.id.toString()) ?? 0)
        .setString('userRole', getUserRole())
        .setNum('userGroup', userDetails.groupId ?? 0)
        .setString('platform', appPlatform);

    if (!Helper.isValueNullOrEmpty(userDetails.companyDetails?.id)) {
      builder.kind('user', userDetails.id.toString()).setNum('companyId', userDetails.companyDetails!.id);
    }
  }

  static void buildCompanyContext(LDContextBuilder builder) {
    final companyDetails = AuthService.userDetails?.companyDetails;
    final subscriptionDetails = SubscriberDetailsService.subscriberDetails?.subscription;
    // If company details or subscription details are not available
    // no need to set-up company context
    if (companyDetails == null || subscriptionDetails == null) return;
    // Getting company age in days
    final companyCreatedAt = DateTime.tryParse(companyDetails.createdAt ?? "") ?? DateTime.now();
    final companyAgeInDays = DateTime.now().difference(companyCreatedAt).inDays;
    // building company context with data
    builder.kind('company', companyDetails.id.toString())
        .setNum('companyId', companyDetails.id)
        .setString('companyName', '${companyDetails.companyName} (${companyDetails.id})')
        .setNum('noOfUserLicenses', subscriptionDetails.userLicenses ?? 0)
        .setNum('noOfSubLicenses', subscriptionDetails.subContractorUserLicenses ?? 0)
        .setString('companyPlanName', subscriptionDetails.plan?.product ?? '')
        .setNum('companyPlanId', subscriptionDetails.plan?.productId ?? 0)
        .setString('companyAddress', companyDetails.convertedAddress ?? '')
        .setString('companyCountryCode', companyDetails.countryCode ?? '')
        .setString('companyStateCode', companyDetails.stateCode ?? '')
        .setNum('companyAgeInDays', companyAgeInDays);
  }

  static void buildCompanyIntegrationsContext(LDContextBuilder builder) {
    final companyDetails = AuthService.userDetails?.companyDetails;
    final thirdPartyConnections = SubscriberDetailsService.subscriberDetails?.thirdPartyConnections;

    // If Third Party Connections details are not available no need to set-up companyIntergration context
    if (thirdPartyConnections == null || companyDetails == null) return;

    builder.kind('companyIntergration', companyDetails.id.toString())
        .setBool('abcSupplier', Helper.isTrue(thirdPartyConnections.abcSupplier))
        .setBool('srsSupplier', Helper.isTrue(thirdPartyConnections.srsSupplier))
        .setBool('eagleview', Helper.isTrue(thirdPartyConnections.eagleview))
        .setBool('companyCam', Helper.isTrue(thirdPartyConnections.companyCam))
        .setBool('googleSheet', Helper.isTrue(thirdPartyConnections.googleSheet))
        .setBool('qbOnline', Helper.isTrue(thirdPartyConnections.quickbook))
        .setBool('qbDesktop', Helper.isTrue(thirdPartyConnections.quickbookDesktop))
        .setBool('qbPay', Helper.isTrue(thirdPartyConnections.quickbookPay))
        .setBool('hover', Helper.isTrue(thirdPartyConnections.hover))
        .setBool('quickMeasure', Helper.isTrue(thirdPartyConnections.quickmeasure))
        .setBool('dropbox', Helper.isTrue(thirdPartyConnections.dropbox))
        .setBool('angiLeads', Helper.isTrue(thirdPartyConnections.homeAdvisor))
        .setBool('projectMapIt', Helper.isTrue(thirdPartyConnections.projectMapIt))
        .setBool('greensky', Helper.isTrue(thirdPartyConnections.greensky));
  }

  /// [getUserRole] is gives the formatted string for the user role
  static String getUserRole() {
    final user = AuthService.userDetails;
    if (user == null) return '';
    // Check if the user belongs to group with ID 6
    if (!Helper.isValueNullOrEmpty(user.groupId) && user.groupId == 6) {
      return 'system_user (${user.groupId})';
    }
    // Check if the user's group has a name
    if (!Helper.isValueNullOrEmpty(user.groupName)) {
      return '${user.groupName} (${user.groupId})';
    }
    // Default case when no role is found
    return '';
  }

  /// [addFlagsListener] adds a listener for all flags changes
  static Future<void> addFlagsListener() async {
    flagsChangedStream = ldClient?.flagChanges.listen((changedEvent) async {
      await updateFlagDetails(changedEvent.keys.toList());
    });
  }

  /// [setUpFlagsData] sets up the initial flags data and updates the stream
  static Future<void> setUpFlagsData() async {
    // Retrieving all flags
    final allFlags = ldClient?.allFlags();
    if (allFlags == null) return;
    // Adding all flags to the stream
    await updateFlagDetails(allFlags.keys.toList());
  }

  static Future<void> updateFlagDetails(List<String> keys) async {
    for (String key in keys) {
      // Retrieving the updated flag value
      final flagDetails = await getFlagDetailsFromKey(key);
      // Adding the updated flag to the stream
      if (flagDetails != null) ldFlagsStream.add(flagDetails);
    }
  }

  /// [getFlagDetailsFromKey] gets the flag details from the key
  static Future<LDFlagModel?> getFlagDetailsFromKey(String key) async {
    LDFlagModel? flagDetails = LDFlags.allFlags[key];
    if (flagDetails == null) return null;

    switch (flagDetails.type) {
      case LDValueType.boolean:
        flagDetails.value = ldClient?.boolVariation(flagDetails.key, flagDetails.defaultValue);
        break;
      case LDValueType.string:
        flagDetails.value = ldClient?.stringVariation(flagDetails.key, flagDetails.defaultValue);
        break;
      case LDValueType.number:
        flagDetails.value = ldClient?.intVariation(flagDetails.key, flagDetails.defaultValue);
        break;
      case LDValueType.array:
      case LDValueType.object:
        flagDetails.value = ldClient?.jsonVariation(flagDetails.key, flagDetails.defaultValue);
        break;
      case LDValueType.nullType:
        flagDetails.value = null;
        break;
    }
    return flagDetails;
  }

  static void handleFeatureLogic({
    required String flagKey,
    VoidCallback? onTrue,
    VoidCallback? onFalse,
  }) {
    if (hasFeatureEnabled(flagKey)) {
      onTrue?.call();
    } else {
      onFalse?.call();
    }
  }

  static bool hasFeatureEnabled(String flagKey) {
    final flagDetails = LDFlags.allFlags[flagKey];
    return flagDetails != null && Helper.isTrue(flagDetails.value);
  }

  /// [getValue] gives the value of the flag after type check
  /// If type check fails [Null] returned instead of the value
  static dynamic getValue<T>(String flagKey) {
    final flagDetails = LDFlags.allFlags[flagKey];
    final value = flagDetails?.value ?? flagDetails?.defaultValue;
    return value is T ? value : null;
  }

  static Future<void> dispose() async {
    await flagsChangedStream?.cancel();
    await ldClient?.close();
    isInitialized = false;
  }
}