import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/sql/uploader/file_uploader_params.dart';
import 'package:jobprogress/core/constants/file_uploder.dart';
import 'package:jobprogress/core/constants/locale.dart';
import 'package:jobprogress/core/utils/file_upload_helpers/upload_file_display_path.dart';
import 'package:jobprogress/translations/index.dart';

void main() {

  setUpAll(() {
    Get.addTranslations(JPTranslations().keys);
    Get.locale = LocaleConst.usa;
  });

  group("File in upload queue should show 'Documents' label instead of 'Form / Proposal'", () {
    test("'Form / Proposal' label should not be shown", () {
      final result = UploadFileTypeDisplayPath.path(
          FileUploaderParams(
              type: FileUploadType.formProposals,
              job: JobModel(id: 1, customerId: 2)
          )
      );

      expect(result.contains('Form / Proposal'), isFalse);
    });

    test("'Documents' label should be shown", () {
      final result = UploadFileTypeDisplayPath.path(
        FileUploaderParams(
          type: FileUploadType.formProposals,
          job: JobModel(id: 1, customerId: 2)
        )
      );

      expect(result, contains('Documents'));
    });
  });

  group("File in upload queue should show 'Photos & Files' label instead of 'Photos & Documents'", () {
    test("'Photos & Documents' label should not be shown", () {
      final result = UploadFileTypeDisplayPath.path(
        FileUploaderParams(
          type: FileUploadType.photosAndDocs,
          job: JobModel(id: 1, customerId: 2)
        )
      );

      expect(result.contains('Photos & Documents'), isFalse);
    });

    test("'Photos & Files' label should be shown", () {
      final result = UploadFileTypeDisplayPath.path(
        FileUploaderParams(
          type: FileUploadType.photosAndDocs,
          job: JobModel(id: 1, customerId: 2)
        )
      );

      expect(result, contains('Photos & Files'));
    });
  });
}