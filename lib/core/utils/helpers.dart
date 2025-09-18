import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dynamic_icon_plus/flutter_dynamic_icon_plus.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/extensions/color/index.dart';
import 'package:jobprogress/common/models/address/address.dart';
import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/leappay/fee_model.dart';
import 'package:jobprogress/common/models/sql/dev_console.dart';
import 'package:jobprogress/common/models/sql/user/user_limited.dart';
import 'package:jobprogress/common/models/suppliers/branch.dart';
import 'package:jobprogress/common/models/suppliers/srs/srs_ship_to_address.dart';
import 'package:jobprogress/common/models/suppliers/suppliers.dart';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/common/repositories/sql/dev_console.dart';
import 'package:jobprogress/common/services/background_session_tracking_service.dart';
import 'package:jobprogress/common/services/company_settings.dart';
import 'package:jobprogress/common/services/connected_third_party.dart';
import 'package:jobprogress/common/services/cookies.dart';
import 'package:jobprogress/common/services/firebase_crashlytics.dart';
import 'package:jobprogress/common/services/launch_darkly/index.dart';
import 'package:jobprogress/common/services/location/background_location_service.dart';
import 'package:jobprogress/common/services/mixpanel/index.dart';
import 'package:jobprogress/common/services/run_mode/index.dart';
import 'package:jobprogress/core/config/app_env.dart';
import 'package:jobprogress/core/constants/auth_constant.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/constants/company_seetings.dart';
import 'package:jobprogress/core/constants/drawing_tool.dart';
import 'package:jobprogress/core/constants/job_item_with_company_setting_constant.dart';
import 'package:jobprogress/core/constants/launchdarkly/flag_keys.dart';
import 'package:jobprogress/core/constants/leap_pay_payment_method.dart';
import 'package:jobprogress/core/constants/mix_panel/event/login_events.dart';
import 'package:jobprogress/core/constants/regex_expression.dart';
import 'package:jobprogress/core/constants/urls.dart';
import 'package:jobprogress/core/constants/user_roles.dart';
import 'package:jobprogress/core/constants/user_type_list.dart';
import 'package:jobprogress/core/utils/consent_helper.dart';
import 'package:jobprogress/core/utils/file_helper.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/modules/dev_console/cache_management/controller.dart';
import 'package:jp_mobile_flutter_ui/CommonFiles/text_helper.dart';
import 'package:jp_mobile_flutter_ui/ConfirmationDialog/index.dart';
import 'package:jp_mobile_flutter_ui/Thumb/icon_type.dart';
import 'package:html/parser.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sms_mms/sms_mms.dart';
import 'package:url_launcher/url_launcher.dart' as ul;
import 'package:jobprogress/common/libraries/global.dart' as globals;
import 'package:url_launcher/url_launcher.dart';
import '../../common/enums/chats.dart';
import '../../common/models/device_info.dart';
import '../../common/models/sql/flag/flag.dart';
import '../../common/repositories/firebase/firebase_realtime.dart';
import '../../common/repositories/login.dart';
import '../../common/services/clock_in_clock_out.dart';
import '../../common/services/firestore/auth/index.dart';
import '../../common/services/upload.dart';
import '../../global_widgets/bottom_sheet/index.dart';
import '../../routes/pages.dart';
import '../constants/message_type_constant.dart';
import 'color_helper.dart';
import 'firebase/firestore.dart';
import 'form/unsaved_resources_helper/unsaved_resources_helper.dart';

class Helper {

  static String getAccountName(SrsShipToAddressModel? address){
    String accountName = "";
    if(address != null){
      if(address.addressLine2 == null || address.addressLine2!.isEmpty) {
        accountName = "${address.shipToSequenceId}";
      }
      else{
        accountName = "${address.shipToSequenceId}: ${address.addressLine2}";
      }
    }
    return accountName;
  }

  static String formatBase64String(String signature) {
    if(signature.contains(DrawingToolEditedImageType.imagePng)) {
      return signature.replaceAll(DrawingToolEditedImageType.imagePng, "");
    } else{
      return signature.replaceAll(DrawingToolEditedImageType.imageJpeg, "");
    }
  }

  //Add additional arguments to existing arguments
  static void addArguments(Map<String,int> args){
    if(Get.arguments != null){
      (Get.arguments as Map<String,int>).addAll(args);
    }
  }

  // For creating address string with address model
  // Like - 1512 Rua Chico Pontes, Sweetwater,  AL,  37874
  static String convertAddress(AddressModel? address) {
    String location = ""; // define location
    List<String> data = []; // define temp array

    if(address != null) {
      if (address.address != null && address.address!.isNotEmpty) data.add(address.address.toString());

      if (address.addressLine1 != null && address.addressLine1!.isNotEmpty) {
        data.add(address.addressLine1.toString());
      }

      if (address.addressLine3 != null && address.addressLine3!.isNotEmpty) {
        data.add(address.addressLine3.toString());
      }

      if (address.city != null && address.city!.isNotEmpty) data.add(address.city.toString());

    if (address.stateStringType != '' && address.stateStringType != null) data.add(address.stateStringType.toString());

      if (address.state != null) {
        if (address.state!.code.isNotEmpty) {
          data.add(address.state!.code.toString());
        } else if (address.state!.name.isNotEmpty) {
          data.add(address.state!.name.toString());
        }
      }

      /// Use to show country name in address string, keeping this comment if needed to change behaviour
      /// it'll be easy to add
      // if (address.countryStringType != '' && address.countryStringType != null) data.add(address.countryStringType.toString());
      if (data.isNotEmpty) location = data.join(", ");

      if (address.zip != null) {
        if (address.address == null && address.city == null && address.state == null) {
          location += address.zip.toString();
        } else {
          location += " ${address.zip}";
        }
      }
    }
    return location;
  }

  static Map<T, List<S>> groupBy<S, T>(Iterable<S> values, T Function(S) key) {
    var map = <T, List<S>>{};
    for (var element in values) {
      (map[key(element)] ??= []).add(element);
    }
    return map;
  }

  static bool shouldApplySafeArea(BuildContext context) {
    EdgeInsets viewPadding = MediaQuery.of(context).viewPadding;

    return viewPadding.bottom > 0;
  }

  // copyToClipBoard can be used to copy text to clipboard
  static Future<void> copyToClipBoard(String text) async {
    await Clipboard.setData(
      ClipboardData(text: text),
    );
  }

  static String resourceType(FLModule? from){
    switch (from) {
      case FLModule.measurements:
        return 'measurement';
      case FLModule.materialLists:
        return 'material_list';
      case FLModule.estimate:
        return 'estimate';
      case FLModule.workOrder:
        return 'workorder';
      case FLModule.jobProposal:
        return 'proposal';
      case FLModule.attachmentInvoice:
        return 'invoice';
      case FLModule.companyCamImagesFromJob:
      case FLModule.companyCamProjectImages:
        return 'company_cam';
      case FLModule.jobContracts:
        return 'contract';
      default:
      return 'resource';
    }
  }



  // parseHtmlToText with HTML string as input and will return text from it
  static String parseHtmlToText(String html) {

    RegExp exp = RegExp(r"<.*?>", caseSensitive: false);
    final exp2 = RegExp(r"\n\s+");
    return html
        .replaceAll(exp, '')
        .replaceAll(exp2, '\n')
        .replaceAll('/<p[^>]*><\\/p[^>]*>/','')
        .replaceAll("<a.*?</a>", "")
        .replaceAll('&lt;','')
        .replaceAll('&nbsp;', ' ')
        .trim();
  }

  static bool isTrue(dynamic value){
    if (value == "1" || value == 1 || value == "true" || value == true) {
      return true;
    }
    return false;
  }

  static String formattedUnderscoreString(String? input) {
    if (isValueNullOrEmpty(input)) return '';
    
    return input!.split('_').where((word) => word.isNotEmpty)
        .map((word) => '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}')
        .join(' ');
  }

  static List<String> convertEmailListToStringList(List<dynamic>? models, {bool? isAlreadyString}) {
      List<String> emailList = [];

      if (isAlreadyString != null && isAlreadyString) {
          if (models != null) {
              for (var model in models) {
                  String email = model.toString();
                  emailList.add(email);
              }
          }
          return emailList;
      }

      if (models != null) {
          for (var model in models) {
              String email = model.email.toString();
              emailList.add(email);
          }
      }

      return emailList;
  }

  static int isTrueReverse(bool? value){
    if (value ?? false) return 1;
    return 0;
  }

  static String parseHtmlString(String htmlString) {
    htmlString = '<div>$htmlString</div>';
    var document = parse(htmlString);
    String parsedString = parse(document.body!.text).documentElement!.text;
    parsedString.replaceAll('/<p[^>]*><\\/p[^>]*>/','');
    return parseHtmlToText(parsedString);
  }

  static String getEmailTo(String val) {
    if (val.isNotEmpty) {
      int index = val.indexOf('@');
      if (index > -1) {
        final exp = RegExp('/[-_.]+/g');

        return val.substring(0, index).replaceAll(exp, "");
      }
    }
    return val;
  }

  static showToastMessage(String message) {
    // Avoiding toast display during unit testing
    if (RunModeService.isUnitTestMode) return;

    bool isKeyboardOpened = Get.mediaQuery.viewInsets.bottom > 0;
    ToastGravity gravity = isKeyboardOpened ? ToastGravity.CENTER : ToastGravity.BOTTOM;
    Fluttertoast.showToast(
      msg: message,
      gravity: gravity
    );
  }

  // showUnsavedChangesConfirmation(): displays confirmation dialog
  static void showUnsavedChangesConfirmation({int? unsavedResourceId}) {
    Helper.hideKeyboard();
    showJPBottomSheet(
      child: (_) => JPConfirmationDialog(
        title: 'unsaved_changes'.tr,
        subTitle: 'unsaved_changes_desc'.tr,
        icon: Icons.warning_amber_outlined,
        suffixBtnText: 'dont_save'.tr.toUpperCase(),
        prefixBtnText: 'cancel'.tr.toUpperCase(),
        onTapSuffix: () async{
          if(unsavedResourceId != null) await UnsavedResourcesHelper.deleteUnsavedResource(id: unsavedResourceId);
          Get.back();
          await Future<void>.delayed(const Duration(milliseconds: 200));
          Get.back(result: unsavedResourceId);
        },
      ),
    );
  }

  static JPThumbIconType getIconTypeAccordingToExtension(String filePath, { String? extensionName }) {
    String ext = extensionName ?? FileHelper.getFileExtension(filePath) ?? '';

    switch (ext) {
      case 'png':
        return JPThumbIconType.png;
      case 'pdf':
        return JPThumbIconType.pdf;
      case 'xls':
        return JPThumbIconType.xls;
      case 'xlsx':
        return JPThumbIconType.xlsx;
      case 'txt':
        return JPThumbIconType.txt;
      case 'docx':
        return JPThumbIconType.docx;
      case 'xlsm':
        return JPThumbIconType.xlsm;
      case 'doc':
        return JPThumbIconType.doc;
      case 'csv':
        return JPThumbIconType.csv;
      case 'ppt':
        return JPThumbIconType.ppt;
      case 'pptx':
        return JPThumbIconType.pptx;
      case 'zip':
        return JPThumbIconType.zip;
      case 'rar':
        return JPThumbIconType.rar;
      case 'eml':
        return JPThumbIconType.eml;
      case 'ai':
        return JPThumbIconType.ai;
      case 'psd':
        return JPThumbIconType.psd;
      case 've':
        return JPThumbIconType.ve;
      case 'eps':
        return JPThumbIconType.eps;
      case 'dxf':
        return JPThumbIconType.dxf;
      case 'skp':
        return JPThumbIconType.skp;
      case 'ac5':
        return JPThumbIconType.ac5;
      case 'ac6':
        return JPThumbIconType.ac6;
      case 'sdr':
        return JPThumbIconType.sdr;
      case 'json':
        return JPThumbIconType.json;
      case 'pages':
        return JPThumbIconType.pages;
      case 'numbers':
        return JPThumbIconType.numbers;
      case 'dwg':
        return JPThumbIconType.dwg;
      case 'esx':
        return JPThumbIconType.esx;
      case 'sfz':
        return JPThumbIconType.sfz;
      case 'url':
        return JPThumbIconType.url;
      case 'jpg':
        return JPThumbIconType.jpg;
      case 'jpeg':
        return JPThumbIconType.jpeg;
      case 'hover':
        return JPThumbIconType.hover;
      case 'eagle_view':
        return JPThumbIconType.eagleView;

      default:
        return JPThumbIconType.pdf;
    }
  }

  static hideKeyboard() => FocusManager.instance.primaryFocus?.unfocus();

  static showKeyboard() => FocusManager.instance.primaryFocus?.requestFocus();

  static launchUrl(String url, {bool isInExternalMode = true}) async => await ul.launchUrl(Uri.parse(url), mode: isInExternalMode ? LaunchMode.externalApplication : LaunchMode.platformDefault);

  static launchCall(String phoneNumber) async => await ul.launchUrl(Uri.parse("tel://$phoneNumber"));

  static launchSms(String phoneNumber) async => await ul.launchUrl(Uri.parse("sms:$phoneNumber"));

  static launchEmail(String email, {String subject = ''}) async => await launchUrl("mailto:$email?subject=$subject");

  static openHoverApp(String hoverJobId, String action) {
    final companySetting = CompanySettingsService.getCompanySettingByKey(CompanySettingConstants.hoverUrlPrefix);
    String urlPrefix =  companySetting is bool ? Urls.hoverPrefixUrl : companySetting;
    String uri = "$urlPrefix?action=$action&identifier=$hoverJobId";
    launchUrl(uri);
  }

  static String getReminderValue(bool isDueDateReminder, String? reminderFrequency, String? reminderType) {
    String text = !isDueDateReminder ? '${'every'.tr} ' : '';
    text += '$reminderFrequency ';
    text += reminderFrequency == '1'
        ? reminderType.toString()
        : reminderType.toString() + "s".tr;
    text += isDueDateReminder ? 'before_due_date'.tr : ' ';
    return text;
  }

  static String getJobName(JobModel job) {
    final tempJobIdReplaceWith = CompanySettingsService.getCompanySettingByKey(CompanySettingConstants.jobIdReplaceWith);
    final jobIdReplaceWith = tempJobIdReplaceWith is bool ? "" : tempJobIdReplaceWith;

    if (jobIdReplaceWith == JobItemWithCompanySettingConstant.name && !Helper.isValueNullOrEmpty(job.name)) {
      return job.name!;
    }

    if (jobIdReplaceWith == JobItemWithCompanySettingConstant.altId && !Helper.isValueNullOrEmpty(job.altId)) {
      if (Helper.isValueNullOrEmpty(job.divisionCode)) {
        return job.altId!;
      }
      return '${job.divisionCode}-${job.altId}';
    }

    return job.number ?? '';
  }

  /// Returns the display key for the user name.
  ///
  /// If the user's role is a sub-contractor, sub-contractor prime, or labor, and the company name is not null or empty,
  /// the display key will be 'company_name'. Otherwise, it will be 'full_name'.
  static String getUserNameDisplayKey(UserLimitedModel item) {
      final String roleName = item.roleName ?? '';
      final String companyName = item.companyName ?? '';

      if ((roleName == AuthConstant.subContractor ||
          roleName == AuthConstant.subContractorPrime ||
          roleName == AuthConstant.labor) && !Helper.isValueNullOrEmpty(companyName)) {
          return 'company_name';
      }

      return 'full_name';
  }


  static TextSpan formatNote(String value, List<UserLimitedModel>? dataList, String idKey, String displayKey, Color textColor, JPTextSize textSize, {
    int? limit
  }) {
    var children = <InlineSpan>[];

    dataList ??= [];

    // limiting note length only if exceeds the limit.
    // Otherwise, it will show all the text
    if (value.length <= (limit ?? 0)) limit = null;

    // In case note is to be limited to some length
    if (limit != null) {
      // Reducing the limit by the number of user mentions to reduce note length
      limit -= value.split(RegExp(RegexExpression.userMention)).length * 2;
      // splitting up give note
      value = value.substring(0, limit);
      // splitting word by word to remove formatted characters like @[U:, @[ etc
      String lastWord = value.split(" ").last;
      // replacing the last character
      value = value.replaceRange(limit - lastWord.length, limit, "");
      // removing side spaces
      value = value.trim();
    }

    value.splitMapJoin(
      RegExp(RegexExpression.userMention),
      onMatch: (Match match) {
        String matchedGroup = match.group(0)!;
        var matchedId = matchedGroup.substring(4, match.group(0)!.length - 1);

        if(dataList != null && dataList.isNotEmpty) {
          int index = dataList.indexWhere((item) {
            var json = item.toJson();
            return json[idKey].toString() == matchedId;
          });

          UserLimitedModel? item;

          if(index != -1) {
            item = dataList[index];
          }

          if(item != null) {
            var json = item.toJson();

            displayKey = getUserNameDisplayKey(item);

            if(!Helper.isValueNullOrEmpty(json[displayKey])) {
              if(displayKey == 'company_name'){
                children.add(
                  JPTextSpan.getSpan('@${json['full_name']} (${json[displayKey]})', textColor: JPAppTheme.themeColors.primary, textSize: textSize),
                );
              } else if(displayKey == 'full_name') {
                children.add(
                  JPTextSpan.getSpan('@${json[displayKey]}', textColor: JPAppTheme.themeColors.primary, textSize: textSize),
                );
              }
            }
          } else {
            children.add(JPTextSpan.getSpan(matchedGroup, textColor: textColor, textSize: textSize));
          }
        } else {
          children.add(JPTextSpan.getSpan(matchedGroup, textColor: textColor, textSize: textSize));
        }

        return '';
      },
      onNonMatch: (String text) {
        children.add(JPTextSpan.getSpan(text, textColor: textColor, textSize: textSize));
        return '';
      },
    );

    // Adding read more text manually if note is to be limited
    if (limit != null) {
      children.add(
          JPTextSpan.getSpan(
            "... ${"read_more".tr}",
            textColor: JPAppTheme.themeColors.primary,
            fontStyle: FontStyle.italic,
          )
      );
    }

    return JPTextSpan.getSpan('', children: children);
  }

  static void handleError(Object e) {
    if(e is DioException && e.type == DioExceptionType.cancel) {
      debugPrint('API REQUEST CANCELLED');
      return;
    } else {
      throw e;
    }
  }

  static void cancelApiRequest() => cancelToken?.cancel();

  static Future<void> navigateToComposeScreen({Map<String, dynamic>? arguments, VoidCallback? onEmailSent}) async {
    final result = await Get.toNamed(Routes.composeEmail, arguments: arguments, preventDuplicates: false);
    if(result?['id'] != null) {
      onEmailSent?.call();
    }
  }

  static bool checkIfMultilineText({required String text, required double maxWidth, JPTextSize size = JPTextSize.heading4}) {
    if (RunModeService.isUnitTestMode) return true;
    final painter = TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(
              fontSize: TextHelper.getTextSize(size)
          ),

        ),
        textDirection: TextDirection.ltr,
    );

    painter.layout(
      maxWidth: maxWidth
    );

    return painter.computeLineMetrics().length > 1;
  }

  static bool checkIfLastLineOfFullWidth({required String text, required double textWidth, double reduceFromMaxWidth = 50, JPTextSize size = JPTextSize.heading4}) {
    final painter = TextPainter(
        text: TextSpan(
          text: text.trim(),
            style: TextStyle(
                fontSize: TextHelper.getTextSize(size)
            )
        ),
        textDirection: TextDirection.ltr,
    );

    painter.layout(
      maxWidth: textWidth
    );

    return !(painter.computeLineMetrics().last.width < (textWidth - reduceFromMaxWidth));
  }

  static int getMultiLinesFromText({required String text, required double maxWidth, JPTextSize size = JPTextSize.heading4}) {
    final painter = TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(
            fontSize: TextHelper.getTextSize(size)
          )
        ),
        textDirection: TextDirection.ltr
    );

    painter.layout();

    return painter.size.width~/maxWidth + 1;
  }

  static removeMultipleKeysFromArray(List<dynamic> list, List<String> actions) {
    if (list.isEmpty || actions.isEmpty) return;

    for (var action in actions) {
      list.removeWhere((element) => element.id == action);
    }
  }

  static Future<bool> openAppSetting() async => await Geolocator.openAppSettings();

  static openLocationSetting() => Geolocator.openLocationSettings();

  static logOut() async {
    showJPLoader();
    await LoginRepository().logoutUser().then((value) async {
      if(value) {
        await FirebaseAuthService.logOut();
        MixPanelService.trackEvent(event: MixPanelLoginEvent.logOutSuccess);
        await preferences.removeAll();
        await ClockInClockOutService.dispose();
        await UploadService.pauseAllUploads();
        await FirebaseRealtimeRepo.disposeAllStreams();
        await BackgroundLocationService.stopTracking();
        BackgroundSessionTrackingService.get()?.stopTimer();
        await LDService.dispose();
        Helper.showToastMessage('user_logged_out'.tr);
        MixPanelService.dispose();
        ConsentHelper.clearLastTextStatus();
        CookiesService.clearCookies();
        CacheManagementController.clearCacheAndUploadsOnCookieRenewal();
        Get.offAllNamed(Routes.login);
      } else {
        MixPanelService.trackEvent(event: MixPanelLoginEvent.logOutFailed);
        Helper.showToastMessage('user_logout_failed'.tr);
      }
    }).onError((error, stackTrace) => Helper.showToastMessage('user_logout_failed'.tr))
        .whenComplete(() => Get.back());
  }

  static Future<void> sendMms({
    required List<String> recipients,
    String? message,
    String? filePath,
  }) async {
    await SmsMms.send(
        recipients: recipients,
        message: message ?? "",
        filePath: filePath
    );
  }

  static Future<DeviceInfo?> getDeviceInfo () async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    String udid = await FlutterUdid.udid;

    if(Platform.isAndroid) {
      return deviceInfoPlugin.androidInfo.then((value) =>
        DeviceInfo(
          deviceModel: value.model,
          appVersion: globals.appVersion,
          deviceVersion: value.version.release,
          platform: 'Android',
          uuid: udid,
          manufacturer: value.manufacturer
        ));
    } else {
      return deviceInfoPlugin.iosInfo.then((value) =>
        DeviceInfo(
          deviceModel: value.name,
          appVersion: globals.appVersion,
          deviceVersion: value.systemVersion,
          platform: value.systemName,
          uuid: udid,
          manufacturer: 'Apple'
        ));
    }
  }

  /// Simply converts string version into numeric comparable value.
  ///
  /// Example:
  /// getExtendedVersionNumber('0.0.10') => 10
  /// getExtendedVersionNumber('1.1.19') =>  10010019
  /// getExtendedVersionNumber('5.2.3') =>  50020003
  static int getExtendedVersionNumber(String version) {
    List<dynamic> versionCells = version.split('.');
    versionCells = versionCells.map((i) => int.parse(i)).toList();
    return versionCells[0] * 100000 + versionCells[1] * 1000 + versionCells[2];
  }

  /// convert duration string to map
  /// eg. 80 Days 3 Hours 52 Minutes into
  /// {days:80,hours:3,minutes:52}
  static Map<String, String> splitDurationintoMap(String durationType, String duration) {

    List<String> result = duration.toLowerCase().split('${durationType}s');

    if(result.length == 1) {
      result = duration.toLowerCase().split(durationType.toLowerCase());
    }

    return {
      'result' : result.length == 1 ? "" : result[0].trim(),
      'remainingData' : result.length == 1 ? duration : result[1].trim()
    };
  }

  static bool isValueNullOrEmpty(dynamic value) {
    bool canCheckEmptiness = (value is String || value is List);
    return (value == null || (canCheckEmptiness && value.isEmpty) || value == 'null');
  }

  static bool isInvalidValue(dynamic val, {bool shouldNotZero = false}) {
    final actualValue = num.tryParse(val.toString()) ?? 0;
    bool isZero = false;
    if (shouldNotZero) isZero = actualValue == 0 || !actualValue.isFinite;
    return (val.toString() == '.') || isZero;
  }

  /// [encodeToHTMLString] - takes json as input and replaces special
  static String encodeToHTMLString(Map<String, dynamic> json) {
    return jsonEncode(json).replaceAll('"', "&quot;");
  }

  static String getWorkCrewName(UserLimitedModel user, { bool byRoleName = false}){
    if(byRoleName && user.roleName == AuthConstant.subContractorPrime && !Helper.isValueNullOrEmpty(user.companyName)) {
      return '${user.fullName} (${user.companyName!})';
    }
   
    if(user.groupId == UserGroupIdConstants.subContractor ||
      user.groupId == UserGroupIdConstants.subContractorPrime ||
      user.groupId == UserGroupIdConstants.labor ) {
        if(!Helper.isValueNullOrEmpty(user.companyName)){
          return '${user.fullName} (${user.companyName!})';
        }
    }

    return user.fullName;
  }


  /// [getSupplierId] returns the supplier ID
  static int? getSupplierId({String? key, bool forceV1 = false}) {
    Map<String, dynamic> supplierIds = AppEnv.envConfig[CommonConstants.suppliersIds];

    key ??= CommonConstants.srsId;

    if(key == CommonConstants.srsId) {
      if (LDService.hasFeatureEnabled(LDFlagKeyConstants.srsV2MaterialIntegration) && !forceV1) {
        key = CommonConstants.srsV2Id;
      }
    }
    return supplierIds[key];
  }

  static bool isSupplierHaveSrsItem(List<SuppliersModel>? suppliers, {bool isSRSV2Only = false}) {
    return suppliers?.any((supplier) => (isSRSv1Id(supplier.id) && !isSRSV2Only) || isSRSv2Id(supplier.id)) ?? false;
  }

  static bool isSupplierHaveBeaconItem(List<SuppliersModel>? suppliers) {
    final beaconId = getSupplierId(key: CommonConstants.beaconId);
    return suppliers?.any((supplier) => supplier.id == beaconId) ?? false;
  }

  static bool isSupplierHaveABCItem(List<SuppliersModel>? suppliers) {
    final abcSupplierId = getSupplierId(key: CommonConstants.abcSupplierId);
    return suppliers?.any((supplier) => supplier.id == abcSupplierId) ?? false;
  }

  static String removeSrNoFromDescription(String? val) {
    if (!isValueNullOrEmpty(val)) {
      // final RegExp removeNoWithWhiteSpaceRegex = RegExp(r'/^\d+\.\s+/');
      // return val!.replaceAll(removeNoWithWhiteSpaceRegex, '');
      if (val!.contains('.')) {
        return val.split('.')[1].trimLeft();
      } else {
        return val.trimLeft();
      }
    } else {
      return val ?? "";
    }
  }

  static String removeHtmlAttributes(String value, List<String> attributesToRemove){
    String string = value.trim();
    for (String attribute in attributesToRemove) {
      switch(attribute){
        case 'id':
          string = string.replaceAll(RegExp(r'id\s*=\s*"[^"]*"'), '');
          break;
        case 'name':
          string = string.replaceAll(RegExp(r'name\s*=\s*"[^"]*"'), '');
          break;
      }
    }
    return string;
  }

  static String? replaceUnderscoreWithSpace(String? input) {
    return input?.replaceAll('_', ' ');
  }

  static Color evaluateFlagBackgroundColor(FlagModel? flag){
    return ColorHelper.getHexColor(flag?.color == null
        ? JPAppTheme.themeColors.darkGray.toHex()
        : flag!.color!.contains(JPAppTheme.themeColors.inverse.toHex())
        ? JPAppTheme.themeColors.darkGray.toHex()
        : flag.color!);
  }

  static void recordError(Object exception) {
    if (!Crashlytics.skipCrashlytics) {
      FirebaseCrashlytics.instance
          .recordFlutterError(FlutterErrorDetails(exception: exception));
    }
    SqlDevConsoleRepository
        .insertLog(DevConsoleModel.fromError(exception))
        .catchError((dynamic e) => {
          debugPrint(e.toString())
        });
  }

  /// Calculates the maximum width of the words in the given list.
  ///
  /// The [words] parameter is a list of strings representing the words to measure.
  /// The [size] parameter is an optional argument of type [JPTextSize] specifying the text size.
  /// The [defaultWidth] parameter is an optional argument of type [double] specifying the default width.
  ///
  /// Returns the maximum width found.
  static double getMaxWidthFromWords(List<String?> words, {
      JPTextSize size = JPTextSize.heading5,
      double defaultWidth = 100
    }) {

      // Initialize the result to the default width
      double result = defaultWidth;

      // Create a TextPainter to measure the width of the text
      final painter = TextPainter(
          textDirection: TextDirection.ltr
      );

      // Iterate over each word in the list
      for (String? word in words) {
        if (word == null) continue;
        // Split the word by spaces
        final wordsWithoutSpace = word.trim().split(" ");

        // Iterate over each word without spaces
        for (String wordWithoutSpace in wordsWithoutSpace) {
          wordWithoutSpace = wordWithoutSpace.trim();
          if (wordWithoutSpace.isEmpty) continue;
          // Set the text and style for the TextPainter
          painter.text = TextSpan(
              text: wordWithoutSpace,
              style: TextStyle(
                fontSize: TextHelper.getTextSize(size),
              )
          );

          // Calculate the width of the text
          painter.layout();

          // Update the result if the width is greater
          result = result > painter.width ? result : painter.width;
        }
      }

      // Return the maximum width found
      return result;
  }

  /// Extracts includes from the given parameters.
  ///
  /// This function takes a map of parameters and extracts the values that contain the keyword "includes".
  /// It returns a list of the extracted includes.
  static List<dynamic> extractIncludesFormParams(Map<String, dynamic> params) {
    // Creating an empty list that will store additional includes
    List<dynamic> paramsWithIncludes = [];
    // extracting includes
    for (dynamic paramKey in params.keys) {
      if (paramKey.contains('includes')) {
        paramsWithIncludes.add(params[paramKey]);
      }
    }
    // removing includes from the original params
    params.removeWhere((key, value) => key.contains('includes'));
    return paramsWithIncludes;
  }

  static String getJustifiClientId() {
    return AppEnv.envConfig[CommonConstants.justifiClientId];
  }

  static Future<String> getOldAppDBPath() async {
    Directory? appLibraryDirectory;
    if (Platform.isAndroid) {
      appLibraryDirectory = await getApplicationDocumentsDirectory();
      return '${appLibraryDirectory.path.replaceFirst("/app_flutter", "")}/databases/jobprogress.db';
    } else {
      appLibraryDirectory = await getLibraryDirectory();
      return "${appLibraryDirectory.path}/LocalDatabase/jobprogress.db";
    }
  }

  static Future<bool> isNetworkConnected() async {
  List<ConnectivityResult> results = await Connectivity().checkConnectivity();
  return results.any((result) => result == ConnectivityResult.mobile || result == ConnectivityResult.wifi);
}

  // set badge icon count
  static Future<void> setApplicationBadgeCount(String? value) async {
    if (Platform.isIOS) {
      try {
            if (value != null) {
              int? count = int.tryParse(value);
              if (count != null) {
                await FlutterDynamicIconPlus.setApplicationIconBadgeNumber(count);
              }
            }
          } catch(e) {
            debugPrint('BADGE ICON: $e');
          }
    }
  }

  static String removeCountryCodes(String number){
    List<String> countryCodes = ['+1','+44','+61','+91','+33','+34','+1684'];
    for(String countryCode in countryCodes){
      if(number.startsWith(countryCode)){
        number = number.replaceFirst(countryCode, "");
        break;
      }
    }
    return number.trim();
  }
  static String getUserType(String userTypeFromSetting) {
    switch (userTypeFromSetting) {
      case UserTypeConstants.companyCrew:
        return 'company_crew'.tr;
      case UserTypeConstants.customerRep:
        return 'salesmanRep'.tr;
      case UserTypeConstants.estimator:
        return 'job_rep_estimator'.tr;
      case UserTypeConstants.subs:
        return 'sub_contractor'.tr;
      default:
        return '';
    }
  }

  static String getUserTypeId(String userType) {
    switch (userType) {
      case UserTypeConstants.companyCrew:
        return '-3';
      case UserTypeConstants.customerRep:
        return '-1';
      case UserTypeConstants.estimator:
        return '-2';
      case UserTypeConstants.subs:
        return '-4';
      default:
        return '';
    }
  }

  static Map<String, dynamic> extractParamsFromURL(String url) {

    // Extract the part of the URL that contains the query parameters
    String queryParams = url.split('?').last;

    // Parse the query parameters
    Uri uri = Uri.parse('${Urls.baseUrl}?$queryParams');
    Map<String, String> params = uri.queryParameters;

    // Print each query parameter
    return params;
  }

  static bool isSRSv2Id(int? supplierId) {
    Map<String, dynamic> supplierIds = AppEnv.envConfig[CommonConstants.suppliersIds];
    return supplierId == supplierIds[CommonConstants.srsV2Id];
  }

  static bool isSRSv1Id(int? supplierId) {
    Map<String, dynamic> supplierIds = AppEnv.envConfig[CommonConstants.suppliersIds];
    return supplierId == supplierIds[CommonConstants.srsId];
  }

  // Filter duplicates by key and return a list of unique items
  static List<T> filterDuplicatesByKey<T, K>(List<T> items, K Function(T) keyExtractor) {
    final Map<K, T> uniqueItemsMap = {};
    for (var item in items) {
      uniqueItemsMap[keyExtractor(item)] = item;
    }
    return uniqueItemsMap.values.toList();
  }
  // Get customer referred by type base
  static String getCustomerReferredBy(CustomerModel? customer, {bool showExistingCustomerLabel = false}) {
    switch (customer?.referredByType) {
      case 'other':
        return customer?.referredByNote ?? "";
      case 'customer':
        String referredBy = customer?.referredBy?.fullNameMobile ?? "";
        if (showExistingCustomerLabel) {
          referredBy += ' (${ 'existing_customer'.tr })';
        }
        return referredBy;
      case 'referral':
        return customer?.referredBy?.fullName ?? "";
      default:
        return "";
    }
  }

  static int? getSRSV1Supplier() {
    Map<String, dynamic> supplierIds = AppEnv.envConfig[CommonConstants.suppliersIds];

    return supplierIds[CommonConstants.srsId];
  }

  static int? getSRSV2Supplier() {
    Map<String, dynamic> supplierIds = AppEnv.envConfig[CommonConstants.suppliersIds];

    return supplierIds[CommonConstants.srsV2Id];
  }

  static bool isBeaconSupplierId(int? supplierId) =>
      getSupplierId(key: CommonConstants.beaconId) == supplierId;

  static String getAbcAccountName(SrsShipToAddressModel? address) {
    String accountName = "";
    if(address != null) {
      if(isValueNullOrEmpty(address.addressLine1)) {
        accountName = "${address.shipToId}";
      }
      else {
        accountName = "${address.shipToId}: ${address.addressLine1}";
      }
    }
    return accountName;
  }

  static isABCSupplierId(int? supplierId) =>
      getSupplierId(key: CommonConstants.abcSupplierId) == supplierId;

  static getMessageType(String? type) {
    if(FirestoreHelpers.instance.isMessagingEnabled) {
      return GroupsListingType.fireStoreMessages;
    } else if(type == MessageTypeConstant.sms) {
      return GroupsListingType.apiTexts;
    } else {
      return GroupsListingType.apiMessages;
    }
  }
  
  static String getPayMethodSubtitle(String method) {
    LeapPayFeeModel leapPayFees = ConnectedThirdPartyService.getLeapPayCompanyRate();
    switch (method) {
      case LeapPayPaymentMethod.card:
        return '${'instant_processing_with'.tr} ${leapPayFees.cardFeePercentage}% + \$${leapPayFees.cardFeeAdditional.toString()} ${'fee'.tr}';
      case LeapPayPaymentMethod.achOnly:
        return '${'3_5_business_days_processing_time_with'.tr} ${leapPayFees.bankFeePercentage}% ${'fee'.tr}';
      default:
        return '';
    }
  }

  static String getAbcBranchName(SupplierBranchModel? branch) {
    String branchName = '';
    if(branch != null) {
      if(isValueNullOrEmpty(branch.branchId)) {
        branchName = branch.name ?? '';
      }
      else {
        branchName = "${branch.branchId}: ${branch.name}";
      }
    }
    return branchName;
  }

  static int flagBasedUploadSize({required int fileSize}) {
    if (LDService.hasFeatureEnabled(LDFlagKeyConstants.enableLargerUploadSize)) {
      return CommonConstants.flagBaseSize;
    }
    return fileSize;
  }

  ///Checks if any integrated supplier id exists
  /// Params:
  /// [supplierId] - supplier id
  static bool isIntegratedSupplier(int? supplierId) =>
      Helper.isSRSv1Id(supplierId)
          || Helper.isSRSv2Id(supplierId)
          || Helper.isBeaconSupplierId(supplierId)
          || Helper.isABCSupplierId(supplierId);

  ///Checks if non integrated supplier id exists
  /// Params:
  /// [supplierId] - supplier id
  static bool isNonIntegratedSupplier(int? supplierId) =>
      !Helper.isSRSv1Id(supplierId)
          && !Helper.isSRSv2Id(supplierId)
          && !Helper.isBeaconSupplierId(supplierId)
          && !Helper.isABCSupplierId(supplierId);
}