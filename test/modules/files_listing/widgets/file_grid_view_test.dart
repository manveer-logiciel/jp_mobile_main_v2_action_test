import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/global_widgets/gridview/index.dart';
import 'package:jobprogress/modules/files_listing/controller.dart';
import 'package:jobprogress/modules/files_listing/widgets/files_grid_view.dart';
import 'package:jp_mobile_flutter_ui/Thumb/type.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../../integration_test/core/test_helper.dart';

void main() {

  FilesListingController controller = FilesListingController();
  
  Widget buildWidget() {
    return TestHelper.buildWidget(
      Material(
        child: Column(
          children: [
            FilesGridView(
              controller: controller
            ),
          ],
        ),
      )
    );
  }

  setUpAll(() {
    DateTimeHelper.setUpTimeZone();
    controller.isLoading = false;
    controller.isInMoveFileMode = false;
    controller.isInCopyFileMode = false;
    controller.resourceList = [
      FilesListingModel(
        id: "1",
        name: "test",
        updatedAt: DateTime.now().subtract(const Duration(days: 5)).toString(),
        size: 0,
      ),
    ];
  });
  
  testWidgets("FilesGridView should have child aspect ration of 0.92", (widgetTester) async {
    await widgetTester.pumpWidget(buildWidget());
    final gridView = widgetTester.widget<JPGridView>(find.byType(JPGridView));
    expect((gridView.gridDelegate as SliverGridDelegateWithMaxCrossAxisExtent).childAspectRatio, 0.92);
  });

  group("FilesGridView should display relative time", () {
    testWidgets("Relative time should be displayed correctly over file", (widgetTester) async {
      await widgetTester.pumpWidget(buildWidget());
      expect((find.byType(JPText).at(2).evaluate().single.widget as JPText).text, "5 days ago");
    });

    testWidgets("Relative time should not be displayed over folder", (widgetTester) async {
      controller.resourceList[0].jpThumbType = JPThumbType.folder;
      await widgetTester.pumpWidget(buildWidget());
      expect(find.text("5 days ago"), findsNothing);
    });
  });
}