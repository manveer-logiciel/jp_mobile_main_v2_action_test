import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/modules/files_listing/widgets/files_list_tile.dart';
import 'package:jp_mobile_flutter_ui/Thumb/type.dart';
import '../../../../integration_test/core/test_helper.dart';

void main() {

  final tempFile = FilesListingModel(
    id: "1",
    name: "test",
    updatedAt: DateTime.now().subtract(const Duration(days: 5)).toString(),
    size: 0,
  );

  Widget buildWidget() {
    return TestHelper.buildWidget(
        Material(
          child: FilesListTile(
            data: tempFile,
            type: FLModule.jobPhotos,
            relativeTime: tempFile.getRelativeTime(),
          ),
        )
    );
  }

  setUpAll(() {
    DateTimeHelper.setUpTimeZone();
  });

  group("FilesListTile should display relative time", () {
    testWidgets("Relative time should be displayed correctly over file", (widgetTester) async {
      await widgetTester.pumpWidget(buildWidget());
      expect(find.text("5 days ago"), findsOneWidget);
    });

    testWidgets("Relative time should not be displayed over folder", (widgetTester) async {
      tempFile.jpThumbType = JPThumbType.folder;
      await widgetTester.pumpWidget(buildWidget());
      expect(find.text("5 days ago"), findsNothing);
    });

    testWidgets("Relative time should not be displayed when last modified is empty", (widgetTester) async {
      tempFile.updatedAt = "";
      await widgetTester.pumpWidget(buildWidget());
      expect(find.text("5 days ago"), findsNothing);
    });
  });
}