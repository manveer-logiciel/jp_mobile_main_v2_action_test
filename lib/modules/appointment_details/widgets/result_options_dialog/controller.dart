
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/appointment/appointment.dart';
import 'package:jobprogress/common/models/appointment/appointment_result/appointment_result_option_fields.dart';
import 'package:jobprogress/common/models/appointment/appointment_result/appointment_result_options.dart';
import 'package:jobprogress/common/repositories/appointment.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/single_select_helper.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class AppointmentResultOptionsDialogController extends GetxController {

  AppointmentResultOptionsDialogController(this.resultOptions, this.appointment);

  final List<AppointmentResultOptionsModel> resultOptions; // for storing all available fields
  final AppointmentModel appointment; // for storing appointment

  List<JPSingleSelectModel> fieldsFilter = []; // for storing available field filter
  List<AppointmentResultOptionFieldModel> fieldsList = []; // for storing currently selected fields list

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String selectedFilter = ''; // stores selected filter to display corresponding fields

  bool isLoading = false; // used to manage state while saving/updating appointment result

  @override
  void onInit() {
    setUpFieldsFilter();
    super.onInit();
  }

  // setUpFieldsFilter() : will initiates filter list along with setup initial filter
  void setUpFieldsFilter() {
    // setting up filter list
    for (var option in resultOptions) {
      fieldsFilter.add(JPSingleSelectModel(label: option.name?.capitalize ?? '', id: option.id.toString()));
    }
    // setting up filter
    if(fieldsFilter.isNotEmpty) {
      // On editing time loading selected filter
      bool isSelectedValueExists = appointment.resultOption == null ? false : fieldsFilter.any((element) => element.id == appointment.resultOption!.id.toString());
      selectedFilter = !isSelectedValueExists
          ? fieldsFilter.first.id
          : appointment.resultOption!.id.toString();
      // updating fields
      updateFields(selectedFilter);
    }

  }

  // showFieldsSelector() : will display filters to select from
  void showFieldsSelector() {
    SingleSelectHelper.openSingleSelect(fieldsFilter, selectedFilter, 'select_request_options'.tr.toUpperCase(), (value) {
      updateFields(value);
      Get.back();
    });
  }

  // updateFields() : will display fields as per selected filter
  void updateFields(String val) {
    formKey = GlobalKey<FormState>();
    selectedFilter = val;
    fieldsList.clear(); // making list empty
    final fields = resultOptions.firstWhere((element) => element.id.toString() == val);
    fieldsList.addAll(fields.fields ?? []); // adding new fields to list
    update();
  }

  String? validateField(String value) {
    if (value.isEmpty) {
      return "this_field_is_required".tr;
    }

    return '';
  }

  void validateAndSave() {
    if(formKey.currentState!.validate()) {
      Helper.hideKeyboard();
      saveResults();
    }
  }

  Future<void> saveResults() async {
    try {
      toggleIsLoading();
      List<int> requestOptionIds = [];

      for (var data in fieldsFilter) {
        requestOptionIds.add(int.parse(data.id));
      }

      Map<String, dynamic> params = {
        'id' : appointment.id,
        ...AppointmentResultOptionsModel.toSaveFieldsJson(
          requestOptionId: selectedFilter,
          requestOptionIds: requestOptionIds,
          fields: fieldsList,
        ),
      };

      final response = await AppointmentRepository().saveAppointmentResults(params);

      // updating appointment data
      appointment.id = response.id;
      appointment.isRecurring = response.isRecurring;
      appointment.results = response.results;
      appointment.resultOptionIds = response.resultOptionIds;
      appointment.resultOption = response.resultOption;

      Get.back(result: appointment); // sending callback with updated details to detail page

    } catch (e) {
      rethrow;
    } finally {
      toggleIsLoading();
    }
  }

  void toggleIsLoading() {
    isLoading = !isLoading;
    update();
  }

}