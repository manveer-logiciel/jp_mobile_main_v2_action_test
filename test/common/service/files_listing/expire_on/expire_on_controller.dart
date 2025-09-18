import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_quick_action_params.dart';
import 'package:jobprogress/common/services/files_listing/expires_on/controller.dart';

void main() {

  late ExpiresOnController controller;

  void setModuleOnController(FLModule type) {
    controller = ExpiresOnController(FilesListingQuickActionParams(
        fileList: [],
        type: type,
        onActionComplete: (_, __) {}
    ));
  }

  group("ExpiresOnController@getFileType should set correct type as per module", () {
    test("In case of ${FLModule.jobContracts} media type should be [contract]", () {
      setModuleOnController(FLModule.jobContracts);
      final result = controller.getFileType();
      expect(result, 'contract');
    });
  });

}