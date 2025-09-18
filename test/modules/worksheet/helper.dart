import 'package:get/get.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/enums/worksheet.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/modules/worksheet/controller.dart';

class WorksheetControllerTestHelper {

  static WorksheetFormController getWorksheetParams(String type) {
    Get.routing.args = getParams(type);
    WorksheetFormController controller = WorksheetFormController();
    controller.onInit();
    return controller;
  }

  static Map<String, dynamic> getParams(String type) {
    switch (type) {
      case 'add':
        return {
          NavigationParams.jobId: 10,
          NavigationParams.worksheetType: FLModule.estimate,
          NavigationParams.worksheetFormType: WorksheetFormType.add,
        };

      case 'edit':
        return {
          NavigationParams.jobId: 10,
          NavigationParams.worksheetId: 5,
          NavigationParams.dbUnsavedResourceId: null,
          NavigationParams.worksheetType: FLModule.estimate,
          NavigationParams.worksheetFormType: WorksheetFormType.edit,
        };

      case 'auto_save_add':
        return {
          NavigationParams.jobId: 10,
          NavigationParams.dbUnsavedResourceId: 5,
          NavigationParams.worksheetType: FLModule.estimate,
          NavigationParams.worksheetFormType: WorksheetFormType.edit,
        };

      case 'auto_save_edit':
        return {
          NavigationParams.jobId: 10,
          NavigationParams.worksheetId: 5,
          NavigationParams.dbUnsavedResourceId: 5,
          NavigationParams.worksheetType: FLModule.estimate,
          NavigationParams.worksheetFormType: WorksheetFormType.edit,
        };

      default:
        return {};
    }
  }
}