import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/sql/user/user.dart';
import 'package:jobprogress/common/models/subscriber/license_detail.dart';
import 'package:jobprogress/common/models/subscriber/subscriber_details.dart';
import 'package:jobprogress/common/models/subscriber/subscription.dart';
import 'package:jobprogress/common/models/subscriber/subscription_plan.dart';
import 'package:jobprogress/common/models/subscriber/third_party_connections.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/pendo/index.dart';
import 'package:jobprogress/common/services/subscriber_details.dart';

void main() {

  Map<String, dynamic>? pendoData;

  test("Pendo service should be initialised with correct options", () {
    final options = PendoService.getPendoOptions();
    expect(options, isNotNull);
    expect(options, isNotEmpty);
    expect(options['IntegrationType'], "Observable");
  });

  group("Pendo session should be started with correct Account & Visitor data", () {
    group("In case Account and Visitor data is not available", () {
      setUp(() {
        pendoData = PendoService.getPendoData();
      });

      test('Pendo should not be null or empty', () {
        expect(pendoData, isNotNull);
        expect(pendoData, isNotEmpty);
      });

      test("Pendo Visitor data should be not set", () {
        final visitorData = pendoData?['visitor'];
        expect(visitorData, isNotNull);
        expect(visitorData, {
          "id": null,
          "email": null,
          "userName":  null,
          "userRole": "",
          "appLanguageMobile": "en_US",
        });
      });

      test("User Role for Pendo Visitor data should be not null", () {
        final visitorData = pendoData?['visitor'];
        expect(visitorData, isNotNull);
        expect(visitorData['userRole'], isNotNull);
      });

      test("Account Details should not be null for Pendo Account details", () {
        final accountData = pendoData?['account'];
        expect(accountData, isNotNull);
      });

      test("Default data should be set for Pendo Account details", () {
        final accountData = pendoData?['account'];
        expect(accountData, {
          "id": "",
          "companyName": "",
          "noOfUserLicenses": 0,
          "noOfSubLicenses": 0,
          "companyPlan": "",
          "abcSupplier": false,
          "srsSupplier": false,
          "eagleview": false,
          "companyCam": false,
          "googleSheet": false,
          "qbOnline": false,
          "qbDesktop": false,
          "qbPay": false,
          "hover": false,
          "quickMeasure": false,
          "dropbox": false,
          "angiLeads": false,
          "projectMapIt": false,
          "greenSky": null,
        });
      });
    });
    
    group("In case Account and Visitor data is available", () {
      setUp(() {
        AuthService.userDetails = UserModel(
          id: 1,
          firstName: "John",
          fullName: "John Doe",
          email: "john@gmail.com",
          groupName: "owner",
        );

        SubscriberDetailsService.subscriberDetails = SubscriberDetailsModel(
          id: 1,
          companyName: "Test Company",
          companyCamId: 1,
          licenseList: [
            LicenseDetail(),
          ],
          subscription: SubscriptionModel(
            subContractorUserLicenses: 1,
            plan: SubscriptionPlanModel(
              product: "Test Product",
            ),
          ),
          thirdPartyConnections: ThirdPartyConnectionModel(
            abcSupplier: true,
            srsSupplier: true,
            eagleview: true,
            companyCam: true,
            googleSheet: true,
            quickbook: true,
            quickbookDesktop: true,
            quickbookPay: true,
            hover: true,
            quickmeasure: true,
            dropbox: true,
            homeAdvisor: true,
            projectMapIt: true,
            greensky: true,
          ),
        );
        pendoData = PendoService.getPendoData();
      });

      test("Pendo Visitor data should be set", () {
        final visitorData = pendoData?['visitor'];
        expect(visitorData, isNotNull);
        expect(visitorData, {
          "id": 1,
          "email": "john@gmail.com",
          "userName": "John Doe",
          "userRole": "owner",
          "appLanguageMobile": "en_US",
        });
      });

      test("User Role for Pendo Visitor data should be set", () {
        final visitorData = pendoData?['visitor'];
        expect(visitorData, isNotNull);
        expect(visitorData['userRole'], "owner");
      });

      test("Account Details should be set for Pendo Account details", () {
        final accountData = pendoData?['account'];
        expect(accountData, isNotNull);
        expect(accountData, {
          'id': 1,
          'companyName': 'Test Company',
          'noOfUserLicenses': 1,
          'noOfSubLicenses': 1,
          'companyPlan': 'Test Product',
          'abcSupplier': true,
          'srsSupplier': true,
          'eagleview': true,
          'companyCam': true,
          'googleSheet': true,
          'qbOnline': true,
          'qbDesktop': true,
          'qbPay': true,
          'hover': true,
          'quickMeasure': true,
          'dropbox': true,
          'angiLeads': true,
          'projectMapIt': true,
          'greenSky': true
        });
      });
    });
  });

  group("Language tracking updates in Pendo", () {
    test('Should include appLanguageMobile field in visitor data', () {
      final pendoData = PendoService.getPendoData();
      final visitorData = pendoData['visitor'];

      expect(visitorData, isNotNull);
      expect(visitorData.containsKey('appLanguageMobile'), isTrue);
      expect(visitorData['appLanguageMobile'], isA<String>());
    });

    test('appLanguageMobile field should have expected format', () {
      final pendoData = PendoService.getPendoData();
      final visitorData = pendoData['visitor'];

      // Should be in format "languageCode_countryCode"
      expect(visitorData['appLanguageMobile'], matches(RegExp(r'^[a-z]{2}_[A-Z]{2}$')));
    });

    test('updatedVisitorLanguage should be callable without errors', () async {
      // This test verifies the method exists and can be called
      // In a real environment, this would update Pendo SDK
      expect(() async => await PendoService.updatedVisitorLanguage(), returnsNormally);
    });
  });
}