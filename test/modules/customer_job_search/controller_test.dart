import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/launchdarkly/flags.dart';
import 'package:jobprogress/common/services/feature_flag.dart';
import 'package:jobprogress/core/constants/feature_flag_constant.dart';
import 'package:jobprogress/core/constants/file_uploder.dart';
import 'package:jobprogress/core/constants/launchdarkly/flag_keys.dart';
import 'package:jobprogress/core/constants/locale.dart';
import 'package:jobprogress/modules/customer_job_search/controller.dart';
import 'package:jobprogress/translations/index.dart';

void main() {
  final controller = CustomerJobSearchController();

  setUpAll(() {
    Get.addTranslations(JPTranslations().keys);
    Get.locale = LocaleConst.usa;
  });

  group("CustomerJobSearchController@shareToOptions should conditionally display Share To options", () {
    test("Estimates option should be displayed, when [${LDFlagKeyConstants.salesProForEstimate}] is disabled", () {
      LDFlags.salesProForEstimate.value = false;
      bool hasEstimatesOption = controller.shareToOptions.any((element) => element.id == FileUploadType.estimations);
      expect(controller.shareToOptions.length, 6);
      expect(hasEstimatesOption, isTrue);
    });

    test("Estimates option should not be displayed, when [${LDFlagKeyConstants.salesProForEstimate}] is enabled", () {
      LDFlags.salesProForEstimate.value = true;
      bool hasEstimatesOption = controller.shareToOptions.any((element) => element.id == FileUploadType.estimations);
      expect(controller.shareToOptions.length, 5);
      expect(hasEstimatesOption, isFalse);
    });

     testWidgets("Materials option should be displayed when [${FeatureFlagConstant.production}] is enabled", (WidgetTester tester) async {
      FeatureFlagService.setFeatureData({FeatureFlagConstant.production: 1});
      bool hasMaterialsOption = controller.shareToOptions.any((element) => element.id == FileUploadType.materialList);

      expect(hasMaterialsOption, isTrue);
    });

    testWidgets("Work Orders option should be displayed when [${FeatureFlagConstant.production}] is enabled", (WidgetTester tester) async {
      FeatureFlagService.setFeatureData({FeatureFlagConstant.production: 1});
      bool hasWorkOrdersOption = controller.shareToOptions.any((element) => element.id == FileUploadType.workOrder);

      expect(hasWorkOrdersOption, isTrue);
    });

    testWidgets("Materials option should not be displayed when [${FeatureFlagConstant.production}] is disabled", (WidgetTester tester) async {
      FeatureFlagService.setFeatureData({FeatureFlagConstant.production: 0});
      bool hasMaterialsOption = controller.shareToOptions.any((element) => element.id == FileUploadType.materialList);

      expect(hasMaterialsOption, isFalse);
    });

    testWidgets("Work Orders option should not be displayed when [${FeatureFlagConstant.production}] is disabled", (WidgetTester tester) async {
      FeatureFlagService.setFeatureData({FeatureFlagConstant.production: 0});
      bool hasWorkOrdersOption = controller.shareToOptions.any((element) => element.id == FileUploadType.workOrder);

      expect(hasWorkOrdersOption, isFalse);
    });
  });

  group("'Documents' label should be displayed in place of 'Form / Proposal'", () {
    test("'Form / Proposal' label should not be displayed", () {
      bool hasFormOrProposalLabel = controller.shareToOptions.any((element) => element.label == "Form / Proposal");
      expect(hasFormOrProposalLabel, isFalse);
    });

    test("'Documents' label should be displayed in place of 'Form / Proposal'", () {
      bool hasDocumentsLabel = controller.shareToOptions.any((element) => element.label == "Documents");
      expect(hasDocumentsLabel, isTrue);
    });
  });

  group("'Photos & Files' label should be displayed in place of 'Photos & Documents'", () {
    test("'Photos & Documents' label should not be displayed", () {
      bool hasPhotosAndDocumentsLabel = controller.shareToOptions.any((element) => element.label == "Photos & Documents");
      expect(hasPhotosAndDocumentsLabel, isFalse);
    });

    test("'Photos & Files' label should be displayed in place of 'Photos & Documents'", () {
      bool hasPhotosAndFilesLabel = controller.shareToOptions.any((element) => element.label == "Photos & Files");
      expect(hasPhotosAndFilesLabel, isTrue);
    });
  });
}