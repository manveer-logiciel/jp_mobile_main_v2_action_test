import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/index.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/model.dart';
import '../../../../global_widgets/bottom_sheet/index.dart';
import '../../../enums/file_listing.dart';
import '../../../enums/job_financial_listing.dart';
import '../../../models/customer/customer.dart';
import '../../../models/files_listing/create_file_actions.dart';
import '../../../models/files_listing/files_listing_model.dart';
import '../../../models/job/job.dart';
import '../../../models/job_financial/financial_listing.dart';
import '../../job_financial/quick_action.dart';
import 'more_action_handler.dart';
import 'more_actions_list.dart';

class FilesListingMoreActionsService {
  static Future<void> openMoreAction(CreateFileActions params) async {
    Map<String, List<JPQuickActionModel>> actions = FileListingMoreActionsList.getActions(params);
    showJPBottomSheet(
        child: (_) => JPQuickAction(
              key: const Key(WidgetKeys.filesListingMoreActionsKey),
              mainList:
                  params.fileList.isEmpty || params.fileList.first.isDir == 0
                      ? actions[FileListingMoreActionsList.fileActions]!
                      : actions[FileListingMoreActionsList.folderActions]!,
              title: "more_actions".tr,
              onItemSelect: (value) {
                Get.back();
                if (params.type == FLModule.financialInvoice) {
                  FinancialListingModel modal = FinancialListingModel.fromJobInvoicesJson(params.fileList[0].toJobInvoiceJson());
                  JobFinancialService.handleQuickAction(
                    val: value,
                    type: JFListingType.jobInvoicesWithoutThumb,
                    job: params.jobModel!,
                    model: modal,
                    unAppliedCreditList: params.unAppliedCreditList,
                    onActionComplete: (dynamic model, action) {
                      params.onActionComplete(FilesListingModel.fromFinancialInvoiceJson(model.toJobInvoiceJson()),action);
                    },
                  );
                } else {
                  handleQuickAction(value, params, job: params.jobModel,customerModel: params.customerModel);
                }
              },
            ),
        isScrollControlled: true);
  }

  static Future<void> handleQuickAction(String val, CreateFileActions params,{String? phone, JobModel? job, CustomerModel? customerModel}) async {
    switch (val) {
      case "FLQuickActions.measurementForm":
        FileListMoreActionHandlers.navigateToMeasureForm(params, val);
        break;
      case "FLQuickActions.eagleView":
        FileListMoreActionHandlers.navigateToEagleViewForm(params, FLQuickActions.eagleView);
        break;

      case "FLQuickActions.quickMeasure":
        FileListMoreActionHandlers.navigateToQuickMeasureForm(params, FLQuickActions.quickMeasure);
        break;
      
      case "FLQuickActions.createInsurance": 
        FileListMoreActionHandlers.navigateToCreateInsuranceScreen(params, val);
        break;

      case "FLQuickActions.uploadInsurance":  
        FileListMoreActionHandlers.pickInsuranceDocsAndUpload(params, val);
        break;

      case "FLQuickActions.jobFormProposalTemplate":
        FileListMoreActionHandlers.navigateToTemplates(params, val);
        break;

      case "FLQuickActions.jobFormProposalMerge":
        FileListMoreActionHandlers.navigateToTemplates(params, val, merge: true);
        break;

      case "FLQuickActions.upload":
      case "FLQuickActions.hover":
        FileListMoreActionHandlers.actionComplete(params, val);
        break;

      case "FLQuickActions.dropBox":
        String saveAs = saveAsLocationForApi(params.type);
        FileListMoreActionHandlers.showAttachFileSheet(FLModule.dropBoxListing, params, saveAs: saveAs, jobId: job?.id, action: val);
        break;

      case "FLQuickActions.handwrittenTemplate":
        FileListMoreActionHandlers.navigateToHandwrittenTemplates(params, val);
        break;

      case "FLQuickActions.worksheet":
        FileListMoreActionHandlers.navigateToCreateWorksheet(params, val);
        break;
      case "FLQuickActions.spreadSheetTemplate":
        FileListMoreActionHandlers.navigateToEstimatesTemplates(params);
        break;
      case "FLQuickActions.newSpreadsheet":
        FileListMoreActionHandlers.saveSpreadsheet(params, val);
        break;
      case "FLQuickActions.uploadExcel":
        FileListMoreActionHandlers.uploadExcel(params,val);
        break;      
    }
  }

  static String saveAsLocationForApi(FLModule flModule) {
    switch(flModule) {
      case FLModule.estimate:
        return "estimate";
      case FLModule.jobProposal:
        return "proposal";
      default:
        return "";
    }
  }
}
