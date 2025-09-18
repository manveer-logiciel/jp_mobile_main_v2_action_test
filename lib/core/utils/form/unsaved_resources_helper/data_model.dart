import '../../../../common/enums/unsaved_resource_type.dart';
import '../../../../common/models/files_listing/files_listing_model.dart';
import '../../../../common/models/job_financial/financial_listing.dart';

class UnsavedResourcesDataModel {
  static Object getListOfDataModel(UnsavedResourceType type, List<Map<String, dynamic>>? resourceList) {
    switch(type) {
      case UnsavedResourceType.changeOrder:
        return changeOrderDataList(resourceList, type);
      case UnsavedResourceType.invoice:
      case UnsavedResourceType.mergeTemplate:
      case UnsavedResourceType.proposalForm:
      case UnsavedResourceType.handWrittenTemplate:
      case UnsavedResourceType.estimateWorksheet:
      case UnsavedResourceType.proposalWorksheet:
      case UnsavedResourceType.materialWorksheet:
      case UnsavedResourceType.workOrderWorksheet:
        return unsavedResourcesList(resourceList, type);
    }
  }

  static List<FinancialListingModel> changeOrderDataList(List<Map<String, dynamic>>? resourceList, UnsavedResourceType type) {
    List<FinancialListingModel> financialList = [];
    resourceList?.forEach((resource) => financialList.add(FinancialListingModel.fromUnsavedResourcedJson(resource, type)));
    return financialList;
  }

  static List<FilesListingModel> unsavedResourcesList(List<Map<String, dynamic>>? resourceList, UnsavedResourceType type) {
    List<FilesListingModel> financialList = [];
    resourceList?.forEach((resource) => financialList.add(FilesListingModel.fromUnsavedResourceJson(resource)));
    return financialList;
  }
}