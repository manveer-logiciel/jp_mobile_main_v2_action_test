
import 'package:jobprogress/common/services/company_settings.dart';
import 'package:jobprogress/core/constants/company_seetings.dart';

// Mocked data

class JobFormMockedData {

  JobFormMockedData() {
    formFieldsJson = formFieldJsonData();
  }

  late List<Map<String, dynamic>> formFieldsJson;

  List<Map<String, dynamic>> jobBasicInformation = [
    {
      "key": "sync_with", 
      "name": "Sync With", 
      "showField": "true"
    },
    {
      "key": "flags", 
      "name": "Flags", 
      "showField": "true"
    },
    {
      "key": "job_name", 
      "name": "Job Name", 
      "showField": "true"
    },
    {
      "key": "job_division", 
      "name": "Job Division", 
      "showField": "true"
    },
    {
      "key": "job_alt_id", 
      "name": "Job #", 
      "showField": "true"
    },
    {
      "key": "lead_number", 
      "name": "Lead #", 
      "showField": "true"
    },
    {
      "key": "job_rep_estimator", 
      "name": "Job Rep / Estimator", 
      "showField": "true"
    },
    {
      "key": "category", 
      "name": "Category", 
      "showField": "true"
    },
    {
      "key": "other_information", 
      "name": "Other Information", 
      "showField": "true"
    },
    {
      "key": "job_duration", 
      "name": "Job Duration", 
      "showField": "true"
    },
    {
      "key": "trade_workType", 
      "name": "Trade & Work Type", 
      "required": "true", 
      "showField": "true"
    },
    {
      "key": "job_description", 
      "name": "Job Description", 
      "required": "true", 
      "showField": "true"
    },
    {
      "key": "project",
      "name": "Project",
      "showField": "true"
    },
  ];

  final jobAddressField = {
    "key": "job_address", 
    "name": "Job Address", 
    "showField": "true"
  };

  final customFields = {
    "key": "custom_fields", 
    "name": "Custom Fields", 
    "showField": "true"
  };

  final contactPerson = {
    "key": "contact_person", 
    "name": "Contact Person", 
    "showField": "true"
  };


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

      case 'hide_custom_fields':
        formFieldsJson.last["showField"] = "false";
        tempJson.addAll(formFieldsJson);
        break;

      case 'show_custom_fields':
        formFieldsJson.last["showField"] = "true";
        tempJson.addAll(formFieldsJson);
        break;

      case 'delete':
        tempJson = null;
        break;

    }

    CompanySettingsService.companySettings[CompanySettingConstants.prospectCustomize] = {
      'value' : {
        'JOB': tempJson,
        'MULTI_JOB' : {
          'PARENT_JOB':tempJson,
          'PROJECT' : null,
        }
      }
    };
  }

  List<Map<String, dynamic>> formFieldJsonData() => [
    ...jobBasicInformation,
    jobAddressField,
    contactPerson,
    customFields
  ];
}