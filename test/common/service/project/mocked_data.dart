import 'package:jobprogress/common/services/company_settings.dart';
import 'package:jobprogress/core/constants/company_seetings.dart';

class ProjectFormMockData{
  ProjectFormMockData() {
    formFieldsJson = formFieldJsonData();
  }

  late List<Map<String, dynamic>> formFieldsJson;

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
        'MULTI_JOB' : {
          'PROJECT': tempJson
        }
      }
    };
  }


  List<Map<String, dynamic>> formFieldJsonData() => [
    {
      "key":"sync_with",
      "name":"Sync With",
      "showField":"true"
    },
    {
      "key":"project_alt_id",
      "name":"Project #",
      "showField":"true"
    },
    {
      "key":"project_rep_estimator",
      "name":"Project Rep / Estimator",
      "showField":"true"
    },
    {
      "key":"trade_workType",
      "name":"Trade & Work Type",
      "required":"true",
      "showField":"true"
    },
    {
      "key":"project_description",
      "name":"Project Description",
      "required":"true",
      "showField":"true"
    },
    {
      "key":"status",
      "name":"Project Status",
      "showField":"true"
    },
    {
      "key":"project_duration",
      "name":"Project Duration",
      "showField":"true"
    }
  ];
}