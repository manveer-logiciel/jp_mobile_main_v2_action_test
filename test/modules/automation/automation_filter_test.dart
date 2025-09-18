import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/automation/filter.dart';
import 'package:jobprogress/core/constants/dropdown_list_constants.dart';
import 'package:jobprogress/modules/automation_listing/widget/filter_dialog/controller.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';

void main() {
  late AutomationFilterDialogController controller;
  setUp(() {
    AutomationFilterModel defaultKeys = AutomationFilterModel(
      duration: 'YTD',
      divisionIds: null
    );
    AutomationFilterModel selectedFilters = AutomationFilterModel(
      duration: 'YTD',
      divisionIds: [1, 2],
    );
    controller = AutomationFilterDialogController(selectedFilters, defaultKeys,skipDivisionFetch: true);
    controller.filterKeys = selectedFilters;
    controller.defaultKeys = defaultKeys;
  });
  test('AutomationFilterDialogController@updateDuration should update selectedDuration and durationTextController correctly', () {
    const newDuration = "YTD";

    controller.updateDuration(newDuration);

    expect(controller.selectedDuration, newDuration);
    expect(controller.durationTextController.text, DropdownListConstants.durationsList.firstWhere(
      (element) => element.id == newDuration).label
    );
  });

  test('AutomationFilterDialogController@updateDivisions should update divisionTextController and filterKeys.divisionIds correctly', () {
    final selectedDivisions = [
      JPMultiSelectModel(id: "1", label: "Division 1", isSelect: true),
      JPMultiSelectModel(id: "2", label: "Division 2", isSelect: false),
      JPMultiSelectModel(id: "3", label: "Division 3", isSelect: true),
    ];

    controller.updateDivisions(selectedDivisions);

    expect(controller.divisionsTextController.text, "Division 1, Division 3");
    expect(controller.filterKeys.divisionIds, [1, 3]);
  });

  group('AutomationFilterDialogController@updateResetButtonDisable  should  update reset button disability correctly', () {
    test('Should disable reset button if filterKeys match defaultKeys', () {
      controller.filterKeys = AutomationFilterModel(duration: "monthly");
      controller.defaultKeys = AutomationFilterModel(duration: "monthly");

      controller.updateResetButtonDisable();

      expect(controller.isResetButtonDisable, true);
    });

    test('Should enable reset button if filterKeys differ from defaultKeys', () {
      controller.filterKeys = AutomationFilterModel(duration: "weekly");
      controller.defaultKeys = AutomationFilterModel(duration: "monthly");

      controller.updateResetButtonDisable();

      expect(controller.isResetButtonDisable, false);
    });
  });

  test('AutomationFilterDialogController@getStartDate should return formatted start date or default text', () {
    controller.filterKeys.startDate = "2024-11-25";

    expect(controller.getStartDate(), "11/25/2024"); // Assuming helper converts date correctly.

    controller.filterKeys.startDate = "";
    expect(controller.getStartDate(), "start_date".tr);
  });

  test('AutomationFilterDialogController@getEndDate should return formatted end date or default text', () {
    controller.filterKeys.endDate = "2024-11-30";

    expect(controller.getEndDate(), "11/30/2024");

    controller.filterKeys.endDate = null;
    expect(controller.getEndDate(), "end_date".tr);
  });

  test('AutomationFilterDialogController@cleanFilterKeys should reset filter keys', () {
    final defaultFilters = AutomationFilterModel();
    controller.cleanFilterKeys(defaultFilters: defaultFilters);
    expect(controller.divisionsTextController.text, '');
    expect(controller.durationTextController.text, 'YTD');
    expect(controller.selectedDuration, 'YTD');
    expect(controller.filterKeys.divisionIds, null);
    expect(controller.divisionList, isEmpty);
  });

}
