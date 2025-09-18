import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/sql/company/company.dart';
import 'package:jobprogress/common/models/sql/user/user.dart';
import 'package:jobprogress/common/models/subscriber/subscriber_details.dart';
import 'package:jobprogress/common/models/subscriber/subscription.dart';
import 'package:jobprogress/common/models/subscriber/subscription_plan.dart';
import 'package:jobprogress/common/models/subscriber/third_party_connections.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/launch_darkly/index.dart';
import 'package:jobprogress/common/services/subscriber_details.dart';
import 'package:launchdarkly_flutter_client_sdk/launchdarkly_flutter_client_sdk.dart';

void main() {
  LDContextBuilder builder = LDContextBuilder();

  final userDetails = UserModel(
      id: 1,
      firstName: 'Launch',
      fullName: 'Launch Darkly',
      email: 'launch@darkly.com',
      groupId: 3,
      groupName: 'owner',
      companyDetails: CompanyModel(
          id: 5,
          companyName: 'Leap',
          convertedAddress: '104, New york street, Usa',
          countryCode: 'US',
          stateCode: 'CA',
          createdAt: DateTime.now().subtract(const Duration(days: 5)).toString(),
      ),
  );

  final subscriberDetails = SubscriberDetailsModel(
      subscription: SubscriptionModel(
        id: 1,
        plan: SubscriptionPlanModel(
          productId: 1,
          product: 'Free',
        ),
        userLicenses: 10,
        subContractorUserLicenses: 5,
      ),
      thirdPartyConnections: ThirdPartyConnectionModel(
          abcSupplier: true,
          srsSupplier: true,
          eagleview: true,
          beacon: false,
          companyCam: true,
          dropbox: false,
          facebook: true,
          googleSheet: true,
          greensky: true,
          homeAdvisor: true,
          hover: false,
          linkedin: true,
          projectMapIt: false,
          quickbook: true,
          quickbookDesktop: false,
          quickbookPay: true,
          quickmeasure: true,
          skymeasure: false,
          twitter: true,
      ),
  );

  Map<String, dynamic>? getContextDetails() {
    LDContext context = builder.build();
    // Parse custom attributes from context
    Map<String, dynamic> attributes = {};
    context.attributesByKind.forEach((key, value) {
      attributes.putIfAbsent('customAttributes', () => <dynamic, dynamic>{});
      value.customAttributes.forEach((key, value) {
        if (value.type == LDValueType.string) {
          attributes['customAttributes'][key] = value.stringValue();
        } else if (value.type == LDValueType.number) {
          attributes['customAttributes'][key] = value.intValue();
        } else if (value.type == LDValueType.boolean) {
          attributes['customAttributes'][key] = value.booleanValue();
        }
      });
      attributes['kind'] = value.kind;
      attributes['key'] = value.key;
      attributes['anonymous'] = value.anonymous;
      attributes['name'] = value.name;
      attributes['privateAttributes'] = value.privateAttributes;
    });
    return attributes;
  }

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group('LaunchDarkly contexts should be built with correct data', () {
    group('User context should be build properly', () {
      setUp(() {
        builder = LDContextBuilder();
      });

      test('When user details are not available context should not be created',
          () {
        AuthService.userDetails = null;
        LDService.buildUserContext(builder);
        final output = getContextDetails();
        expect(output, equals({}));
      });

      test('User context should be build properly', () {
        AuthService.userDetails = userDetails;
        LDService.buildUserContext(builder);
        final output = getContextDetails();

        Map<String, dynamic> expectedOutput = {
          'customAttributes': {
            'userEmail': 'launch@darkly.com',
            'userId': 1,
            'userRole': 'owner (3)',
            'userGroup': 3,
            'platform': 'ios',
            'companyId': 5 
          },
          'kind': 'user',
          'key': '1',
          'anonymous': false,
          'name': null,
          'privateAttributes': <dynamic>{}
        };
        expect(output, equals(expectedOutput));
      });
    });

    group('Company context should be build properly', () {
      setUp(() {
        builder = LDContextBuilder();
      });

      test('When company details are not available context should not be created', () {
        AuthService.userDetails = null;
        LDService.buildCompanyContext(builder);
        final output = getContextDetails();
        expect(output, equals({}));
      });

      test('When subscription details are not available context should not be created', () {
        SubscriberDetailsService.subscriberDetails = null;
        LDService.buildCompanyContext(builder);
        final output = getContextDetails();
        expect(output, equals({}));
      });

      test('Company context should be build properly', () {
        AuthService.userDetails = userDetails;
        SubscriberDetailsService.subscriberDetails = subscriberDetails;
        LDService.buildCompanyContext(builder);
        final output = getContextDetails();
        final expectedOutput = {
            'customAttributes': {
            'companyId': 5,
            'companyName': 'Leap (5)',
            'noOfUserLicenses': 10,
            'noOfSubLicenses': 5,
            'companyPlanName': 'Free',
            'companyPlanId': 1,
            'companyAddress': '104, New york street, Usa',
            'companyCountryCode': 'US',
            'companyStateCode': 'CA',
            'companyAgeInDays': 5
          },
          'kind': 'company',
          'key': '5',
          'anonymous': false,
          'name': null,
          'privateAttributes': <dynamic>{}
        };
        expect(output, equals(expectedOutput));
      });
    });

    group('Company Integration context should be built properly', () {
      setUp(() {
        builder = LDContextBuilder();
      });

      test('When company details are not available context should not be created', () {
        AuthService.userDetails = null;
        LDService.buildCompanyIntegrationsContext(builder);
        final output = getContextDetails();
        expect(output, equals({}));
      });

      test('When third party integration details are not available context should not be created', () {
        SubscriberDetailsService.subscriberDetails = null;
        LDService.buildCompanyIntegrationsContext(builder);
        final output = getContextDetails();
        expect(output, equals({}));
      });

      test('Company Integration context should be build properly', () {
        AuthService.userDetails = userDetails;
        SubscriberDetailsService.subscriberDetails = subscriberDetails;
        LDService.buildCompanyIntegrationsContext(builder);
        final output = getContextDetails();
        final expectedOutput = {
          'customAttributes': {
            'abcSupplier': true,
            'srsSupplier': true,
            'eagleview': true,
            'companyCam': true,
            'googleSheet': true,
            'qbOnline': true,
            'qbDesktop': false,
            'qbPay': true,
            'hover': false,
            'quickMeasure': true,
            'dropbox': false,
            'angiLeads': true,
            'projectMapIt': false,
            'greensky': true
          },
          'kind': 'companyIntergration',
          'key': '5',
          'anonymous': false,
          'name': null,
          'privateAttributes': <dynamic>{}
        };
        expect(output, equals(expectedOutput));
      });
    });

    test('LDService@setUpContexts should set up all contexts correctly', () {
      builder = LDContextBuilder();
      AuthService.userDetails = userDetails;
      SubscriberDetailsService.subscriberDetails = subscriberDetails;
      LDService.setUpContexts(builder);
      final output = getContextDetails();
      final expectedOutput = {
        'customAttributes': {
          "userEmail": "launch@darkly.com",
          "userId": 1,
          "userRole": "owner (3)",
          "userGroup": 3,
          "platform": "ios",
          "companyId": 5,
          "companyName": "Leap (5)",
          "noOfUserLicenses": 10,
          "noOfSubLicenses": 5,
          "companyPlanName": "Free",
          "companyPlanId": 1,
          "companyAddress": "104, New york street, Usa",
          "companyCountryCode": "US",
          "companyStateCode": "CA",
          "companyAgeInDays": 5,
          "abcSupplier": true,
          "srsSupplier": true,
          "eagleview": true,
          "companyCam": true,
          "googleSheet": true,
          "qbOnline": true,
          "qbDesktop": false,
          "qbPay": true,
          "hover": false,
          "quickMeasure": true,
          "dropbox": false,
          "angiLeads": true,
          "projectMapIt": false,
          "greensky": true,
        },
        'kind': 'companyIntergration',
        'key': '5',
        'anonymous': false,
        'name': null,
        'privateAttributes': <dynamic>{}
      };
      expect(output, equals(expectedOutput));
    });
  });

  group('LDService@getUserRole should give formatted user role', () {
    test('When user details are not available should return empty string', () {
      AuthService.userDetails = null;
      final output = LDService.getUserRole();
      expect(output, equals(""));
    });

    group('When user details are available should return formatted user role', () {
      test('In case of system user', () {
        AuthService.userDetails = userDetails..groupId = 6;
        final output = LDService.getUserRole();
        expect(output, equals("system_user (6)"));
      });

      test('In case of any other role', () {
        AuthService.userDetails = userDetails..groupId = 3;
        final output = LDService.getUserRole();
        expect(output, equals("owner (3)"));
      });
    });
  });
}
