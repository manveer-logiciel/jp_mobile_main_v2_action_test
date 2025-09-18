import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/launchdarkly/flags.dart';
import 'package:jobprogress/common/services/feature_flag.dart';
import 'package:jobprogress/core/constants/feature_flag_constant.dart';
import 'package:jobprogress/core/constants/file_uploder.dart';
import 'package:jobprogress/core/constants/launchdarkly/flag_keys.dart';
import 'package:jobprogress/core/constants/locale.dart';
import 'package:jobprogress/modules/job/job_summary/secondary_drawer/job_drawer_item_lists.dart';
import 'package:jobprogress/translations/index.dart';

void main() {
  setUpAll(() {
    Get.addTranslations(JPTranslations().keys);
    Get.locale = LocaleConst.usa;
  });

  group("JobDrawerItemLists@jobSummaryItemList should give options list conditionally", () {
    group("'Contracts' option should be displayed conditionally", () {
      test("In case [${LDFlagKeyConstants.salesProForEstimate}] is not enabled, contract option should not be there", () {
        LDFlags.salesProForEstimate.value = false;
        final options = JobDrawerItemLists().jobSummaryItemList;
        bool hasContractOption = options.any((element) => element.slug == FileUploadType.contracts);
        expect(hasContractOption, isFalse);
      });

      test("In case [${LDFlagKeyConstants.salesProForEstimate}] is enabled, contract option should be there", () {
        LDFlags.salesProForEstimate.value = true;
        final options = JobDrawerItemLists().jobSummaryItemList;
        bool hasContractOption = options.any((element) => element.slug == FileUploadType.contracts);
        expect(hasContractOption, isTrue);
      });
    });
    group("JobDrawerItemLists should conditionally display the 'materials' drawer item based on the production feature flag", () {
      test("Materials option should be displayed when the production feature is enabled", () {
        FeatureFlagService.setFeatureData({FeatureFlagConstant.production: 1});
        final drawerItemList = JobDrawerItemLists().jobSummaryItemList;

        bool hasMaterialsOption = drawerItemList.any((item) => item.slug == FileUploadType.materialList);

        expect(hasMaterialsOption, isTrue);
      });

      test("Materials option should not be displayed when the production feature is disabled", () {
        FeatureFlagService.setFeatureData({FeatureFlagConstant.production: 0});
        final drawerItemList = JobDrawerItemLists().jobSummaryItemList;

        bool hasMaterialsOption = drawerItemList.any((item) => item.slug == FileUploadType.materialList);

        expect(hasMaterialsOption, isFalse);
      });
    });
  });

  group("JobDrawerItemLists@jobSummaryItemList should display 'Documents' label instead of 'Form / Proposal'", () {
    test("'Form / Proposal' label should not be displayed", () {
      final options = JobDrawerItemLists().jobSummaryItemList;
      bool hasFormOrProposalLabel = options.any((element) => element.title == "Form / Proposal");
      expect(hasFormOrProposalLabel, isFalse);
    });

    test("'Documents' label should be displayed in place of 'Form / Proposal'", () {
      final options = JobDrawerItemLists().jobSummaryItemList;
      bool hasDocumentsLabel = options.any((element) => element.title == "Documents");
      expect(hasDocumentsLabel, isTrue);
    });
  });

  group("JobDrawerItemLists@jobSummaryItemList should display 'Photos & Files' label instead of 'Photos & Documents'", () {
    test("'Photos & Documents' label should not be displayed", () {
      final options = JobDrawerItemLists().jobSummaryItemList;
      bool hasPhotosAndDocumentsLabel = options.any((element) => element.title == "Photos & Documents");
      expect(hasPhotosAndDocumentsLabel, isFalse);
    });

    test("'Photos & Files' label should be displayed in place of 'Photos & Documents'", () {
      final options = JobDrawerItemLists().jobSummaryItemList;
      bool hasPhotosAndFilesLabel = options.any((element) => element.title == "Photos & Files");
      expect(hasPhotosAndFilesLabel, isTrue);
    });
  });
}