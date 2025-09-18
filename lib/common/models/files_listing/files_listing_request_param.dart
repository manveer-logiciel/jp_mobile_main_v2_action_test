import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/constants/pagination_constants.dart';
import 'package:dio/dio.dart' as formdata;

import '../../../core/constants/launchdarkly/flag_keys.dart';
import '../../services/launch_darkly/index.dart';
import '../home/filter_model.dart';

class FilesListingRequestParam {
  int? parentId;
  String? limit;
  late int page;
  String? keyword;
  String? parent;
  String? nextPageToken;
  int? perPage;
  String? query;
  String? templatesListType;
  bool? dirWithImageOnly;

  FilesListingRequestParam({
    required this.parentId,
    this.limit = '${PaginationConstants.pageLimit}',
    this.page = 1,
    this.keyword = '',
    this.parent,
    this.nextPageToken,
    this.perPage = PaginationConstants.pageLimit,
    this.query = '',
    this.dirWithImageOnly
  });

  FilesListingRequestParam.fromJson(Map<String, dynamic> json) {
    parentId = json["parent_id"];
    limit = json["limit"];
    page = json["page"];
    keyword = json["keyword"];    
    parent = json['parent'];
    nextPageToken = json['next_page_token'];
    perPage = json['per_page'];
    query = json['query'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data["parent_id"] = parentId;
    data["limit"] = limit;
    data["page"] = page;
    data["keyword"] = keyword;
    data['parent'] = parent;
    data['next_page_token'] = nextPageToken;
    data['per_page'] = perPage;
    data['query'] = query;
    if (dirWithImageOnly != null) {
      data['dir_with_only_img'] = dirWithImageOnly! ? 1 : 0;
    }
    return data;
  }

  Map<String, dynamic> templateListingtoJson({String? templateType}) {
    final Map<String, dynamic> data = {};
    data["limit"] = limit;
    data["page"] = page;
    data["parent_id"] = parentId;
    data["type"] = templatesListType ?? templateType ?? 'proposal';
    return data;
  }

  Map<String, dynamic> googlesheetTemplateListingtoJson(FLModule module) {
    final Map<String, dynamic> data = {};
    data["limit"] = limit;
    data["page"] = page;
    data["parent_id"] = parentId;
    data["type"] = module == FLModule.estimate ? 'estimate' : 'proposal';
    return data;
  }

  static getGoogleSheetParams(String action,Map<String,dynamic> param) async{
    switch(action) {
      case 'FLQuickActions.uploadExcel':
        return formdata.FormData.fromMap({
          "title": param['file_name'],
          "job_id": param['job_id'],
          'file':  await formdata.MultipartFile.fromFile(param['file_path'])
        });
      case 'FLQuickActions.newSpreadsheet':
        return formdata.FormData.fromMap({
          "title": param['file_name'],
          "job_id": param['job_id'],
        });
      case 'FLQuickActions.spreadSheetTemplate':
        return formdata.FormData.fromMap({
          "title": param['file_name'],
          "job_id": param['job_id'],
          "google_sheet_id": param['google_sheet_id']
        });
    }
  }

  static Map<String, dynamic> getFormProposalTemplateListingParams(String? selectedFilterByOptions){
    return {
      'includes[]': 'ancestors',
      'limit' : '20',
      'templates' : 'custom',
      'type' : 'proposal',
      'page' : '1',
      'trades': selectedFilterByOptions,
      "multi_page": 1,
      'with_directories' : 1,
      'without_content' : 1,
      'without_google_sheets':1,
      'without_insurance_estimate':1
    };
  }

  static Map<String, dynamic> getTemplateListingParams(String? selectedFilterByOptions){
    return {
      'includes[]': 'ancestors',
      'limit' : '20',
      'templates' : 'custom',
      'type' : 'proposal',
      'page' : '1',
      'trades': selectedFilterByOptions,
      "multi_page": 1,
      'with_directories' : 1,
      'without_content' : 1,
      'without_insurance_estimate' : 1,
    };
  }

  static Map<String, dynamic> getGoogleSheetTemplateListingParams(String? selectedFilterByOptions,FLModule? module){
    return {
      'includes[]': 'ancestors',
      'limit' : '20',
      "multi_page": 1,
      "only_google_sheets": 1,
      'page' : '1',
      'templates' : 'custom',
      'trades': selectedFilterByOptions,
      'type' : (module == FLModule.estimate) ? 'estimate' : 'proposal',
      'with_directories' : 1,
      'without_content' : 1,
    };
  }

  static Map<String, dynamic> getGoogleSheetTemplateListingSearchParams(String? qry,FLModule? module) {
    return {
      'q': qry,
      'includes[]': 'ancestors',
      'limit' : '20',
      "multi_page": 1,
      "only_google_sheets": 1,
      'page' : '1',
      'templates' : 'custom',
      'type' : module == FLModule.estimate ? 'estimate' : 'proposal',
      'with_directories' : 1,
      'without_content' : 1,
    };
  }

  static Map<String, dynamic> getMergeTemplateListingParams(String? proposalPageType){
    return {
      'includes[0]': 'pages',
      'includes[1]': 'ancestors',
      'insurance_estimate' : 1,
      'limit' : '20',
      'templates' : 'custom',
      'type' : 'proposal',
      'page' : '1',
      "multi_page": 1,
      'without_content' : 1,
      'without_google_sheets':1,
      if (proposalPageType != null) "page_type": proposalPageType
    };
  }


  static Map<String, dynamic> getFormProposalTemplateListingSearchParams(String? qry) {
    return {
      'q': qry,
      'division_ids[]' : '2',
      'includes[]': 'ancestors',
      'limit' : '20',
      'templates' : 'custom',
      'page' : '1',
      "multi_page": 1,
      'with_directories' : 1,
      'without_content' : 1,
      'without_google_sheets':1,
      'without_insurance_estimate':1,
    };
  }

  static Map<String, dynamic> getTemplateListingSearchParams(String? qry) {
    return {
      'includes[]': 'ancestors',
      'limit' : '20',
      'templates' : 'custom',
      'page' : '1',
      "multi_page": 1,
      'with_directories' : 1,
      'without_content' : 1,
      'q': qry,
      'type': 'estimate',
    };
  }

  static Map<String, dynamic> getMergeTemplateListingSearchParams(String? qry) {
    return {
      'q': qry,
      'includes[0]': 'pages',
      'includes[1]': 'ancestors',
      'insurance_estimate' : 1,
      'limit' : '20',
      'templates' : 'custom',
      'type' : 'proposal',
      'page' : '1',
      "multi_page": 1,
      'without_content' : 1,
      'without_google_sheets':1,
    };
  }

  static Map<String, dynamic> getCompanyFilesSearchParams(int? rootId) {
    return {
      'includes[0]': 'multi_size_images',
      'includes[1]': 'ancestors',
      'root_id': rootId,
    };
  }

  static Map<String, dynamic> getCompanyFilesParams(bool isInMoveFileMode) {
    return {
      if (isInMoveFileMode) 'type': 'dir',
      'includes[]': 'multi_size_images',
    };
  }

  static Map<String, dynamic> getCompanyCamImagesParams(String? projectId) {
    return {
      'project_id': projectId,
    };
  }
  

  static Map<String, dynamic> getJobEstimateParams(
      bool isInMoveFileMode, int jobId, {bool filesOnly = false}) {
    return {
      "includes[0]": "pages",
      "includes[1]": "worksheet",
      "includes[2]": "createdBy",
      "includes[3]": "linked_invoices",
      "includes[4]": "worksheet.suppliers",
      "includes[5]": "linked_measurement",
      "includes[6]": "worksheet.qbd_queue_status",
      "includes[7]": "my_favourite_entity",
      "includes[8]": "worksheet.srs_ship_to_address",
      "includes[10]": "worksheet.beacon_account",
      if(LDService.hasFeatureEnabled(LDFlagKeyConstants.abcMaterialIntegration))
        "includes[11]": "worksheet.supplier_account",
      "job_id": jobId,
      "multi_page": 1,
      "type": "estimate",
      "with_ev_reports": 1,
      "without_content": 1,
      if (isInMoveFileMode) 'is_dir': 1,
      if(filesOnly || CommonConstants.restrictFolderStructure) 'is_dir' : 0,
    };
  }

  /// [getJobContractParams] gives the Api payload while loading contracts
  static Map<String, dynamic> getJobContractParams(int jobId) {
    return {
      "job_id": jobId,
    };
  }

  static Map<String, dynamic> getJobPhotosParams(bool isInMoveFileMode) {
    return {
      if (isInMoveFileMode) 'type': 'dir',
      'includes[0]': 'createdBy',
      'includes[1]': 'multi_size_images',
    };
  }

  static Map<String, dynamic> getJobProposalParams(
      bool isInMoveFileMode, int jobId, {bool filesOnly = false}) {
    return {
      "includes[0]": "pages",
      "includes[1]": "createdBy",
      "includes[2]": "linked_invoices",
      "includes[3]": "worksheet.suppliers",
      "includes[4]": "linked_measurement",
      "includes[5]": "worksheet.qbd_queue_status",
      "includes[6]": "my_favourite_entity",
      "includes[7]": "digital_sign_queue_status",
      "includes[8]": "worksheet.custom_tax",
      "includes[9]": "worksheet.material_custom_tax",
      "includes[10]": "worksheet.labor_custom_tax",
      "includes[11]": "worksheet.srs_ship_to_address",
      "includes[12]": "worksheet.beacon_account",
      if(LDService.hasFeatureEnabled(LDFlagKeyConstants.abcMaterialIntegration))
        "includes[13]": "worksheet.supplier_account",
      "job_id": jobId,
      if (isInMoveFileMode) 'is_dir': 1,
      if(filesOnly || CommonConstants.restrictFolderStructure) 'is_dir' : 0,
      "without_google_sheets" : 0,
      "multi_page": 1,
    };
  }

  static Map<String, dynamic> getMeasurementsParams(
      bool isInMoveFileMode, int jobId) {
    return {
      "includes[0]": "createdBy",
      "includes[1]": "hover_job",
      "includes[2]": "hover_job.hover_user",
      "includes[3]": "hover_job.report_files",
      "includes[4]": "ev_order",
      "includes[5]": "sm_order",
      "includes[6]": "quickmeasure_order",
      "includes[7]": "ev_order.report_files",
      "includes[8]": "sm_order.report_files",
      "includes[9]": "quickmeasure_order.reports",
      "job_id": jobId,
      if (isInMoveFileMode) 'is_dir': 1,
      if(CommonConstants.restrictFolderStructure) 'is_dir' : 0,
      'type': 'measurements',
    };
  }
  static Map<String, dynamic> getFavouriteListingParams(HomeFilterModel? favouriteFilterKey, {
    Map<String, dynamic>? additionalParams
  }) {

    return {
      if (additionalParams == null) ...{
        'includes[0]': 'estimate',
        'type[]': 'xactimate_estimate',
      } else ... {
        ...additionalParams
      },
      'marked_by_me': 1,
      if(favouriteFilterKey?.trades != null) ...{
        for(int i = 0; i < favouriteFilterKey!.trades!.length; i++)
        'trade_ids[$i]': favouriteFilterKey.trades![i],
      }        
    };
  }

  static Map<String, dynamic> getMaterialListParams(
      bool isInMoveFileMode, int jobId) {
    return {
      "includes[0]": "createdBy",
      "includes[1]": "job",
      "includes[2]": "worksheet",
      "includes[3]": "worksheet.suppliers",
      "includes[4]": "worksheet.branch",
      "includes[5]": "worksheet.srs_ship_to_address",
      "includes[6]": "linked_measurement",
      "includes[7]": "my_favourite_entity",
      "includes[8]": "delivery_date",
      "includes[9]": "srs_order",
      "includes[10]": "beacon_order",
      "includes[11]": "completion_status",
      "includes[12]": "supplier_order",
      "includes[13]": "worksheet.beacon_account",
      if(LDService.hasFeatureEnabled(LDFlagKeyConstants.abcMaterialIntegration))
        "includes[14]": "worksheet.supplier_account",
      "job_id": jobId,
      if (isInMoveFileMode) 'is_dir': 1,
      if(CommonConstants.restrictFolderStructure) 'is_dir' : 0,
      'type': 'material_list',
    };
  }

  static Map<String, dynamic> getWorkOrderParams(
      bool isInMoveFileMode, int jobId) {
    return {
      "includes[0]": "createdBy",
      "includes[1]": "job",
      "includes[2]": "worksheet",
      "includes[3]": "worksheet.suppliers",
      "includes[4]": "worksheet.branch",
      "includes[5]": "worksheet.srs_ship_to_address",
      "includes[6]": "srs_order",
      "includes[7]": "linked_measurement",
      "includes[8]": "my_favourite_entity",
      "includes[9]": "schedules",
      "includes[10]": "completion_status",
      "includes[11]": "assigned_users",
      "includes[12]": "created_by",
      "job_id": jobId,
      if (isInMoveFileMode) 'is_dir': 1,
      if(CommonConstants.restrictFolderStructure) 'is_dir' : 0,
      'type': 'work_order',
    };
  }

  static Map<String, dynamic> getStageResourceParams(bool isInMoveFileMode) {
    return {
      if (isInMoveFileMode) 'type': 'dir',
      "recursive": "true",
    };
  }

  static Map<String, dynamic> getUserDocumentsSearchParam(int? rootId) {
    return {
      'includes[0]': 'multi_size_images',
      'includes[1]': 'ancestors',
      'root_id': rootId,
    };
  }

  static Map<String, dynamic> getUserDocumentsParams(bool isInMoveFileMode) {
    return {
      if (isInMoveFileMode) 'type': 'dir',
      'includes[]': 'multi_size_images',
    };
  }

  static Map<String, dynamic> getInstantPhotoGalleryParams() {
    return {
      'includes[0]': 'multi_size_images',
      'includes[1]': 'created_by_details'     
    };
  }

  static Map<String, dynamic> getPaymentReceiveParams() {
    return { 
    'includes[0]': 'transfer_to_payment',
    'includes[1]': 'transfer_from_payment',
    'includes[2]': 'transfer_to_payment.ref_job',
    'includes[3]': 'transfer_from_payment.ref_job',
    'limit': PaginationConstants.pageLimit,
    'page': 1     
    };
  }

  
  static Map<String, dynamic>  getFinancialInvoiceParams() {
    return {
      'includes[0]': 'proposal',
      'includes[1]': 'invoice',
      'status': 'all'
    };
  }

  static Map<String, dynamic> getTemplateGroupParams(String groupId) {
    return {
      "group_ids[]": [groupId],
      "insurance_estimate": 1,
      "limit": 0,
      "type": "proposal",
      "without_content": 1,
    };
  }
}
