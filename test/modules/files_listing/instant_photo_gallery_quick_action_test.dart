import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_quick_action_params.dart';
import 'package:jobprogress/common/services/files_listing/quick_action_options.dart';
import 'package:jobprogress/common/services/files_listing/quick_actions_list.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/model.dart';

void main() {
  test(
      'When file multiple images are selected common options should be displayed',
      () {
    Map<String, List<JPQuickActionModel>> result =
        FileListingQuickActionsList.getInstantPhotoGalleryActionsList(
            FilesListingQuickActionParams(
      isInSelectionMode: true,
      fileList: [],
      onActionComplete: (_, __) {},
    ));

    final tempResult = result[FileListingQuickActionsList.fileActions]!;

    expect(tempResult.contains(FileListingQuickActionOptions.delete), true);
    expect(tempResult.contains(FileListingQuickActionOptions.rename), false);
    expect(tempResult.contains(FileListingQuickActionOptions.rotate), true);
    expect(tempResult.contains(FileListingQuickActionOptions.info), false);
    expect(tempResult.contains(FileListingQuickActionOptions.print), false);
    expect(tempResult.contains(FileListingQuickActionOptions.moveToJob), true);
  });

  test('When single images are selected all options should be displayed', () {
    Map<String, List<JPQuickActionModel>> result =
        FileListingQuickActionsList.getInstantPhotoGalleryActionsList(
            FilesListingQuickActionParams(
      isInSelectionMode: false,
      fileList: [],
      onActionComplete: (_, __) {},
    ));

    final tempResult = result[FileListingQuickActionsList.fileActions]!;

    expect(tempResult.contains(FileListingQuickActionOptions.delete), true);
    expect(tempResult.contains(FileListingQuickActionOptions.rename), true);
    expect(tempResult.contains(FileListingQuickActionOptions.rotate), true);
    expect(tempResult.contains(FileListingQuickActionOptions.info), true);
    expect(tempResult.contains(FileListingQuickActionOptions.print), true);
    expect(tempResult.contains(FileListingQuickActionOptions.moveToJob), true);
  });
}
