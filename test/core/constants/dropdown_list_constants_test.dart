import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/launchdarkly/flags.dart';
import 'package:jobprogress/core/constants/dropdown_list_constants.dart';
import 'package:jobprogress/core/constants/launchdarkly/flag_keys.dart';
import 'package:jobprogress/core/constants/locale.dart';
import 'package:jobprogress/translations/index.dart';

void main() {
  setUpAll(() {
    Get.addTranslations(JPTranslations().keys);
    Get.locale = LocaleConst.usa;
  });

  group("DropdownListConstants@copyToJobTypeList should show 'Estimates' action conditionally while Copy To Job", () {
    test('Estimate action should be shown when LD Flag [${LDFlagKeyConstants.salesProForEstimate}] is disabled', () {
      LDFlags.salesProForEstimate.value = false;
      bool hasEstimatesAction = DropdownListConstants.copyToJobTypeList.any((element) => element.id == "estimating");
      expect(DropdownListConstants.copyToJobTypeList, hasLength(3));
      expect(hasEstimatesAction, isTrue);
    });

    test('Estimate action should not be shown when LD Flag [${LDFlagKeyConstants.salesProForEstimate}] is enabled', () {
      LDFlags.salesProForEstimate.value = true;
      bool hasEstimatesAction = DropdownListConstants.copyToJobTypeList.any((element) => element.id == "estimating");
      expect(hasEstimatesAction, isFalse);
    });
  });

  group("DropdownListConstants@copyToJobTypeList should show 'Documents' label instead of Form / Proposal", () {
    test("'Form / Proposal' label should not be displayed", () {
      bool hasFormOrProposalLabel = DropdownListConstants.copyToJobTypeList.any((element) => element.label == "Form / Proposal");
      expect(hasFormOrProposalLabel, isFalse);
    });

    test("'Documents' label should be displayed in place of 'Form / Proposal'", () {
      bool hasDocumentsLabel = DropdownListConstants.copyToJobTypeList.any((element) => element.label == "Documents");
      expect(hasDocumentsLabel, isTrue);
    });
  });

  group("DropdownListConstants@copyToJobTypeList should show 'Photos & Files' label instead of 'Photos & Documents'", () {
    test("'Photos & Documents' label should not be displayed", () {
      bool hasPhotosAndDocumentsLabel = DropdownListConstants.copyToJobTypeList.any((element) => element.label == "Photos & Documents");
      expect(hasPhotosAndDocumentsLabel, isFalse);
    });

    test("'Photos & Files' label should be displayed in place of 'Photos & Documents'", () {
      bool hasPhotosAndFilesLabel = DropdownListConstants.copyToJobTypeList.any((element) => element.label == "Photos & Files");
      expect(hasPhotosAndFilesLabel, isTrue);
    });
  });
}