import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/feature_flag.dart';
import 'package:jobprogress/core/constants/feature_flag_constant.dart';
import 'package:jobprogress/global_widgets/feature_flag/controller.dart';

void main() {

  Map<String, dynamic> tempFeatures = {
    FeatureFlagConstant.production: 0,
    FeatureFlagConstant.reports: 0,
    FeatureFlagConstant.thirdPartyIntegrations: 0,
    FeatureFlagConstant.userManagement: 0,
    FeatureFlagConstant.financeAndAccounting: 0,
    FeatureFlagConstant.materialLabourLibrary: 0,
    FeatureFlagConstant.miscellaneousFeatures: 0,
    FeatureFlagConstant.documents: 0,
    FeatureFlagConstant.customerJobFeatures: 0,
    FeatureFlagConstant.automation: 0,
  };

  test("FeatureFlagService@featureFlagList should be empty by default", () {
    expect(FeatureFlagService.featureFlagList, isEmpty);
  });

  group("FeatureFlagService@setFeatureData should set available feature flags from flags data", () {
    test("FeatureFlagService@featureFlagList should be empty, when feature flags data is empty", () {
      FeatureFlagService.setFeatureData({});
      expect(FeatureFlagService.featureFlagList, isEmpty);
    });

    test("FeatureFlagService@featureFlagList should be filled with data, when feature flags data is not empty", () {
      FeatureFlagService.setFeatureData(tempFeatures);
      expect(FeatureFlagService.featureFlagList, hasLength(10));
      expect(FeatureFlagService.featureFlagList, isNotEmpty);
    });
  });

  test("FeatureFlagService@setFeatureData should initialize FeatureFlagController if not already", () {
    FeatureFlagService.setFeatureData(tempFeatures);
    expect(Get.isRegistered<FeatureFlagController>(), isTrue);
  });

  group("FeatureFlagService@hasFeatureAllowed should decide whether a feature is allowed or not", () {
    group("When features data is not available", () {
      setUp(() {
        FeatureFlagService.setFeatureData({});
      });

      test("Features should be allowed, when feature keys are empty", () {
        bool isAllowed = FeatureFlagService.hasFeatureAllowed([]);
        expect(isAllowed, isTrue);
      });

      test("Features should be allowed, when feature keys are not empty", () {
        bool isAllowed = FeatureFlagService.hasFeatureAllowed([FeatureFlagConstant.production]);
        expect(isAllowed, isTrue);
      });
    });

    group("When features data is available", () {
      setUp(() {
        tempFeatures.remove(FeatureFlagConstant.automation);
        tempFeatures.remove(FeatureFlagConstant.documents);
        FeatureFlagService.setFeatureData(tempFeatures);
      });

      test("Features should be allowed, when feature keys are empty", () {
        bool isAllowed = FeatureFlagService.hasFeatureAllowed([]);
        expect(isAllowed, isTrue);
      });

      group("When feature keys are not empty", () {
        group("In case of single feature key", () {
          test("Feature should not be allowed if it's not in the features data", () {
            bool isAllowed = FeatureFlagService.hasFeatureAllowed([FeatureFlagConstant.automation]);
            expect(isAllowed, isFalse);
          });

          test("Feature should not be allowed if it's in the features data but not enabled", () {
            bool isAllowed = FeatureFlagService.hasFeatureAllowed([FeatureFlagConstant.production]);
            expect(isAllowed, isFalse);
          });

          test("Feature should be allowed if it's in the features data and is enabled", () {
            tempFeatures[FeatureFlagConstant.production] = 1;
            bool isAllowed = FeatureFlagService.hasFeatureAllowed([FeatureFlagConstant.production]);
            expect(isAllowed, isTrue);
          });
        });

        group("In case of multiple feature keys", () {
          group("When one or more feature keys are not available in features data", () {
            test("Feature should not be allowed when none of key exists in features data", () {
              bool isAllowed = FeatureFlagService.hasFeatureAllowed([
                FeatureFlagConstant.automation,
                FeatureFlagConstant.documents
              ]);
              expect(isAllowed, isFalse);
            });

            test("Feature should not be allowed when any one key does not exists and existing features are enabled", () {
              tempFeatures[FeatureFlagConstant.production] = 1;
              bool isAllowed = FeatureFlagService.hasFeatureAllowed([
                FeatureFlagConstant.production,
                FeatureFlagConstant.documents,
              ]);
              expect(isAllowed, isFalse);
            });

            test("Feature should not be allowed when any one key does not exists and existing features are disabled", () {
              tempFeatures[FeatureFlagConstant.production] = 0;
              bool isAllowed = FeatureFlagService.hasFeatureAllowed([
                FeatureFlagConstant.production,
                FeatureFlagConstant.documents,
              ]);
              expect(isAllowed, isFalse);
            });
          });

          group("When all features keys are available in features data", () {
            test("Feature should not be allowed, if any of the features is disabled", () {
              tempFeatures[FeatureFlagConstant.production] = 1;
              tempFeatures[FeatureFlagConstant.customerJobFeatures] = 0;
              bool isAllowed = FeatureFlagService.hasFeatureAllowed([
                FeatureFlagConstant.production,
                FeatureFlagConstant.customerJobFeatures
              ]);
              expect(isAllowed, isFalse);
            });

            test("Feature should not be allowed, if all the features are disabled", () {
              tempFeatures[FeatureFlagConstant.production] = 0;
              tempFeatures[FeatureFlagConstant.customerJobFeatures] = 0;
              bool isAllowed = FeatureFlagService.hasFeatureAllowed([
                FeatureFlagConstant.production,
                FeatureFlagConstant.customerJobFeatures
              ]);
              expect(isAllowed, isFalse);
            });

            test("Feature should be allowed, if all the features are enabled", () {
              tempFeatures[FeatureFlagConstant.production] = 1;
              tempFeatures[FeatureFlagConstant.customerJobFeatures] = 1;
              bool isAllowed = FeatureFlagService.hasFeatureAllowed([
                FeatureFlagConstant.production,
                FeatureFlagConstant.customerJobFeatures
              ]);
              expect(isAllowed, isTrue);
            });
          });
        });
      });
    });
  });
}