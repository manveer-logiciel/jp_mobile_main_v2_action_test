import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_request_param.dart';

void main() {
  group("FileListingRequestParams.getJobContractParams should give api payload for loading contracts", () {
    test("Payload should contain valid [job_id]", () {
      final result = FilesListingRequestParam.getJobContractParams(1);
      expect(result, {"job_id": 1});
    });
  });
}