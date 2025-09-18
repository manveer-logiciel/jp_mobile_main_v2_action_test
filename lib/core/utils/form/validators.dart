import 'package:get/get.dart';
import 'package:jobprogress/common/models/address/address.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/sql/user/user.dart';
import 'package:jobprogress/common/models/sql/user/user_limited.dart';
import 'package:jobprogress/common/services/phone_masking.dart';
import 'package:jobprogress/core/constants/recurring_constant.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';

class FormValidator {
  static String? requiredFieldValidator(String val, {String? errorMsg}) {
    if (val.trim().isEmpty) {
      return errorMsg ?? 'this_field_is_required'.tr;
    }
    return null;
  }

  static String? requiredAmountValidator(String val, {String? errorMsg}) {
    if (val.trim().isEmpty || (double.tryParse(val) ?? 0) <= 0) {
      return errorMsg ?? 'this_field_is_required'.tr;
    }
    return null;
  }

  static String? requiredListValidator(dynamic val, {String? errorMsg}) {
    if(val.isEmpty){
      return errorMsg ?? 'this_field_is_required'.tr;
    }
    return null;
  }

  static RegExp typeToFrequencyValidator(String type) {
    switch (type) {
      case "minute":
        return RegExp(r'^(?:[1-9]|1\d|2\d|3\d|4\d|5\d|60)$');

      case "hour":
        return RegExp(r'^(?:[1-9]|1\d|2[0-4])$');

      case "day":
        return RegExp(r'^(?:[1-9]|\d\d|\d\d\d)$');

      case "day_limited":
        return RegExp(r'^(?:[1-9]|1[0-9]|2[0-9]|3[0-1])$');

      case "week":
        return RegExp(r'^(?:[1-9]|[1-4]\d|5[0-2])$');

      case "month":
        return RegExp(r'^(?:1[0-2]|[1-9])$');

      default:
        return RegExp(r'\d');
    }
  }

  static String setMaxAvailableFrequencyValue(String type, String val) {
    int comparisonValue = int.parse(val).abs();

    switch (type) {
      case "minute":
        return comparisonValue > 60 ? '60' : comparisonValue.toString();

      case "hour":
        return comparisonValue > 24 ? '24' : comparisonValue.toString();

      case "day":
      case "day_limited":
        return comparisonValue > 31 ? '31' : comparisonValue.toString();

      case "week":
        return comparisonValue > 52 ? '52' : comparisonValue.toString();

      case "month":
        return comparisonValue > 12 ? '12' : comparisonValue.toString();

      default:
        return '1';
    }
  }

  static bool validateOverLappedRecurring({
    required DateTime startDateTime,
    required DateTime endDateTime,
    required String repeat,
  }) {
    final differenceInMinutes = startDateTime.difference(endDateTime).inMinutes.abs();

    switch (repeat) {
      case RecurringConstants.daily:
        return Duration(minutes: differenceInMinutes).inDays < 1;

      case RecurringConstants.weekly:
        return Duration(minutes: differenceInMinutes).inDays < 7;

      case RecurringConstants.monthly:
        return Duration(minutes: differenceInMinutes).inDays < 30;

      case RecurringConstants.yearly:
        return Duration(minutes: differenceInMinutes).inDays < 365;

      default:
        return true;
    }
  }

  static List<JPMultiSelectModel> validateAllUsersBelongToSameDivision({
    int? currentDivisionId,
    List<int?>? divisionIds,
    required List<JPMultiSelectModel> selectedUsers,
  }) {
    divisionIds ??= [];

    if (currentDivisionId != null) divisionIds.add(currentDivisionId);

    List<JPMultiSelectModel> userFromAnotherDivision = [];

    for (var user in selectedUsers) {
      if (user.additionData == null || user.additionData! is UserLimitedModel) continue;

      final tempUser = user.additionData as UserModel;

      bool isUserBelongToCurrentDivision = tempUser.divisions
          ?.any((division) =>
      divisionIds?.any((id) => id == division.id) ?? false)
          ?? false;

      if (!isUserBelongToCurrentDivision) {
        userFromAnotherDivision.add(user);
      }
    }

    return userFromAnotherDivision.toSet().toList();
  }

  static String? validateOccurrence(String val, {String? errorMsg}) {
    if (val.trim().isEmpty) {
      return errorMsg ?? 'this_field_is_required'.tr;
    } else if (int.parse(val) < 2) {
      return 'occurrence_error_message'.tr;
    }
    return null;
  }

  static String? validateAmount(String val, String? selectedInvoiceId, List<FilesListingModel>? invoiceList ){
    double? selectedBalance ;
    if(selectedInvoiceId!= null && selectedInvoiceId.isNotEmpty){
      selectedBalance =
          double.parse(
              invoiceList!.firstWhere((element) =>
              element.id == selectedInvoiceId).openBalance!
          );
    }
    if(selectedBalance != null && val.isNotEmpty && double.parse(val) > selectedBalance){
      return 'amount_should_not_be_greater_than_balance_due'.tr.capitalizeFirst;
    }
    return null;
  }

  static String? validateCreditAmount(String val, String? selectedInvoiceId, List<FilesListingModel>? invoiceList) {
    double? selectedBalance;
    if (selectedInvoiceId != null && selectedInvoiceId.isNotEmpty) {
      selectedBalance = double.parse(
          invoiceList!.firstWhere((element) => element.id == selectedInvoiceId)
              .openBalance!
      );
    }
    if (val.isEmpty || double.parse(val) <= 0) {
      return 'please_enter_valid_amount'.tr.capitalizeFirst;
    }
    if (selectedInvoiceId != null && selectedBalance != null &&
        double.parse(val) > selectedBalance) {
      return 'value_should_not_greater_than_invoice_value'.tr.capitalizeFirst;
    }
    return null;
  }

  static String? validatePhoneNumber(String val, {String? errorMsg, bool isRequired = true}) {
    if (val.trim().isEmpty && isRequired) {
      return errorMsg ?? 'this_field_is_required'.tr;
    } else if (val.isNotEmpty) {
      String phoneNo = PhoneMasking.unmaskPhoneNumber(val.trim());
      if(phoneNo.length < 8 || phoneNo.length > 12) {
        return 'phone_number_must_be_between_range'.tr;
      }
    }
    return null;
  }

  static String? validateEmail(String val, {String? errorMsg, bool isRequired = false}) {
    if (val.trim().isEmpty && isRequired) {
      return errorMsg ?? 'this_field_is_required'.tr;
    } else if (val.isNotEmpty && !GetUtils.isEmail(val.trim())) {
      return 'please_enter_valid_email'.tr;
    }
    return null;
  }

  static String? requiredDropDownValidator(List<dynamic> val, {String? errorMsg}) {
    if (val.isEmpty) {
      return errorMsg ?? 'this_field_is_required'.tr;
    }
    return null;
  }

  static String? validatePrice(dynamic price, {
    String? requiredErrorMsg, 
    String? invalidErrorMsg,
    bool isNumberRequired = true,
    bool shouldNotZero = false,
    /// [maxValue] can be used to value the max price allowed in price input field
    /// and [invalidRangeErrorMsg] can be used to show custom error message in
    /// case of range error. By default it will show 'invalid_price' error message
    num? maxValue,
    String? invalidRangeErrorMsg,
  }) {
    if (maxValue != null && (num.tryParse(price.toString()) ?? 0) > maxValue) {
      return invalidRangeErrorMsg ?? 'invalid_price'.tr;
    } else if(price.toString().isEmpty && isNumberRequired) {
      return requiredErrorMsg ?? 'price_is_required'.tr;
    } else if(Helper.isInvalidValue(price, shouldNotZero: shouldNotZero)) {
      return invalidErrorMsg ?? 'invalid_price'.tr;
    } else {
      return null;
    }
  }

  static String? validateUnit(dynamic unit, {String? requiredErrorMsg, String? invalidErrorMsg}) {
    if(unit.toString().isEmpty) {
      return requiredErrorMsg ?? 'unit_is_required'.tr.capitalize;
    } else {
       return null;
    }
  }

  static String? validateQty(dynamic qty,
      {String? requiredErrorMsg, String? invalidErrorMsg, bool isNumberRequired = true}) {
    if (qty.toString().isEmpty && isNumberRequired) {
      return requiredErrorMsg ?? 'quantity_is_required'.tr;
    } else if(Helper.isInvalidValue(qty)) {
      return invalidErrorMsg ?? 'invalid_quantity'.tr;
    } else {
      return null;
    }
  }

  static String? validateAddressForm(AddressModel? addressModel) {
    String completeAddress = "${addressModel?.address ?? ""}${addressModel?.addressLine1 ?? ""}${addressModel?.addressLine3 ?? ""}";

    if (Helper.isValueNullOrEmpty(completeAddress)
      || Helper.isValueNullOrEmpty(addressModel?.city)
      || Helper.isValueNullOrEmpty(addressModel?.country?.name)
      || Helper.isValueNullOrEmpty(addressModel?.zip)) {
      return "address_required".tr;
    } else {
      return null;
    }
  }


}