
import 'package:get/get.dart';
import 'package:jobprogress/common/models/forms/common/params.dart';
import 'package:jobprogress/core/constants/forms/customer_form.dart';

class CustomerFormFieldsData {

  static List<InputFieldParams> fields = [
    InputFieldParams(key: CustomerFormConstants.customerName, name: 'customer_name'.tr),
    InputFieldParams(key: CustomerFormConstants.commercialCustomerName, name: 'customer_name'.tr),
    InputFieldParams(key: CustomerFormConstants.companyName, name: 'company_name'.tr),
    InputFieldParams(key: CustomerFormConstants.email, name: 'email'.tr),
    InputFieldParams(key: CustomerFormConstants.phone, name: 'phone'.tr, isRequired: true),
    InputFieldParams(key: CustomerFormConstants.managementCompany, name: 'management_company'.tr),
    InputFieldParams(key: CustomerFormConstants.propertyName, name: 'property_name'.tr),
    InputFieldParams(key: CustomerFormConstants.customerAddress, name: 'customer_address'.tr),
    InputFieldParams(key: CustomerFormConstants.otherInformation, name: 'other_information'.tr),
    InputFieldParams(key: CustomerFormConstants.salesManCustomerRep, name: 'salesman_customer_rep'.tr),
    InputFieldParams(key: CustomerFormConstants.referredBy, name: 'referred_by'.tr),
    InputFieldParams(key: CustomerFormConstants.canvasser, name: 'canvasser'.tr),
    InputFieldParams(key: CustomerFormConstants.callCenterRep, name: 'call_center_rep'.tr),
    InputFieldParams(key: CustomerFormConstants.customerNote, name: 'customer_note'.tr),
    InputFieldParams(key: CustomerFormConstants.customFields, name: 'customer_fields'.tr),
  ];

}