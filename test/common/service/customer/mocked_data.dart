
import 'package:jobprogress/common/services/company_settings.dart';
import 'package:jobprogress/core/constants/company_seetings.dart';

// Mocked data

class CustomerFormMockedData {

  CustomerFormMockedData() {
    formFieldsJson = formFieldJsonData();
  }

  late List<Map<String, dynamic>> formFieldsJson;

  List<Map<String, dynamic>> customerBasicInformation = [
    {
      "key": "email",
      "name": "Email",
      "showField": "true"
    },
    {
      "key": "commercial_customer_name",
      "name": "Customer Name",
      "showField": "true"
    },
    {
      "key": "referred_by",
      "name": "Referred By",
      "showField": "false"
    },
    {
      "key": "customer_name",
      "name": "Customer / Company Name",
      "required": "true",
      "showField": "true"
    },
    {
      "key": "salesman_customer_rep",
      "name": "Salesman / Customer Rep",
      "showField": "false"
    },
    {
      "key": "phone",
      "name": "Phone",
      "required": "true",
      "showField": "true"
    },
    {
      "key": "management_company",
      "name": "Management Company",
      "showField": "true"
    },
  ];

  final customerAddressField = {
    "key": "customer_address",
    "name": "Customer Address",
    "showField": "true"
  };

  final customFields = {
    "key": "custom_fields",
    "name": "Custom Fields",
    "showField": "true"
  };

  final companyNameField =   {
    "key": "company_name",
    "name": "Company Name",
    "showField": "true"
  };

  final otherInformationSection = [
    {
      "key": "other_information",
      "name": "Other Information",
      "showField": "true"
    },
    {
      "key": "customer_note",
      "name": "Customer Note",
      "showField": "true"
    },
    {
      "key": "canvasser",
      "name": "Canvasser",
      "showField": "true"
    },
    {
      "key": "property_name",
      "name": "Property Name",
      "showField": "true"
    },
    {
      "key": "qb_online",
      "name": "Sync with QuickBooks Online / Desktop",
      "showField": "true"
    },
    {
      "key": "call_center_rep",
      "name": "Call Center Rep",
      "showField": "true"
    },
  ];

  void companySettingModifier({String action = 'setup'}) {

    List<Map<String, dynamic>>? tempJson = [];

    switch (action) {
      case 'setup':
        tempJson.addAll(formFieldsJson);
        break;

      case 'visibility':
        tempJson.addAll(formFieldsJson);
        tempJson.first['showField'] = 'false';
        break;

      case 'remove':
        tempJson.addAll(formFieldsJson);
        tempJson.removeLast();
        break;

      case 'reorder':
        tempJson.addAll(formFieldsJson);
        final dataHolder = tempJson.first;
        tempJson.first = tempJson.last;
        tempJson.last = dataHolder;
        break;

      case 'delete':
        tempJson = null;
        break;

    }

    CompanySettingsService.companySettings[CompanySettingConstants.prospectCustomize] = {
      'value' : {
        'CUSTOMER': tempJson
      }
    };
  }

  List<Map<String, dynamic>> formFieldJsonData() => [
    ...customerBasicInformation,
    customerAddressField,
    companyNameField,
    ...otherInformationSection,
    customFields
  ];
}