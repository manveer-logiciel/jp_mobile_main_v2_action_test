import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:jobprogress/common/enums/attach_file.dart';
import 'package:jobprogress/common/enums/date_picker_type.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/enums/supplier_form_type.dart';
import 'package:jobprogress/common/extensions/date_time/index.dart';
import 'package:jobprogress/common/models/address/address.dart';
import 'package:jobprogress/common/models/files_listing/delivery_date.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_quick_action_params.dart';
import 'package:jobprogress/common/models/forms/common/params.dart';
import 'package:jobprogress/common/models/forms/common/section.dart';
import 'package:jobprogress/common/models/forms/place_srs_order/data.dart';
import 'package:jobprogress/common/models/forms/place_srs_order/fields.dart';
import 'package:jobprogress/common/models/suppliers/branch.dart';
import 'package:jobprogress/common/models/timezone/timezone_model.dart';
import 'package:jobprogress/common/repositories/estimations.dart';
import 'package:jobprogress/common/repositories/job.dart';
import 'package:jobprogress/common/repositories/material_lists.dart';
import 'package:jobprogress/common/repositories/material_supplier.dart';
import 'package:jobprogress/common/repositories/timezone_repository.dart';
import 'package:jobprogress/common/services/files_listing/forms/place_srs_order_form/bind_validator.dart';
import 'package:jobprogress/common/services/files_listing/set_view_delivery_date/index.dart';
import 'package:jobprogress/common/services/forms/value_selector.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/constants/dropdown_list_constants.dart';
import 'package:jobprogress/core/constants/file_uploder.dart';
import 'package:jobprogress/core/constants/requested_delivery_time_constant.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/core/utils/form/validators.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/modules/files_listing/forms/place_supplier_order/controller.dart';
import 'package:jobprogress/modules/files_listing/forms/place_supplier_order/form/sections/widgets/personal_details.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../../../core/constants/date_formats.dart';
import '../../../../../core/constants/delivery_service_constant.dart';
import '../../../worksheet/helpers.dart';

/// [PlaceSupplierOrderFormService] used to manage form data. It is responsible for all the data additions, deletions and updates
/// - This service directly deal with form data independent of controller
class PlaceSupplierOrderFormService extends PlaceSrsOrderFormData {

  PlaceSupplierOrderFormService({
    required super.update,
    required this.validateForm,
    required this.onDataChange,
    super.job,
    required super.worksheetId,
    super.deliveryDate,
    super.type = MaterialSupplierType.srs,
    super.forSupplierId
  });

  VoidCallback validateForm; // helps in performing validation in service

  PlaceSupplierOrderFormController? _controller; // helps in managing controller without passing object

  PlaceSupplierOrderFormController get controller => _controller ?? PlaceSupplierOrderFormController();

  Function(String) onDataChange;

  set controller(PlaceSupplierOrderFormController value) {
    _controller = value;
  }

  late PlaceSupplierOrderFormBindValidator bindValidatorService;

  // initForm(): initializes form data
  Future<void> initForm() async {
    switch (type) {
      case MaterialSupplierType.srs:
        await initSRSOrderForm();
        break;
      case MaterialSupplierType.beacon:
        await initBeaconOrderForm();
        break;
      case MaterialSupplierType.abc:
        await initABCOrderForm();
        break;
    }

    // additional delay for all widgets to get rendered and setup data
    await Future.delayed(const Duration(milliseconds: 500), setInitialJson);
  }

  Future<void> initSRSOrderForm() async {
    try {
      // fetching worksheet details from server
      fileListingModel = await EstimatesRepository.fetchWorksheet({'id': worksheetId});
      fileListingModel?.deliveryDateModel = DeliveryDateModel(deliveryDate: deliveryDate);
      // fetching billing address from server
      shipToAddressList = await MaterialSupplierRepository().getAllSRSShipAddress(fileListingModel?.worksheet?.materialList?.forSupplierId);
      // fetching timezone from server
      await fetchTimeZones();
      // fetching material dates from server
      await fetchMaterialDeliveryDates();
      // fetching timezone from server
      await fetchDeliveryTypes();

      // parsing dynamic fields
      setUpFields();

      // binding validators with fields
      bindValidatorService = PlaceSupplierOrderFormBindValidator(this);
      bindValidatorService.bind();

      // filling form data
      setFormData();

    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> initBeaconOrderForm() async {
    try {
      // fetching worksheet details from server
      fileListingModel = await EstimatesRepository.fetchWorksheet({'id': worksheetId});
      // parsing dynamic fields
      setUpFields();
      // binding validators with fields
      bindValidatorService = PlaceSupplierOrderFormBindValidator(this);
      bindValidatorService.bind();
      // filling form data
      setFormData();
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> initABCOrderForm() async {
    try {
      // fetching worksheet details from server
      fileListingModel = await EstimatesRepository.fetchWorksheet({'id': worksheetId});
      // parsing dynamic fields
      setUpFields();
      // binding validators with fields
      bindValidatorService = PlaceSupplierOrderFormBindValidator(this);
      bindValidatorService.bind();
      // filling form data
      setFormData();
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      update();
    }
  }

  /// [setUpFields] set up fields to sections. Sections are in the order
  /// - Company Contact
  /// - Shipping Address
  /// - Billing address
  /// - P.O Details
  void setUpFields() {
    final List<FormSectionModel> srsSections = [
      // company contact section
      FormSectionModel(
        name: "company_contact".tr.toUpperCase(),
        fields: PlaceSrsOrderFormFieldsData.companyContactfields,
        isExpanded: true,
      ),
      // shipping address section
      FormSectionModel(
        name: "shipping_address".tr.toUpperCase(),
        fields: PlaceSrsOrderFormFieldsData.shippingAddressfields,
        wrapInExpansion: false,
      ),
      // billing address section
      FormSectionModel(
        name: "billing_address".tr.toUpperCase(),
        fields: PlaceSrsOrderFormFieldsData.biliingAddressfields,
      ),
      // place order details section
      FormSectionModel(
        name: "po_details".tr.toUpperCase(),
        fields: PlaceSrsOrderFormFieldsData.placeSRSOrderfields(onDataChange),
      ),
      FormSectionModel(
        avoidContentPadding: true,
        wrapInExpansion: false,
        isExpanded: true,
        name: "attachment".tr,
        fields: PlaceSrsOrderFormFieldsData.attachmentField
      )
    ];

    final List<FormSectionModel> beaconSections = [
      // shipping address section
      FormSectionModel(
        name: "shipping_address".tr.toUpperCase(),
        fields: PlaceSrsOrderFormFieldsData.shippingAddressfields,
        wrapInExpansion: false,
        isExpanded: true
      ),
      // place order details section
      FormSectionModel(
        name: "po_details".tr.toUpperCase(),
        fields: PlaceSrsOrderFormFieldsData.placeBeaconOrderFields(onDataChange),
        isExpanded: true,
      ),
    ];

    final List<FormSectionModel> abcSections = [
      // shipping address section
      FormSectionModel(
        name: "shipping_address".tr.toUpperCase(),
        fields: PlaceSrsOrderFormFieldsData.shippingAddressfields,
        wrapInExpansion: false,
      ),
      // company contact section
      FormSectionModel(
        name: "company_contact".tr.toUpperCase(),
        fields: PlaceSrsOrderFormFieldsData.companyContactfields,
        isExpanded: true,
      ),
      // Shipping Method
      FormSectionModel(
        name: "shipping_method".tr.toUpperCase(),
        fields: PlaceSrsOrderFormFieldsData.shippingMethodField,
        isExpanded: true
      ),
      // po section
      FormSectionModel(
        name: "po_details".tr.toUpperCase(),
        fields: PlaceSrsOrderFormFieldsData.placeABCOrderFields(onDataChange),
        isExpanded: true
      ),
    ];

    List<FormSectionModel> sections = [];

    switch (type) {
      case MaterialSupplierType.srs:
        sections = srsSections;
        break;
      case MaterialSupplierType.beacon:
        sections = beaconSections;
        break;
      case MaterialSupplierType.abc:
        sections = abcSections;
        break;
    }

    sections.removeWhere((section) => section.fields.isEmpty);

    allFields.clear();
    for (var section in sections) {
      allFields.addAll(section.fields);
    }

    allSections.clear();
    allSections.addAll(sections);
  }

  Future<void> fetchTimeZones() async {
    try {
      dynamic response = await TimezoneRepository.fetchTimezones();
      List<TimezoneModel> list = response["list"];
      for (var element in list) {
        timezoneList.add(
          JPSingleSelectModel(
            id: element.id.toString(),
            label: element.name ?? "",
          ),
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchMaterialDeliveryDates() async {
    try {
      final params = {
        'job_id': job!.id.toString(),
        'without_material': 1,
      };
      final list = await JobRepository.fetchMaterialDeliveryDate(params);
      for (int i = 0; i < list.length; i++) {
        deliveryDateList.add(
          JPSingleSelectModel(
            id: list[i]['id'].toString(),
            label: list[i]['delivery_date'].toString(),
            subLabel: list[i]['note'].toString(),
          ),
        );
      }

      if (list.isNotEmpty) {
        deliveryDateList.add(
          JPSingleSelectModel(
            id: 'custom',
            label: 'custom'.tr,
          ),
        );

        selectedDeliveryDateId = deliveryDateList[0].id;
        materialDeliveryDateController.text = deliveryDateList[0].label;
        materialDeliveryNoteController.text = deliveryDateList[0].subLabel;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> fetchDeliveryTypes() async {
    try {
      int? srsSupplierId = fileListingModel?.worksheet?.materialList?.forSupplierId;
      SupplierBranchModel? srsBranchDetails = await MaterialSupplierRepository().getSRSBranchDetails(fileListingModel!.worksheet!.branchCode!, srsSupplierId);
      List<dynamic> list = srsBranchDetails?.deliveryTypeNames ?? [];
      for (int i = 0; i < list.length; i++) {
        deliveryTypeList.add(
          JPSingleSelectModel(
            id: i.toString(),
            label: list[i].toString(),
          ),
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> openPersonalDetailBottomSheet() async {
    nameController.text = name;
    phoneController.text = phone;
    emailController.text = email;
    personaladdress = AddressModel.fromJson(companyAddress.toJson());
    initialPersonalDetailsJson = personalDetailsJson();

    await showJPBottomSheet(
      isScrollControlled: true,
      ignoreSafeArea: false,
      child: (_) {
        return PersonalDetailsForm(controller: controller);
      },
    );
    update();
  }

  /// [onTapMaterialDate] is used to select material delivery date based on type
  /// For [MaterialSupplierType.srs] it will open bottom sheet to select date & add material delivery note
  /// For [MaterialSupplierType.beacon] it will directly open date picker to select material date
  Future<void> onTapMaterialDate() async {
    switch (type) {
      case MaterialSupplierType.srs:
        await openAddDeliveryDateBottomSheet();
        break;
      case MaterialSupplierType.beacon:
        selectMaterialDeliveryDate();
        break;
      case MaterialSupplierType.abc:
        selectRequestedDeliveryDate();
        break;
    }
  }

  Future<void> selectMaterialDeliveryDate() async {
    FormValueSelectorService.selectDate(
        initialDate: materialDeliveryDate?.toString(),
        isPreviousDateSelectionAllowed: false,
        date: materialDeliveryDate,
        controller: materialDeliveryDateController,
        onDateSelected: (date) {
          materialDeliveryDate = date;
          materialDeliveryDateController.text = DateTimeHelper.convertSlashIntoHyphen(date.toString().substring(0, 10));
          update();
          onDataChange("");
        },
    );
  }

  Future<void> selectRequestedDeliveryDate() async {
    FormValueSelectorService.selectDate(
      initialDate: materialDeliveryDate?.toString(),
      isPreviousDateSelectionAllowed: false,
      date: materialDeliveryDate,
      controller: materialDeliveryDateController,
      firstDate: minimumRequestedDate,
      onDateSelected: (date) {
        materialDeliveryDate = date;
        materialDeliveryDateController.text = DateTimeHelper.format(materialDeliveryDate, DateFormatConstants.dateOnlyFormat);
        update();
        onDataChange("");
      },
    );
  }

  Future<void> openAddDeliveryDateBottomSheet() async {
    FilesListingQuickActionParams fileParams = FilesListingQuickActionParams(
      fileList: [fileListingModel!], 
      onActionComplete: (fileListing, val) {
        fileListingModel?.deliveryDateModel = fileListing.deliveryDateModel;
        materialDeliveryDateController.text = DateTimeHelper.convertSlashIntoHyphen(fileListing.deliveryDateModel?.deliveryDate ?? '');
        materialDeliveryNoteController.text = fileListing.deliveryDateModel?.note ?? '';
        materialDeliveryDate = DateTimeHelper.stringToDateTime(fileListing.deliveryDateModel?.deliveryDate);
      },
    );
    if (deliveryDateList.isEmpty) {
      await showJPBottomSheet(
        child: (_) {
          return SetViewDeliveryDateDialog(action: FLQuickActions.placeSRSOrder, fileParams: fileParams, isSRSOrder: true);
        },
      );
      onDataChange("");
      update();
    } else {
      FormValueSelectorService.openSingleSelect(
        list: deliveryDateList,
        title: 'select_delivery_date'.tr,
        controller: materialDeliveryDateController,
        selectedItemId: selectedDeliveryDateId,
        onValueSelected: (val) async {
          selectedDeliveryDateId = val;
          if (val == 'custom') {
            await showJPBottomSheet(child: (_) => SetViewDeliveryDateDialog(action: FLQuickActions.placeSRSOrder, fileParams: fileParams));
          } else {
            final selectedDeliveryDate = FormValueSelectorService.getSelectedSingleSelect(deliveryDateList, val);
            materialDeliveryDateController.text = selectedDeliveryDate.label;
            materialDeliveryDate = DateTimeHelper.stringToDateTime(selectedDeliveryDate.label);
            materialDeliveryNoteController.text = selectedDeliveryDate.subLabel;
          }
          onDataChange("");
          update();
        },
      );
    }
  }

  void toggleLoading(bool val) {
    isLoading = val;
    update();
  }

  void toggleIsDeliveryTime(bool val) {
    isDeliveryTimeEnable = val;
    deliveryTimeValidator();
  }

  void changeShippingMethod(dynamic val) {
    switch (type) {
      case MaterialSupplierType.srs:
        changeSRSShippingMethod(val);
        break;
      case MaterialSupplierType.beacon:
        changeBeaconShippingMethod(val);
        break;
      case MaterialSupplierType.abc:
        break;
    }
  }

  void changeSRSShippingMethod(dynamic val) {
    isDeliveryMethod = val;
    if(!isDeliveryMethod) {
      materialDeliveryDateController.text = '';
      isDateTBDChecked = false;
      if(isSrsV2 && requestedDeliveryTimeList.any((element) => element.id == RequestedDeliveryTimeConstant.tbd)) {
        requestedDeliveryTimeList.removeLast();
        selectedRequestedDeliveryTimeId = '';
        requestedDeliveryTimeController.text = '';
      }
    }
    Future.delayed(const Duration(seconds: 1), () => onDataChange("")); // show error on delivery type field once rendered on form
    update();
  }

  /// [changeBeaconShippingMethod] is used to change beacon shipping method
  /// it is responsible for updating the delivery time options
  /// and it resets the selected delivery time on changing shipping method
  void changeBeaconShippingMethod(dynamic val) {
    isDeliveryMethod = val;
    deliveryTypeController.text = "";
    selectedDeliveryTypeId = "";
    deliveryTypeList = isDeliveryMethod
        ? DropdownListConstants.beaconOrderDeliveryTypes
        : DropdownListConstants.beaconOrderPickUpTypes;
    Future.delayed(const Duration(seconds: 1), () => onDataChange("")); // show error on delivery type field once rendered on form
    update();
  }

  // isFieldEditable() : to handle edit-ability of form fields
  bool isFieldEditable() => !controller.isSavingForm;

  /// [saveForm] helps in saving form
  Future<void> saveForm() async {
    try {
      FilesListingModel? response = await placeOrderApi();
      if (response != null) {
        Helper.showToastMessage("order_saved".tr);
        Get.back(result: true);
      } 
    } catch (e) {
      rethrow;
    }
  }

  /// [placeOrderApi] helps sends a request to server to place supplier order
  Future<FilesListingModel?> placeOrderApi() async {
    final params = placeSupplierOrderFormJson();
    switch (type) {
      case MaterialSupplierType.srs:
        return await MaterialListsRepository.createPlaceSRSOrder(params);
      case MaterialSupplierType.beacon:
        return await createPlaceBeaconOrder(params);
      case MaterialSupplierType.abc:
        return await MaterialListsRepository.createPlaceABCOrder(Helper.getSupplierId(key: CommonConstants.abcSupplierId), params);
    }
  }

  void selectTimeZone() {
    FormValueSelectorService.openSingleSelect(
      list: timezoneList,
      title: 'timezone'.tr,
      controller: timeZoneController,
      selectedItemId: selectedTimezoneId,
      onValueSelected: (val) {
        selectedTimezoneId = val;
        onDataChange("");
      },
    );
  }

  void selectDeliveryType() {
    String title = getDeliveryTypeTitle();

    FormValueSelectorService.openSingleSelect(
      list: deliveryTypeList,
      title: title,
      controller: deliveryTypeController,
      selectedItemId: selectedDeliveryTypeId,
      onValueSelected: (val) {
        selectedDeliveryTypeId = val;
        onDataChange("");
      },
    );
  }

  /// [getDeliveryTypeTitle] Returns the title for the delivery type based on the [MaterialSupplierType].
  String getDeliveryTypeTitle() {
    String title = "";

    // Switch based on the supplier type
    switch (controller.type) {
    // If the supplier type is SRS and ABC, set the title to 'select_delivery_type'
      case MaterialSupplierType.srs:
      case MaterialSupplierType.abc:
        title = 'select_delivery_type'.tr;
        break;
    // If the supplier type is Beacon
      case MaterialSupplierType.beacon:
      // If the delivery method is selected, set the title to 'select_delivery_time',
      // else set it to 'select_pickup_time'
        title = controller.service.isDeliveryMethod ? 'select_delivery_time'.tr : 'select_pickup_time'.tr;
        break;
    }

    return title;
  }

  void openTimePicker({required DatePickerType datePickerType, String? initialTime}) {
    DateTimeHelper.openTimePicker(
      initialTime: initialTime,
      helpText: datePickerType == DatePickerType.start 
        ? "start_time".tr 
        : "end_time".tr,
      ).then((pickedTime) {
        if(pickedTime != null) {
          switch (datePickerType) {
            case DatePickerType.start:
              startDateTime = DateTimeHelper.dateTimePickerTimeFormatting(startDateTime ?? DateTime.now().toString(), pickedTime.toDateTime().toString());
              break;
            case DatePickerType.end:
              endDateTime = DateTimeHelper.dateTimePickerTimeFormatting(endDateTime ?? DateTime.now().toString(), pickedTime.toDateTime().toString());
              break;
          }
          deliveryTimeValidator();
        }
      },
    );
  }

  bool validateShippingAddress(InputFieldParams field, {bool scrollOnValidate = false}) {
    bool validationFailed = false;
    if (field.isRequired) {
      bool? isValidAddress = shippingAddressFormKey.currentState?.validate(scrollOnValidation: true);
      validationFailed = isValidAddress != null ? !isValidAddress : false;
    }
    return validationFailed;
  }

  String? fieldValidator(dynamic value) => FormValidator.requiredFieldValidator(value);

  String? preferredTimeValidator() => FormValidator.requiredFieldValidator(startDateTime ?? '', errorMsg: 'please_select_preferred_time'.tr);

  bool validateTimezone(InputFieldParams field) {
    bool validationFailed = false;
    if (field.isRequired) {
      validationFailed = fieldValidator(timeZoneController.text) != null;
      if (field.scrollOnValidate) timeZoneController.scrollAndFocus();
    }
    return validationFailed;
  }

  bool validatePOJobName(InputFieldParams field) {
    bool validationFailed = false;
    if (field.isRequired) {
      validationFailed = fieldValidator(poJobNameController.text) != null;
      if (field.scrollOnValidate) poJobNameController.scrollAndFocus();
    }
    return validationFailed;
  }

  bool validateEstimateBranchArrivalTime(InputFieldParams field) {
    if(isEstimateBranchArrivalTimeFieldVisible) {
      bool validationFailed = false;
      if (field.isRequired) {
        validationFailed = fieldValidator(estimateBranchArrivalTimeController.text) != null;
        if (field.scrollOnValidate) estimateBranchArrivalTimeController.scrollAndFocus();
      }
      return validationFailed;
    } else {
      return false;
    }
  }

   // showFileAttachmentSheet() : displays quick actions sheet to select files from
  void showFileAttachmentSheet() {
    FormValueSelectorService.selectAttachments(
      attachments: attachments,
      uploadType: FileUploadType.srsOrder,
      type: AttachmentOptionType.srsOrderAttachment,
      isSrs: true,
      maxSize: Helper.flagBasedUploadSize(fileSize: CommonConstants.totalAttachmentMaxSize),
      onSelectionDone: () {
        update();
      }
    );
  }

  String? materialDeliveryDateValidator(dynamic value) {
    String? requiredFieldMsg = FormValidator.requiredFieldValidator(value);
    bool inNotValidDate = materialDeliveryDate?.isBefore(DateTime.now()) ?? false;
    return inNotValidDate && !isDateTBDChecked ? 'requested_delivery_date_invalid_message'.tr : requiredFieldMsg;
  }
  
  bool validateMaterialDeliveryDate(InputFieldParams field) {
    bool validationFailed = false;
    if (field.isRequired) {
      validationFailed = materialDeliveryDateValidator(materialDeliveryDateController.text) != null;
      if (field.scrollOnValidate) materialDeliveryDateController.scrollAndFocus();
    }
    return validationFailed;
  }

  String? deliveryTypeValidator(dynamic value) => FormValidator.requiredFieldValidator(value);

  String? poJobNameValidator(dynamic value) => FormValidator.requiredFieldValidator(value);

  bool validateDeliveryType(InputFieldParams field) {
    bool validationFailed = false;
    if (field.isRequired && isDeliveryMethod) {
      validationFailed = deliveryTypeValidator(deliveryTypeController.text) != null;
      if (field.scrollOnValidate) deliveryTypeController.scrollAndFocus();
    }
    return validationFailed;
  }

  String? requestedDeliveryTimeValidator(dynamic value) => FormValidator.requiredFieldValidator(value);

  String? deliveryTimeValidator() {
    deliveryTimeErrorText = null;
    if (validateFormOnDataChange) {
      bool isValidTime = false;
      if(Helper.isValueNullOrEmpty(startDateTime) || Helper.isValueNullOrEmpty(endDateTime)) {
        isValidTime = false;
      } else {
        isValidTime = Jiffy.parse(startDateTime ?? "").isBefore(Jiffy.parse(endDateTime ?? ""));
      }
      if(isTimeRangeOrSpecificTimeType && !isSpecificTimeType) {
        deliveryTimeErrorText = !isValidTime ? 'requested_delivery_time_error_message'.tr : null;
      } else if(isSpecificTimeType) {
        deliveryTimeErrorText = preferredTimeValidator();
      } else {
        deliveryTimeErrorText = !isValidTime && isDeliveryTimeEnable ? 'requested_delivery_time_invalid_message'.tr : null;
      }
    }
    update();
    return deliveryTimeErrorText;
  }

  bool validateDeliveryTime(InputFieldParams field) {
    bool validationFailed = false;
    if (isDeliveryTimeEnable || isTimeRangeOrSpecificTimeType) {
      validationFailed = deliveryTimeValidator() != null;
      if(validationFailed) {
        Scrollable.ensureVisible(controller.service.materialDeliveryDateController.focusNode.context!);
      }
    }
    return validationFailed;
  }

  /// [validateAllFields] validates all fields in a sequence manner
  Future<bool> validateAllFields() async {

    bool validationFailed = false;
    bool scrollOnValidate = false;
    FormSectionModel? errorSection;
    InputFieldParams? errorField;
    dynamic Function(InputFieldParams)? scrollAndFocus;

    validateForm(); // helps in displaying field error
    for (InputFieldParams field in allFields) {
      field.scrollOnValidate = scrollOnValidate;
      // validating individual fields
      final isNotValid = validators[field.key]?.call(field) ?? false;

      // This condition helps in only tracking details of very first failed section/field
      // Loop will validate all the fields but focus will be on error field only
      if(isNotValid && !validationFailed) {
        // setting up error field details
        scrollAndFocus ??= validators[field.key];
        validationFailed = isNotValid;
        scrollOnValidate = false;
        errorSection ??= allSections.firstWhereOrNull((section) => section.fields.contains(field));
        errorField ??= field;
      }
    }

    if(validationFailed && errorSection != null) {
      // helps in expanding section if not expanded
      await expandErrorSection(errorSection);
      errorField?.scrollOnValidate = true;
      scrollAndFocus?.call(errorField!);
    }

    return validationFailed;
  }

  /// [expandErrorSection] expands section of which field has error
  Future<void> expandErrorSection(FormSectionModel? section) async {
    // expanding section only if it's nt expanded before
    if(section == null || section.isExpanded || !section.wrapInExpansion) return;

    section.isExpanded = true;
    update();

    // additional delay for section to get expanded
    await Future<void>.delayed(const Duration(milliseconds: 500));
  }

  // removeAttachedItem() : will remove items from selected attachments
  void removeAttachedItem(int index) {
    attachments.removeAt(index);
    update();
  }

  Future<FilesListingModel?> createPlaceBeaconOrder(Map<String, dynamic> params) async {
    try {
      return await MaterialListsRepository.createPlaceBeaconOrder(params);
    } on DioException catch (e) {
      WorksheetHelpers.handleBeaconError(e, isCreatingBeaconOrder: true);
    }
    return null;
  }

  void selectRequestedDeliveryTime() {
    FormValueSelectorService.openSingleSelect(
      list: requestedDeliveryTimeList,
      title: 'requested_delivery_time'.tr,
      controller: requestedDeliveryTimeController,
      selectedItemId: selectedRequestedDeliveryTimeId,
      onValueSelected: (val) {
        selectedRequestedDeliveryTimeId = val;
        onDataChange("");
        update();
      },
    );
  }

  void onDeliveryServiceChange(dynamic value) {
    selectedDeliveryService = value;
    isDeliveryMethod = selectedDeliveryService?.id == DeliveryServiceConstant.deliveryCode;
    deliveryTypeController.text = '';
    selectedDeliveryTypeId = '';
    update();
    onDataChange.call("");
  }

  void onTapTBDDate(bool value) {
    isDateTBDChecked = !value;
    materialDeliveryDateController.text = isDateTBDChecked ? RequestedDeliveryTimeConstant.tbd : '';
    if(isSrsV2) {
      if(isDateTBDChecked) {
        requestedDeliveryTimeList.add(JPSingleSelectModel(label: 'ship_date_tbd'.tr, id: RequestedDeliveryTimeConstant.tbd));
        selectedRequestedDeliveryTimeId = RequestedDeliveryTimeConstant.tbd;
        requestedDeliveryTimeController.text = 'ship_date_tbd'.tr;
      } else {
        if(selectedRequestedDeliveryTimeId.isEmpty) {
          requestedDeliveryTimeController.text = '';
        }
        if (requestedDeliveryTimeList.any((element) => element.id == RequestedDeliveryTimeConstant.tbd)) {
          requestedDeliveryTimeList.removeLast();
          if(selectedRequestedDeliveryTimeId == RequestedDeliveryTimeConstant.tbd) {
            selectedRequestedDeliveryTimeId = '';
            requestedDeliveryTimeController.text = '';
          }
        }
      }
    }
    update();
    onDataChange.call("");
  }

  bool validateCompanyContact(InputFieldParams field) {
    bool validationFailed = false;
    if(Helper.isValueNullOrEmpty(name)) {
      companyContactErrorText = 'name_is_required'.tr;
      validationFailed = true;
    } else if(Helper.isValueNullOrEmpty(phone)) {
      companyContactErrorText = 'phone_number_is_required'.tr;
      validationFailed = true;
    } else if(type != MaterialSupplierType.abc && Helper.isValueNullOrEmpty(email)) {
      companyContactErrorText = 'email_is_required'.tr;
      validationFailed = true;
    } else if(type != MaterialSupplierType.abc && Helper.isValueNullOrEmpty(companyAddress)) {
      companyContactErrorText = 'address_is_required'.tr;
      validationFailed = true;
    } else {
      if(type == MaterialSupplierType.abc) {
        validationFailed = false;
      } else {
        if(Helper.isValueNullOrEmpty(companyAddress.address)) {
          companyContactErrorText = 'address_is_required'.tr;
          validationFailed = true;
        } else if(Helper.isValueNullOrEmpty(companyAddress.city)) {
          companyContactErrorText = 'city_is_required'.tr;
          validationFailed = true;
        } else if(Helper.isValueNullOrEmpty(companyAddress.zip)) {
          companyContactErrorText = 'zip_code_is_required'.tr;
          validationFailed = true;
        } else if(Helper.isValueNullOrEmpty(companyAddress.state)) {
          companyContactErrorText = 'state_is_required'.tr;
          validationFailed = true;
        }
      }
    }
    onDataChange("");
    update();
    return validationFailed;
  }

  void selectEstimateBranchArrivalTime() {
    FormValueSelectorService.openSingleSelect(
      list: estimateBranchArrivalTimeList,
      title: 'estimate_branch_arrival_time'.tr,
      controller: estimateBranchArrivalTimeController,
      selectedItemId: selectedEstimateBranchArrivalTime,
      onValueSelected: (val) {
        selectedEstimateBranchArrivalTime = val;
        onDataChange("");
      },
    );
  }
}