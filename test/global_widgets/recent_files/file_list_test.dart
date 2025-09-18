import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/global_widgets/recent_files/files_list.dart';
import 'package:jp_mobile_flutter_ui/Thumb/type.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../integration_test/core/test_helper.dart';

void main() {

  Widget buildWidget(List<FilesListingModel> files) {
    return TestHelper.buildWidget(
        Material(
          child: JobOverViewFilesList(
            files: files,
            type: FLModule.estimate,
          ),
        )
    );
  }

  FilesListingModel tempFile = FilesListingModel(
    id: "1",
    name: "test",
    showThumbImage: false,
    updatedAt: DateTime.now().subtract(const Duration(days: 5)).toString(),
  );

  setUpAll(() {
    DateTimeHelper.setUpTimeZone();
  });

  testWidgets("JobOverViewFilesList should have a fixed height of 180", (widgetTester) async {
    List<FilesListingModel> files = [tempFile];

    await widgetTester.pumpWidget(buildWidget(files));
    expect(find.byType(JobOverViewFilesList), findsOneWidget);
    expect((find.byType(SizedBox).at(0).evaluate().single.widget as SizedBox).height, 180);
  });

  group("JobOverViewFilesList should display relative time", () {
    testWidgets("Relative time should be displayed correctly over file", (widgetTester) async {
      List<FilesListingModel> files = [tempFile];

      await widgetTester.pumpWidget(buildWidget(files));
      expect((find.byType(JPText).at(2).evaluate().single.widget as JPText).text, "5 days ago");
    });

    testWidgets("Relative time should not be displayed over folder", (widgetTester) async {
      List<FilesListingModel> files = [tempFile..jpThumbType = JPThumbType.folder];

      await widgetTester.pumpWidget(buildWidget(files));
      expect(find.text("5 days ago"), findsNothing);
    });
  });
}