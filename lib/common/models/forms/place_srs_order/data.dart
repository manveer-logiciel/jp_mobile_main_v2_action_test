import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:jobprogress/common/enums/supplier_form_type.dart';
import 'package:jobprogress/common/models/address/address.dart';
import 'package:jobprogress/common/models/attachment.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/forms/common/params.dart';
import 'package:jobprogress/common/models/forms/common/section.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/sql/state/state.dart';
import 'package:jobprogress/common/models/suppliers/srs/srs_ship_to_address.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/company_settings.dart';
import 'package:jobprogress/core/constants/company_seetings.dart';
import 'package:jobprogress/core/constants/date_formats.dart';
import 'package:jobprogress/common/services/phone_masking.dart';
import 'package:jobprogress/core/constants/delivery_service_constant.dart';
import 'package:jobprogress/core/constants/delivery_type_constant.dart';
import 'package:jobprogress/core/constants/dropdown_list_constants.dart';
import 'package:jobprogress/core/constants/forms/place_srs_order.dart';
import 'package:jobprogress/core/constants/requested_delivery_time_constant.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/global_widgets/forms/address/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../../core/constants/delivery_time_type_constant.dart';
import '../../../../core/utils/helpers.dart';
import '../../phone.dart';

class PlaceSrsOrderFormData {

  // Controller
  JPInputBoxController timeZoneController = JPInputBoxController();
  JPInputBoxController materialDeliveryDateController = JPInputBoxController();
  JPInputBoxController materialDeliveryNoteController = JPInputBoxController();
  JPInputBoxController deliveryTypeController = JPInputBoxController();
  JPInputBoxController noteController = JPInputBoxController();
  JPInputBoxController nameController = JPInputBoxController();
  JPInputBoxController phoneController = JPInputBoxController();
  JPInputBoxController emailController = JPInputBoxController();
  JPInputBoxController poJobNameController = JPInputBoxController();
  JPInputBoxController requestedDeliveryTimeController = JPInputBoxController();
  JPInputBoxController estimateBranchArrivalTimeController = JPInputBoxController();

  bool isLoading = true;
  bool isDeliveryTimeEnable = false;
  bool isDeliveryMethod = true;

  DateTime? materialDeliveryDate;

  // Form helpers
  AddressModel shippingAddress = AddressModel(id: -1);
  final shippingAddressFormKey = GlobalKey<AddressFormState>();
  AddressModel companyAddress = AddressModel(id: -1);
  AddressModel personaladdress = AddressModel(id: -1);
  final personalAddressFormKey = GlobalKey<AddressFormState>();
  SrsShipToAddressModel billingAddress = SrsShipToAddressModel(id: -1);

  // Selection IDs
  String selectedTimezoneId = '';
  String selectedDeliveryDateId = '';
  String selectedDeliveryTypeId = '';
  String selectedDeliveryServiceId = '';
  String selectedRequestedDeliveryTimeId = '';
  String? startDateTime;
  String? endDateTime;
  String name = '';
  String phone = '';
  String email = '';

  // Selection Lists
  List<JPSingleSelectModel> categoryList = [];
  List<JPSingleSelectModel> timezoneList = [];
  List<JPSingleSelectModel> deliveryTypeList = [];
  List<JPSingleSelectModel> deliveryDateList = [];
  List<JPSingleSelectModel> deliveryServiceList = [];
  List<JPSingleSelectModel> requestedDeliveryTimeList = [];
  List<JPSingleSelectModel> estimateBranchArrivalTimeList = [];

  // Section separator helpers
  List<FormSectionModel> allSections = [];
  List<InputFieldParams> allFields = [];

  Map<String, dynamic> initialJson = {}; // holds initial json for comparison
  Map<String, dynamic> initialPersonalDetailsJson = {}; // holds initial personal details json for comparison
  Map<String, Function(InputFieldParams)> validators = {}; // holds list of validators
  bool validateFormOnDataChange = false; // helps in continuous validation after user submits form

  JobModel? job;
  FilesListingModel? fileListingModel;
  String worksheetId;
  List<SrsShipToAddressModel> shipToAddressList = []; 
  List<AttachmentResourceModel> attachments = []; // contains attachments being displayed to user
  String? deliveryTimeErrorText = '';

  VoidCallback update; // helps in updating data
  MaterialSupplierType type; // helps in identifying the material supplier type and displays the form accordingly

  JPSingleSelectModel? selectedDeliveryService;

  bool isDateTBDChecked = false;

  String? minimumRequestedDate;

  bool get isTimeRangeOrSpecificTimeType => selectedRequestedDeliveryTimeId == DeliveryTimeTypeConstant.timeRange
      || selectedRequestedDeliveryTimeId == DeliveryTimeTypeConstant.specificTime;

  bool get isSpecificTimeType => selectedRequestedDeliveryTimeId == DeliveryTimeTypeConstant.specificTime;

  String companyContactErrorText = '';

  PhoneModel? phoneField;

  bool get isSrsDeliveryMethod => type == MaterialSupplierType.srs && isDeliveryMethod;
  bool get isEstimateBranchArrivalTimeFieldVisible => !isSrsDeliveryMethod && materialDeliveryDateController.text.isNotEmpty && isSrsV2;

  String selectedEstimateBranchArrivalTime = '';

  String? deliveryDate;
  int? forSupplierId;
  bool get isSrsV2 => Helper.isSRSv2Id(forSupplierId);

  PlaceSrsOrderFormData({
    required this.update,
    this.job,
    this.fileListingModel,
    required this.worksheetId,
    required this.type,
    this.deliveryDate,
    this.forSupplierId
  });

  /// [setFormData] set-up initial data for form
  void setFormData() {
    switch (type) {
      case MaterialSupplierType.srs:
        setSRSFormData();
        break;
      case MaterialSupplierType.beacon:
        setBeaconFormData();
        break;
      case MaterialSupplierType.abc:
        setABCFormData();
        break;
    }
  }

  void setSRSFormData() {
    if (materialDeliveryDateController.text.isNotEmpty) {
      materialDeliveryDate = DateTimeHelper.stringToDateTime(materialDeliveryDateController.text);
    } else {
      setMaterialDate();
    }
    if(DropdownListConstants.srsRequestedDeliveryTimes.any((element) => element.id == RequestedDeliveryTimeConstant.tbd)) {
      DropdownListConstants.srsRequestedDeliveryTimes.removeLast();
    }
    if(isSrsV2) {
      requestedDeliveryTimeList = DropdownListConstants.srsRequestedDeliveryTimes;
      estimateBranchArrivalTimeList = getEstimateBranchArrivalTimeList();
    }
    if (AuthService.userDetails != null) {
      final loggedInUserDetails = AuthService.userDetails!;
      name = loggedInUserDetails.fullName;
      email = loggedInUserDetails.email ?? '';
      if (loggedInUserDetails.phones?.isNotEmpty ?? false) {
        phone = PhoneMasking.maskPhoneNumber(loggedInUserDetails.phones![0].number ?? '');
      }
      companyAddress = AddressModel(
        id: -1,
        city: loggedInUserDetails.companyDetails?.city ?? '',
        address: loggedInUserDetails.companyDetails?.address ?? '',
        addressLine1: loggedInUserDetails.companyDetails?.addressLine1 ?? '',
        addressLine3: '',
        zip: loggedInUserDetails.companyDetails?.zip ?? '',
        state: StateModel(
          id: loggedInUserDetails.companyDetails?.stateId ?? -1,
          code: loggedInUserDetails.companyDetails?.stateCode ?? '',
          countryId: loggedInUserDetails.companyDetails?.countryId ?? -1,
          name: loggedInUserDetails.companyDetails?.stateName ?? '',
        ),
      );
      personaladdress = companyAddress;

    }
    if (job != null) {
      shippingAddress = AddressModel.fromJson((job!.address ?? job!.customer!.address!).toJson());
    }
    if (shipToAddressList.isNotEmpty) {
      billingAddress = shipToAddressList.firstWhere((address) => address.shipToSequenceId == fileListingModel!.worksheet!.shipToSequenceNumber);
    }

    final timeZone = CompanySettingsService.getCompanySettingByKey(CompanySettingConstants.timeZone);
    final selectedTimezone = timezoneList.firstWhereOrNull((tz) => tz.label.replaceAll(r'\', r'') == timeZone);
    selectedTimezoneId = selectedTimezone?.id ?? '';
    timeZoneController.text = selectedTimezone?.label ?? '';
  }

  /// [setBeaconFormData] set-up initial data for beacon form
  void setBeaconFormData() {
    deliveryTypeList = DropdownListConstants.beaconOrderDeliveryTypes;
    setMaterialDate();
    // In case Job is available then setting shipping address from Job
    if (job != null) {
      shippingAddress = AddressModel.fromJson((job!.address ?? job!.customer!.address!).toJson());
    }
  }

  void setABCFormData() {
    deliveryServiceList = DropdownListConstants.deliveryServices;
    selectedDeliveryService = deliveryServiceList[0];
    setMaterialDate();
    deliveryTypeList = DropdownListConstants.abcOrderDeliveryTypes;
    requestedDeliveryTimeList = DropdownListConstants.abcRequestedDeliveryTimes;
    if (AuthService.userDetails != null) {
      final loggedInUserDetails = AuthService.userDetails!;
      name = loggedInUserDetails.fullName;
      email = loggedInUserDetails.email ?? '';
      if (loggedInUserDetails.phones?.isNotEmpty ?? false) {
        phone = PhoneMasking.maskPhoneNumber(loggedInUserDetails.phones![0].number ?? '');
        phoneField = loggedInUserDetails.phones?.first;
        phoneField?.label = phoneField?.label?.toLowerCase();
      }
    }
    if (job != null) {
      shippingAddress = AddressModel.fromJson((job!.address ?? job!.customer!.address!).toJson());
    }
  }

  void setInitialJson() {
    initialJson = placeSupplierOrderFormJson();
    initialPersonalDetailsJson = personalDetailsJson();
  }

  /// [placeSupplierOrderFormJson] gives payload for place supplier order form
  /// on the basis of active supplier [type]
  Map<String, dynamic> placeSupplierOrderFormJson() {
    switch (type) {
      case MaterialSupplierType.srs:
        return placeSrsOrderFormJson();
      case MaterialSupplierType.beacon:
        return beaconOrderFormJson();
      case MaterialSupplierType.abc:
        return placeABCOrderFormJson();
    }
  }

  Map<String, dynamic> placeSrsOrderFormJson() {
    Map<String, dynamic> json = {};
    String startTime = DateTimeHelper.format(startDateTime, DateFormatConstants.timeOnlyFormat);
    String endTime = DateTimeHelper.format(endDateTime, DateFormatConstants.timeOnlyFormat);
    int? supplierId = fileListingModel?.worksheet?.materialList?.forSupplierId ?? Helper.getSupplierId();

    json["po_details"] = {
      "shipping_method": isDeliveryMethod ? deliveryTypeController.text : PlaceSrsOrderFormConstants.willCall,
      "timezone": timeZoneController.text,
      if(poJobNameController.text.isNotEmpty)
        "po_number": poJobNameController.text,
      if(isSrsV2) ...{
        "expected_delivery_date": isDateTBDChecked ? getAfterFiveYearDeliveryDate() : DateTimeHelper.convertSlashIntoHyphen(materialDeliveryDateController.text),
        "expected_delivery_time": isSrsDeliveryMethod ? selectedRequestedDeliveryTimeId : DateTimeHelper.format(startDateTime, DateFormatConstants.timeOnlyFormat),
      } else ...{
        "expected_delivery_date": DateTimeHelper.convertSlashIntoHyphen(materialDeliveryDateController.text),
        "expected_delivery_time": isDeliveryTimeEnable
            ? "${startTime.trim()} - ${endTime.trim()}"
            : " - ",
      }
    };
    json["customer_contact"] = personalDetailsJson();
    json["ship_to_address"] = shippingAddress.toPlaceSrsOrderJson();
    json["bill_to"] = billingAddress.addressModel.toPlaceSrsOrderJson();
    json['delivery_note'] = materialDeliveryNoteController.text;
    json['notes'] = noteController.text;
    json["material_list_id"] = fileListingModel?.worksheet?.materialListId;
    json['attachment_ids'] = List.generate(attachments.length, (index) => {
      index.toString(): attachments[index].id,
    }).toList();
    json['supplier_id'] = supplierId;
    return json;
  }

  /// [beaconOrderFormJson] gives payload for place beacon order form
  Map<String, dynamic> beaconOrderFormJson() {
    Map<String, dynamic> json = {};
    json["pickup_date"] = DateTimeHelper.convertSlashIntoHyphen(materialDeliveryDateController.text);
    json["material_list_id"] = fileListingModel?.worksheet?.materialListId;
    json["shipping_address"] = shippingAddress.toPlaceBeaconOrderJson();
    json["shipping_method"] = isDeliveryMethod ? 'D' : 'P';
    json["pickup_time"] = deliveryTypeController.text;
    json["special_instruction"] = noteController.text;
    json["purchase_order_no"] = poJobNameController.text;
    json["shipping_branch_code"] = fileListingModel?.worksheet?.branchCode;
    return json;
  }

  Map<String, dynamic> placeABCOrderFormJson() {
    return {
      "includes[0]": "delivery_date",
      "includes[1]": "supplier_order",
      "pickup_date": getPickupDate(),
      "pickup_details[from_time]:": DateTimeHelper.format(startDateTime, DateFormatConstants.timeOnlyServerFormat),
      "pickup_details[to_time]:": DateTimeHelper.format(endDateTime, DateFormatConstants.timeOnlyServerFormat),
      "pickup_details[pickup_time]:": getPickupTime(),
      "pickup_details[type_code]:": selectedRequestedDeliveryTimeId,
      "material_list_id": fileListingModel?.worksheet?.materialListId,
      "purchase_order": poJobNameController.text,
      "delivery_service": getDeliveryServiceCode(),
      "type_code": selectedDeliveryService?.id,
      "shipping_address": shippingAddress.toPlaceABCOrderJson(),
      "order_note": noteController.text,
      ...personalDetailsJson()
    };
  }

  Map<String, dynamic> personalDetailsJson({bool isForm = false}) {
    return type == MaterialSupplierType.abc ? {
      "contact[name]": name,
      "contact[email]": email,
      "contact[phone][label]": phoneField?.label ?? '',
      "contact[phone][extension]": phoneField?.ext ?? '',
      "contact[phone][phone]": PhoneMasking.unmaskPhoneNumber(phone)
    } : {
      "name": isForm ? nameController.text : name,
      "email": isForm ? emailController.text : email,
      "phone": isForm ? phoneController.text : phone,
      "address": isForm ? personaladdress.toPlaceSrsOrderJson() : companyAddress.toPlaceSrsOrderJson(),
    };
  }

  // checkIfNewDataAdded(): used to compare form data changes
  bool checkIfNewDataAdded() {
    final currentJson = placeSupplierOrderFormJson();
    return initialJson.toString() != currentJson.toString();
  }

  // checkIfNewPersonalDetailsDataAdded(): used to compare personal details form data changes
  bool checkIfNewPersonalDetailsDataAdded() {
    final currentJson = personalDetailsJson(isForm: true);
    return initialPersonalDetailsJson.toString() != currentJson.toString();
  }

  String getDeliveryServiceCode() {
    if(selectedDeliveryService?.id == DeliveryServiceConstant.deliveryCode) {
      return selectedDeliveryTypeId;
    } else if(selectedDeliveryService?.id == DeliveryServiceConstant.expressPickupCode) {
      return DeliveryTypeConstant.expCode;
    } else {
      return DeliveryTypeConstant.cpuCode;
    }
  }

  String getPickupDate() {
    if(isDateTBDChecked) {
      return '';
    } else {
      return DateTimeHelper.format(materialDeliveryDate, DateFormatConstants.dateServerFormat);
    }
  }

  String getPickupTime() {
    if(isSpecificTimeType) {
      return DateTimeHelper.format(startDateTime, DateFormatConstants.timeOnlyServerFormat);
    } else {
      return '';
    }
  }

  void setMaterialDate() {
    switch(type) {
      case MaterialSupplierType.srs:
      case MaterialSupplierType.beacon:
        if(!Helper.isValueNullOrEmpty(deliveryDate)) {
          materialDeliveryDateController.text = DateTimeHelper.format(DateTimeHelper.convertSlashIntoHyphen(deliveryDate!), DateFormatConstants.dateOnlyFormat);
          materialDeliveryDate = DateTimeHelper.stringToDateTime(DateTimeHelper.convertSlashIntoHyphen(deliveryDate!));
        } else {
          materialDeliveryDate = DateTimeHelper.stringToDateTime(materialDeliveryDateController.text);
        }
        break;
      case MaterialSupplierType.abc:
        String? givenDate;
        if(!Helper.isValueNullOrEmpty(deliveryDate)) {
          givenDate = DateTimeHelper.convertSlashIntoHyphen(deliveryDate!);
          materialDeliveryDate = DateTimeHelper.stringToDateTime(givenDate);
        } else {
          materialDeliveryDate = DateTimeHelper.now().add(const Duration(days: 1));
          givenDate = materialDeliveryDate?.toString();
        }
        materialDeliveryDateController.text = DateTimeHelper.format(givenDate, DateFormatConstants.dateOnlyFormat);
        minimumRequestedDate = DateTimeHelper.now().add(const Duration(days: 1)).toString();
        break;
    }
  }

  List<JPSingleSelectModel> getEstimateBranchArrivalTimeList() {
    final List<JPSingleSelectModel> timeList = [];
    final now = DateTimeHelper.now();

    DateTime startTime = DateTime(now.year, now.month, now.day, 7, 30);// Starting at 7:30 AM
    DateTime endTime = DateTime(now.year, now.month, now.day, 16, 15); // Ending at 4:15 PM

    while (startTime.isBefore(endTime) || startTime.isAtSameMomentAs(endTime)) {
      final formatedTime = DateTimeHelper.format(startTime, DateFormatConstants.timeOnlyFormat);
      timeList.add(JPSingleSelectModel(label: formatedTime, id: formatedTime));
      startTime = startTime.add(const Duration(minutes: 15));
    }
    return timeList;
  }

  String? getAfterFiveYearDeliveryDate() {
    final now = DateTimeHelper.now();
    final DateTime fiveYrsAddedDate = DateTime(now.year + 5, now.month, now.day);
    final formattedDate = DateTimeHelper.format(fiveYrsAddedDate, DateFormatConstants.dateOnlyFormat);
    return DateTimeHelper.convertSlashIntoHyphen(formattedDate);
  }

  String getPhoneDetails() {
    final phoneLabel = phoneField?.label?.capitalize;
    final phoneNumber = PhoneMasking.maskPhoneNumber(phone);
    final phoneExt = phoneField?.ext;
    final extText = 'ext'.tr.replaceAll(': ', '');

    if (Helper.isValueNullOrEmpty(phoneNumber)) return '';

    final label = Helper.isValueNullOrEmpty(phoneLabel) ? '' : '$phoneLabel - ';
    final extension = Helper.isValueNullOrEmpty(phoneExt) ? '' : ' $extText - $phoneExt';

    return '$label$phoneNumber$extension';
  }

}