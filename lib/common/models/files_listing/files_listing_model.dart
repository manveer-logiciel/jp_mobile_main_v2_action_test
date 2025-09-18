import 'dart:convert';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/models/address/address.dart';
import 'package:jobprogress/common/models/attachment.dart';
import 'package:jobprogress/common/models/companycam/company_cam_feature_image.dart';
import 'package:jobprogress/common/models/files_listing/delivery_date.dart';
import 'package:jobprogress/common/models/files_listing/eagleview/ev_order.dart';
import 'package:jobprogress/common/models/files_listing/hover/job.dart';
import 'package:jobprogress/common/models/files_listing/quickmeasure_order.dart';
import 'package:jobprogress/common/models/files_listing/sm_order.dart';
import 'package:jobprogress/common/models/files_listing/srs/srs_order_detail.dart';
import 'package:jobprogress/common/models/files_listing/work_order_assigned_user.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/job/job_division.dart';
import 'package:jobprogress/common/models/job/job_invoices.dart';
import 'package:jobprogress/common/models/photo_viewer_model.dart';
import 'package:jobprogress/common/models/suppliers/beacon/order.dart';
import 'package:jobprogress/common/models/templates/form_proposal/template.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/core/utils/file_helper.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jp_mobile_flutter_ui/Thumb/icon_type.dart';
import 'package:jp_mobile_flutter_ui/Thumb/type.dart';
import '../../../core/utils/form/unsaved_resources_helper/unsaved_resources_helper.dart';
import '../../enums/resource_type.dart';
import '../../enums/unsaved_resource_type.dart';
import '../job_financial/financial_listing.dart';
import '../suppliers/abc_order_details.dart';
import '../worksheet/worksheet_model.dart';
import 'hover/hover_report.dart';
import 'linked_material.dart';
import 'linked_measurement.dart';
import 'linked_work_order.dart';
import 'my_favourite_entity.dart';

class FilesListingModel {
  int? index;
  String? id;
  int? unsavedResourceId;
  String? unsavedResourceType;
  String? type;
  String? entityId;
  String? title;
  int? markedBy;
  int? forAllTrades;
  int? forAllUsers;
  int? evReportId;
  String? smOrderId;
  int? parentId;
  String? name;
  String? invoiceNumber;
  int? isDir;
  String? path;
  String? relativePath;
  List<dynamic>? meta;
  String? createdAt;
  String? updatedAt;
  int? createdBy;
  dynamic origin;
  int? locked;
  int? noOfChild;
  int? noOfChildDir;
  bool? isSelected;
  String? url;
  String? thumbUrl;
  String? originalFilePath;
  int? multiSizeImage;
  List<String>? multiSizeImages;
  JPThumbIconType? jpThumbIconType;
  List<WorkOrderAssignedUserModel>? workOrderAssignedUser;
  bool? showThumbImage;
  JPThumbType? jpThumbType;
  List<Ancestor>? ancestors;
  int? size;
  int? jobId;
  bool? isFile;
  int? companyId;
  bool? isGoogleSheet;
  bool? isWorkSheet;
  bool? isShownOnCustomerWebPage;
  LinkedWorkOrder? linkedWorkOrder;
  LinkedWorkOrder? linkedWorkProposal;
  LinkedWorkOrder? linkedEstimate;
  List<LinkedMaterialModel>? linkedMaterialLists;
  List<JobInvoices>? linkedInvoicesLists;
  LinkedMeasurement? linkedMeasurement;
  MyFavouriteEntity? myFavouriteEntity;
  bool? isGoogleDriveLink;
  String? status;
  String? note;
  bool? isMeasurement;
  bool? isHover;
  bool? isMaterialList;
  bool? isWorkOrder;
  HoverJob? hoverJob;
  SmOrder? smOrder;
  QuickMeasureOrder? quickMeasureOrder;
  EvOrder? evOrder;
  bool? isHoverJobCompleted;
  List<ReportFile>? reportFiles;
  List<dynamic>? schedules;
  int? expirationId;
  String? expirationDescription;
  String? expirationDate;
  DeliveryDateModel? deliveryDateModel;
  bool? isUpgradeToHoverRoofOnlyVisible;
  bool? isUpgradeToHoverRoofCompleteVisible;
  Uint8List? base64Image;
  String? qbInvoiceId;
  int? proposalId;
  String? openBalance;
  String? proposalUrl;
  bool? insuranceEstimate;
  WorksheetModel? worksheet;
  String? clickthruId;
  String? worksheetId;
  int? forSupplierId;
  String? digitalSignStatus;
  String? creatorId;
  String? creatorType;
  String? creatorName;
  List<FeatureImageModal>? featureImage;
  AddressModel? address;
  String? addressString;
  int? photoCount;
  CreatedByDetails? createdByDetails;
  bool isSrs = false;
  bool isABC = false;
  String? unitNumber;
  bool? isEagleView;
  String? pageType;
  String? proposalSerialNumber;
  List<FormProposalTemplateModel>? proposalTemplatePages;
  List<AttachmentResourceModel>? attachments;
  FilesListingModel? favouriteFile;
  String? groupId;
  String? groupName;
  bool? isGroup;
  int? totalPages;
  bool? showSubPages;
  int? totalValues;
  String? googleSheetId;
  String? googleSheetLink;
  SrsOrderModel? srsOrderDetail;
  String? template;
  String? templateCover;
  bool? isTemplate;
  String? xactimateFilePath;
  String? mimeType;
  String? fileMimeType;
  String? classType;
  bool? isUnSupportedFile;
  int? quickBookSyncStatus;
  String? qbDesktopId;
  String? quickbookId;
  bool? isBeaconOrder;
  BeaconOrderDetails? beaconOrderDetails;
  int? beaconAccountId;
  bool? isAcceptingLeapPay;
  bool? isFeePassoverEnabled;
  String? defaultPaymentMethod;
  String? projectId;
  ABCOrderDetails? abcOrderDetail;  /// [division] hold the division data coming with in the file
  DivisionModel? division;
  JobModel? job;
  bool isRestricted = false;
 

  FilesListingModel({
      this.index,
      this.id,
      this.parentId,
      this.workOrderAssignedUser,
      this.name,
      this.isDir,
      this.path,
      this.relativePath,
      this.meta,
      this.evReportId,
      this.smOrderId,
      this.createdAt,
      this.updatedAt,
      this.type,
      this.createdBy,
      this.origin,
      this.locked,
      this.noOfChild,
      this.noOfChildDir,
      this.isSelected,
      this.url,
      this.thumbUrl,
      this.originalFilePath,
      this.multiSizeImage,
      this.multiSizeImages,
      this.jpThumbIconType,
      this.showThumbImage,
      this.jpThumbType,
      this.ancestors,
      this.size,
      this.jobId,
      this.isFile,
      this.companyId,
      this.isGoogleSheet,
      this.isWorkSheet,
      this.isShownOnCustomerWebPage,
      this.linkedWorkOrder,
      this.linkedWorkProposal,
      this.linkedEstimate,
      this.linkedMaterialLists,
      this.linkedMeasurement,
      this.myFavouriteEntity,
      this.isGoogleDriveLink,
      this.status,
      this.note,
      this.isMeasurement,
      this.isHover,
      this.isMaterialList,
      this.isWorkOrder,
      this.hoverJob,
      this.smOrder,
      this.quickMeasureOrder,
      this.evOrder,
      this.isHoverJobCompleted,
      this.reportFiles,
      this.schedules,
      this.expirationId,
      this.expirationDescription,
      this.expirationDate,
      this.deliveryDateModel,
      this.isUpgradeToHoverRoofOnlyVisible,
      this.isUpgradeToHoverRoofCompleteVisible,
      this.qbInvoiceId,
      this.openBalance,
      this.proposalId,
      this.insuranceEstimate = false,
      this.worksheet,
      this.clickthruId,
      this.worksheetId,
      this.forSupplierId,
      this.digitalSignStatus,
      this.creatorId,
      this.creatorType,
      this.creatorName,
      this.featureImage,
      this.address,
      this.photoCount,
      this.createdByDetails,
      this.unitNumber,
      this.favouriteFile,
      this.proposalTemplatePages,
      this.groupId,
      this.groupName,
      this.pageType,
      this.showSubPages,
      this.entityId,
      this.forAllTrades,
      this.forAllUsers,
      this.markedBy,
      this.isSrs = false,
      this.proposalSerialNumber,
      this.attachments,
      this.isGroup,
      this.fileMimeType,
      this.mimeType,
      this.classType,
      this.title,
      this.quickBookSyncStatus,
      this.qbDesktopId,
      this.quickbookId,
      this.projectId,
      this.beaconAccountId,
      this.division,
      this.abcOrderDetail,
      this.job,
      this.isRestricted = false

  });

  FilesListingModel.fromEstimatesJson(Map<String, dynamic> json , {bool isInsurance = false}) {
    id = json["id"]?.toString();
    if (json["parent_id"] != null) {
      parentId = int.tryParse(json["parent_id"].toString());
    }
    name = json["title"] ?? "";
    jobId = int.tryParse(json['job_id'].toString());
    isDir = int.tryParse(json["is_dir"] ?? '0');
    path = json["file_path"]?.toString();
    isFile = json['is_file'] == 1;
    relativePath = json["path"];
    meta = json["meta"] ?? [];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
    type = json["type"];
    setCreatedBy(json);
    origin = json["origin"];
    if (json["locked"] != null) {
      locked = json["locked"] is bool ? json["locked"] ? 1 : 0 : json["locked"];
      locked = (locked == 1 || (type == "worksheet" && worksheetId != null)) ? 1 : 0;
    }
    noOfChild = json["no_of_child"];
    noOfChildDir = json["no_of_child_dir"];
    url = json['url'] ?? path;
    thumbUrl = json['thumb'] ?? url;
    originalFilePath = json['file_path'];
    multiSizeImage = FileHelper.checkIfImage(json['file_path'] ?? '') ? 1 : 0;
    isSelected = false;
    multiSizeImages = json["multi_size_images"] == null
        ? multiSizeImage == 1
            ? [thumbUrl ?? '', originalFilePath ?? '']
            : null
        : List<String>.from(json["multi_size_images"]);
    showThumbImage = json['is_file'] != null && json['thumb'] != null;
    if (isDir != null) {
      jpThumbType = isDir == 1
          ? JPThumbType.folder
          : multiSizeImage == 0
              ? JPThumbType.icon
              : JPThumbType.image;
    }
    if (isDir != null &&
        multiSizeImage != null &&
        multiSizeImage == 0 &&
        originalFilePath != null) {
      jpThumbIconType =
          Helper.getIconTypeAccordingToExtension(originalFilePath!);
    }
    size = json["file_size"];
    isGoogleSheet = json['type'] == 'google_sheet';
    isWorkSheet = !(!isFile! || (isFile! && type == 'file'));
    isShownOnCustomerWebPage = (isGoogleSheet! ||
        (json['share_on_hop'] != null && json['share_on_hop'] == 1));
    if (json['linked_work_order'] != null) {
      linkedWorkOrder = LinkedWorkOrder.fromJson(json['linked_work_order']);
    }
    if (json['linked_proposal'] != null) {
      linkedWorkProposal = LinkedWorkOrder.fromJson(json['linked_proposal']);
    }
    if (json['linked_material_lists'] != null) {
      linkedMaterialLists = <LinkedMaterialModel>[];
      json['linked_material_lists']['data'].forEach((dynamic v) {
        linkedMaterialLists!.add(LinkedMaterialModel.fromJson(v));
      });
    }
    if (json['linked_measurement'] != null) {
      linkedMeasurement =
          LinkedMeasurement.fromJson(json['linked_measurement']);
    }
    if (json['my_favourite_entity'] != null) {
      myFavouriteEntity =
          MyFavouriteEntity.fromJson(json['my_favourite_entity']);
    }
    expirationId = json['expiration_id'];
    expirationDate = json['expiration_date'];
    expirationDescription = json['expiration_description'];
    clickthruId = json['clickthru_id'].toString();
    isTemplate = type == 'template';
    template = json['template'];
    templateCover = json['template_cover'];
    worksheetId = json['worksheet_id'].toString();
    worksheet = (json['worksheet'] != null && (json['worksheet'] is Map)) ? WorksheetModel.fromJson(json['worksheet'], isInsurance: isInsurance) : null;
    xactimateFilePath = json['xactimate_file_path'];
    if(json['type'] == 'google_sheet'){
      googleSheetId = json['google_sheet_id'];
      googleSheetLink = json['google_sheet_url'];
    }
    classType = getClassType(json);
  }

  FilesListingModel.fromContractsJson(Map<String, dynamic>? json) {
    json ??= {};
    id = json["id"]?.toString();
    if (json["parent_id"] != null) {
      parentId = int.tryParse(json["parent_id"].toString());
    }
    name = (json["title"] ?? "").toString();
    jobId = int.tryParse(json['job_id'].toString());
    isDir = int.tryParse((json["is_dir"] ?? '0').toString());
    path = json["file_path"]?.toString();
    isFile = Helper.isTrue(json['is_file']);
    relativePath = json["path"]?.toString();
    meta = json["meta"] is List ? json["meta"] : [];
    createdAt = json["created_at"]?.toString();
    updatedAt = json["updated_at"]?.toString();
    type = json["type"]?.toString();
    createdBy = int.tryParse(json["created_by"].toString());
    origin = json["origin"];
    url = (json['url'] ?? path)?.toString();
    thumbUrl = (json['thumb'] ?? url)?.toString();
    originalFilePath = json['file_path']?.toString();
    multiSizeImage = FileHelper.checkIfImage(path ?? "") ? 1 : 0;
    isSelected = false;
    multiSizeImages = json["multi_size_images"] == null
        ? multiSizeImage == 1
            ? [thumbUrl ?? '', originalFilePath ?? '']
            : null
        : json["multi_size_images"] is List ? List<String>.from(json["multi_size_images"]) : null;
    showThumbImage = json['is_file'] != null && json['thumb'] != null;
    if (isDir != null) {
      jpThumbType = isDir == 1
          ? JPThumbType.folder
          : multiSizeImage == 0
              ? JPThumbType.icon
              : JPThumbType.image;
    }
    if (isDir != null &&
        multiSizeImage != null &&
        multiSizeImage == 0 &&
        originalFilePath != null) {
      jpThumbIconType =
          Helper.getIconTypeAccordingToExtension(originalFilePath!);
    }
    size = json["file_size"];
    if (json['my_favourite_entity'] != null) {
      myFavouriteEntity =
          MyFavouriteEntity.fromJson(json['my_favourite_entity']);
    }
    expirationId = json['expiration_id'];
    expirationDate = json['expiration_date'];
    expirationDescription = json['expiration_description'];
    isShownOnCustomerWebPage = Helper.isTrue(json['share_on_hop']);
    classType = getClassType(json);
  }

  FilesListingModel.fromMaterialListsJson(Map<String, dynamic> json) {

    id = json["id"]?.toString();
    if (json["parent_id"] != null) {
      parentId = int.parse(json["parent_id"].toString());
    }
    name = json["title"];
    jobId = json['job_id'];
    if (json["is_dir"] != null) {
      isDir = json["is_dir"] is bool ? json["is_dir"] ? 1 : 0 : json["is_dir"];
    } else {
      isDir = 0;
    }
    path = json["file_path"];
    isFile = json['is_file'] == 1;
    relativePath = json["path"];
    meta = json["meta"] ?? [];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
    type = json["type"];
    setCreatedBy(json);
    origin = json["origin"];
    if (json["locked"] != null) {
      locked = json["locked"] is bool ? json["locked"] ? 1 : 0 : json["locked"];
      locked = (locked == 1 || (type == "worksheet" && worksheetId != null)) ? 1 : 0;
    }
    noOfChild = json["no_of_child"];
    noOfChildDir = json["no_of_child_dir"];
    url = json['url'] ?? path;
    thumbUrl = json['thumb'] ?? url;
    originalFilePath = json['file_path'];
    multiSizeImage = FileHelper.checkIfImage(json['file_path'] ?? '') ? 1 : 0;
    isSelected = false;
    multiSizeImages = json["multi_size_images"] == null
        ? multiSizeImage == 1
            ? [thumbUrl ?? '', originalFilePath ?? '']
            : null
        : List<String>.from(json["multi_size_images"]);
    showThumbImage = json['is_file'] != null && json['thumb'] != null;
    if (isDir != null) {
      jpThumbType = isDir == 1 ? JPThumbType.folder : multiSizeImage == 0 ? JPThumbType.icon : JPThumbType.image;
    }
    if (isDir != null && multiSizeImage != null && multiSizeImage == 0 && originalFilePath != null) {
      jpThumbIconType = Helper.getIconTypeAccordingToExtension(originalFilePath!);
    }
    size = json["file_size"];
    isMaterialList = json['type'] == 'material_list';
    if (json['linked_work_order'] != null) {
      linkedWorkOrder = LinkedWorkOrder.fromJson(json['linked_work_order']);
    }
    if (json['linked_estimate'] != null) {
      linkedEstimate = LinkedWorkOrder.fromJson(json['linked_estimate']);
    }
    if (json['linked_proposal'] != null) {
      linkedWorkProposal = LinkedWorkOrder.fromJson(json['linked_proposal']);
    }
    if (json['linked_material_lists'] != null) {
      linkedMaterialLists = <LinkedMaterialModel>[];
      json['linked_material_lists']['data'].forEach((dynamic v) {
        linkedMaterialLists!.add(LinkedMaterialModel.fromJson(v));
      });
    }
    if (json['linked_measurement'] != null) {
      linkedMeasurement = LinkedMeasurement.fromJson(json['linked_measurement']);
    }
    if (json['my_favourite_entity'] != null) {
      myFavouriteEntity = MyFavouriteEntity.fromJson(json['my_favourite_entity']);
    }
    isWorkSheet = (!isFile! && isDir == 0);
    expirationId = json['expiration_id'];
    expirationDate = json['expiration_date'];
    expirationDescription = json['expiration_description'];

    if(json['delivery_date'] != null){
      deliveryDateModel = DeliveryDateModel.fromJson(json['delivery_date']);
    }
    forSupplierId = int.tryParse(json['for_supplier_id']?.toString() ?? '');
    worksheetId = json['worksheet_id'].toString();
    worksheet = (json['worksheet'] != null && (json['worksheet'] is Map)) ? WorksheetModel.fromJson(json['worksheet']) : null;
    isSrs = json['srs_order'] != null;
    isABC = json['abc_order'] != null;
    if(isSrs){
      srsOrderDetail = SrsOrderModel.fromJson(json['srs_order']);
    }

    if(json['beacon_order'] != null){
      beaconOrderDetails = BeaconOrderDetails.fromJson(json['beacon_order']);
    }
    if(json['completion_status'] != null && json['completion_status']['status'] != null){
      status = json['completion_status']['status'].toString();
    }
    classType = getClassType(json);
    // Considering current material as beacon order only
    // when worksheet has beacon supplier available and material is for beacon supplier
    isBeaconOrder = Helper.isSupplierHaveBeaconItem(worksheet?.suppliers)
        && forSupplierId == Helper.getSupplierId(key: CommonConstants.beaconId);

    if(json['supplier_order'] != null) {
      if(Helper.isABCSupplierId(json['supplier_order']['supplier_id'])) {
        abcOrderDetail = ABCOrderDetails.fromJson(json['supplier_order']);
      }
    }
  }


  FilesListingModel.fromWorkOrderJson(Map<String, dynamic> json) {
    id = json["id"]?.toString();
    if (json["parent_id"] != null) {
      parentId = int.parse(json["parent_id"].toString());
    }
    name = json["title"]?.toString();
    jobId = int.tryParse(json['job_id'].toString());
    if (json["is_dir"] != null) {
      isDir = json["is_dir"] is bool ? json["is_dir"] ? 1 : 0 : json["is_dir"];
    } else {
      isDir = 0;
    }
    path = json["file_path"];
    if (json['assigned_users'] != null) {
      workOrderAssignedUser = <WorkOrderAssignedUserModel>[];
      json['assigned_users']['data'].forEach((dynamic v) {
        workOrderAssignedUser!.add(WorkOrderAssignedUserModel.fromJson(v));
      });
    }
    isFile = json['is_file'] == 1;
    relativePath = json["path"];
    meta = json["meta"] ?? [];
    if(json['completion_status'] != null){
      status = json['completion_status']['status'].toString();
    }
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
    type = json["type"];
    setCreatedBy(json);
    origin = json["origin"];
    if (json["locked"] != null) {
      locked = json["locked"] is bool ? json["locked"] ? 1 : 0 : json["locked"];
      locked = (locked == 1 || (type == "worksheet" && worksheetId != null)) ? 1 : 0;
    }
    noOfChild = json["no_of_child"];
    noOfChildDir = json["no_of_child_dir"];
    url = json['url'] ?? path;
    thumbUrl = json['thumb'] ?? url;
    originalFilePath = json['file_path'];
    multiSizeImage = FileHelper.checkIfImage(json['file_path'] ?? '') ? 1 : 0;
    isSelected = false;
    multiSizeImages = json["multi_size_images"] == null
        ? multiSizeImage == 1
          ? [thumbUrl ?? '', originalFilePath ?? ''] : null
        : List<String>.from(json["multi_size_images"]);
    showThumbImage = json['is_file'] != null && json['thumb'] != null;
    if (isDir != null) {
      jpThumbType = isDir == 1 ? JPThumbType.folder : multiSizeImage == 0 ? JPThumbType.icon : JPThumbType.image;
    }
    if (isDir != null && multiSizeImage != null && multiSizeImage == 0 && originalFilePath != null) {
      jpThumbIconType = Helper.getIconTypeAccordingToExtension(originalFilePath!);
    }
    size = json["file_size"];
    isWorkOrder = json['type'] == 'work_order';
    if (json['linked_work_order'] != null) {
      linkedWorkOrder = LinkedWorkOrder.fromJson(json['linked_work_order']);
    }
    if (json['linked_estimate'] != null) {
      linkedEstimate = LinkedWorkOrder.fromJson(json['linked_estimate']);
    }
    if (json['linked_proposal'] != null) {
      linkedWorkProposal = LinkedWorkOrder.fromJson(json['linked_proposal']);
    }
    if (json['linked_material_lists'] != null) {
      linkedMaterialLists = <LinkedMaterialModel>[];
      json['linked_material_lists']['data'].forEach((dynamic v) {
        linkedMaterialLists!.add(LinkedMaterialModel.fromJson(v));
      });
    }
    if (json['linked_measurement'] != null) {
      linkedMeasurement = LinkedMeasurement.fromJson(json['linked_measurement']);
    }
    if (json['my_favourite_entity'] != null) {
      myFavouriteEntity = MyFavouriteEntity.fromJson(json['my_favourite_entity']);
    }
    if (json['schedules'] != null && json['schedules']['data'] != null) {
      schedules = json['schedules']['data'];
    }
    isWorkSheet = (!isFile! && isDir == 0);
    expirationId = json['expiration_id'];
    expirationDate = json['expiration_date'];
    expirationDescription = json['expiration_description'];
    worksheetId = json['worksheet_id'].toString();
    worksheet = (json['worksheet'] != null && (json['worksheet'] is Map)) ? WorksheetModel.fromJson(json['worksheet']) : null;
    classType = getClassType(json);
  }
  
  FilesListingModel.fromMeasurementsJson(Map<String, dynamic> json) {
    id = json["id"].toString();

    if (json["parent_id"] != null) {
      parentId = int.parse(json["parent_id"].toString());
    }
    name = json["title"];
    jobId = json['job_id'];
    if (json["is_dir"] != null) {
      isDir = json["is_dir"] is bool ? json["is_dir"] ? 1 : 0 : json["is_dir"];
    } else {
      isDir = 0;
    }
    smOrderId = json['sm_order_id'];
    evReportId = json['ev_report_id'];
    path = json["file_path"];
    isFile = json['is_file'] == 1;
    relativePath = json["path"];
    meta = json["meta"] ?? [];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
    type = json["type"];
    createdBy = json["created_by"];
    origin = json["origin"];
    if (json["locked"] != null) {
      locked = json["locked"] is bool ? json["locked"] ? 1 : 0 : json["locked"];
      locked = (locked == 1 || (type == "worksheet" && worksheetId != null)) ? 1 : 0;
    }
    noOfChild = json["no_of_child"];
    noOfChildDir = json["no_of_child_dir"];
    url = json['url'] ?? path;
    thumbUrl = json['thumb'] ?? url;
    originalFilePath = json['file_path'];
    multiSizeImage = FileHelper.checkIfImage(json['file_path'] ?? '') ? 1 : 0;
    isSelected = false;
    multiSizeImages = json["multi_size_images"] == null
        ? multiSizeImage == 1
          ? [thumbUrl ?? '', originalFilePath ?? ''] : null
        : List<String>.from(json["multi_size_images"]);
    showThumbImage = json['is_file'] != null && json['thumb'] != null;
    if (isDir != null) {
      jpThumbType = isDir == 1 ? JPThumbType.folder : multiSizeImage == 0 ? JPThumbType.icon : JPThumbType.image;
    }
    if (isDir != null && multiSizeImage != null && multiSizeImage == 0 && originalFilePath != null) {
      jpThumbIconType = Helper.getIconTypeAccordingToExtension(originalFilePath!); 
    }
    size = json["file_size"];
    isHover = json['type'] == 'hover';
    isMeasurement = json['type'] == 'measurement';
    isEagleView = json['type'] == 'eagle_view';
    jpThumbIconType ??= Helper.getIconTypeAccordingToExtension(originalFilePath ?? "", extensionName: json['type']);
    if (json['hover_job'] != null) {
      hoverJob = HoverJob.fromJson(json['hover_job']);
      isHoverJobCompleted = hoverJob!.deliverableId == 4 && hoverJob!.state.toString().toLowerCase() == "complete";
      isUpgradeToHoverRoofOnlyVisible = !(hoverJob!.deliverableId == 2 || hoverJob!.deliverableId == 3);
      isUpgradeToHoverRoofCompleteVisible = !(hoverJob!.deliverableId == 3);
    } else {
      isHoverJobCompleted = false;
    }

    if (json['sm_order'] != null) {
      smOrder = SmOrder.fromJson(json['sm_order']);
    }
    if (json['ev_order'] != null) {
      evOrder = EvOrder.fromJson(json['ev_order']);
    }
    if (json['quickmeasure_order'] != null) {
      quickMeasureOrder = QuickMeasureOrder.fromJson(json['quickmeasure_order']);
    }
    if (json['digital_sign_queue_status'] != null) {
      digitalSignStatus = (json['digital_sign_queue_status'] != null && (json['digital_sign_queue_status'] is Map))
          ? json["digital_sign_queue_status"]["status"] : json['digital_sign_queue_status'];
    }

    reportFiles = serviceToReportFile();

    expirationId = json['expiration_id'];
    expirationDate = json['expiration_date'];
    expirationDescription = json['expiration_description'];
    worksheet = (json['worksheet'] != null && (json['worksheet'] is Map)) ? WorksheetModel.fromJson(json['worksheet']) : null;
    totalValues = json['total_values'];
    classType = getClassType(json);
  }

  FilesListingModel.fromFavouriteListingJson(Map<String, dynamic> json) {
    id = json["id"].toString();
    name = json["name"];
    if (json['estimate'] is Map) {
      favouriteFile = FilesListingModel.fromEstimatesJson(json['estimate']);
      thumbUrl = json['estimate']['thumb_path'];
    } else if (json['material_list'] is Map) {
      favouriteFile = FilesListingModel.fromMaterialListsJson(json['material_list']);
      thumbUrl = json['material_list']['thumb_path'];
    } else if (json['proposal'] is Map) {
      favouriteFile = FilesListingModel.fromJobProposalJson(json['proposal']);
      thumbUrl = json['proposal']['thumb_path'];
    } else if (json['work_order'] is Map) {
      favouriteFile = FilesListingModel.fromWorkOrderJson(json['work_order']);
      thumbUrl = json['work_order']['thumb_path'];
    }
    path = favouriteFile?.path ?? "";
    meta = json["meta"] ?? [];
    type = favouriteFile?.type ?? "";
    originalFilePath = json['file_path'] ?? path;

    multiSizeImage = FileHelper.checkIfImage(originalFilePath ?? '') ? 1 : 0;
    isSelected = false;
    showThumbImage = thumbUrl != null;
    jpThumbIconType ??= Helper.getIconTypeAccordingToExtension(originalFilePath ?? "", extensionName: favouriteFile?.type);
    entityId = json['entity_id'].toString();
    markedBy = json['marked_by'];
    forAllTrades = json['for_all_trades'];
    forAllUsers = json['for_all_users'];
    classType = getClassType(json);
    // parsing division only if it is available
    if (json['division'] is Map) {
      division = DivisionModel.fromJson(json['division']);
    }
    if(json['job'] is Map) {
      job = JobModel.fromJson(json['job']);
    }
  }

  List<ReportFile>? serviceToReportFile(){
    if(hoverJob != null) return hoverJob!.reportFiles;
    if(smOrder != null) return smOrder!.reportFiles;
    if(quickMeasureOrder != null) return quickMeasureOrder!.reportFiles;
    if(evOrder != null) return evOrder!.reportFiles;
    return null;
  }

  FilesListingModel.fromJobProposalJson(Map<String, dynamic> json) {
    id = json["id"]?.toString();
    if (json["parent_id"] != null) {
      parentId = int.tryParse(json["parent_id"].toString());
    }
    name = json["title"]?.toString();
    jobId = int.tryParse(json['job_id'].toString());
    isDir = int.tryParse(json["is_dir"] ?? '0');
    path = json["file_path"];
    isFile = json['is_file'] == 1;
    relativePath = json["path"];
    meta = json["meta"] ?? [];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
    type = json["type"];
    setCreatedBy(json);
    origin = json["origin"];
    if (json["locked"] != null) {
      locked = json["locked"] is bool ? json["locked"] ? 1 : 0 : json["locked"];
      locked = (locked == 1 || (type == "worksheet" && worksheetId != null)) ? 1 : 0;
    }
    noOfChild = json["no_of_child"];
    noOfChildDir = json["no_of_child_dir"];
    url = json['url'] ?? path  ;
    thumbUrl = json['thumb'] ?? url;
    originalFilePath = json['file_path'];
    multiSizeImage = FileHelper.checkIfImage(json['file_path'] ?? '') ? 1 : 0;
    isSelected = false;
    multiSizeImages = json["multi_size_images"] == null
        ? multiSizeImage == 1
        ? [thumbUrl ?? '', originalFilePath ?? '']
        : null
        : List<String>.from(json["multi_size_images"]);
    showThumbImage = json['is_file'] != null && json['thumb'] != null;
    if (isDir != null) {
      jpThumbType = isDir == 1 ? JPThumbType.folder : multiSizeImage == 0 ? JPThumbType.icon : JPThumbType.image;
    }
    if (isDir != null && multiSizeImage != null && multiSizeImage == 0 && originalFilePath != null) {
      jpThumbIconType = Helper.getIconTypeAccordingToExtension(originalFilePath!);
    }
    size = json["file_size"];
    isGoogleSheet = json['type'] == 'google_sheet';
    isWorkSheet = !(!isFile! || (isFile! && type == 'file'));
    isShownOnCustomerWebPage = (isGoogleSheet! ||
        (json['share_on_hop'] != null && json['share_on_hop'] == 1));
    if (json['linked_work_order'] != null) {
      linkedWorkOrder = LinkedWorkOrder.fromJson(json['linked_work_order']);
    }
    if (json['linked_estimate'] != null) {
      linkedEstimate = LinkedWorkOrder.fromJson(json['linked_estimate']);
    }
    if (json['linked_material_lists'] != null) {
      linkedMaterialLists = <LinkedMaterialModel>[];
      json['linked_material_lists']['data'].forEach((dynamic v) {
        linkedMaterialLists!.add(LinkedMaterialModel.fromJson(v));
      });
    }
    if (json['linked_measurement'] != null) {
      linkedMeasurement = LinkedMeasurement.fromJson(json['linked_measurement']);
    }
    if (json['my_favourite_entity'] != null) {
      myFavouriteEntity = MyFavouriteEntity.fromJson(json['my_favourite_entity']);
    }
    status = json['status'].toString();
    note = json['note'];
    expirationId = json['expiration_id'];
    expirationDate = json['expiration_date'];
    expirationDescription = json['expiration_description'];
    insuranceEstimate = (json['insurance_estimate']?? 0) == 1;
    worksheetId = json['worksheet_id']?.toString();
    proposalTemplatePages = <FormProposalTemplateModel>[];
    pageType = json['page_type'];
    proposalSerialNumber = json['serial_number'];
    json['pages']?['data']?.forEach((dynamic template) {
      proposalTemplatePages?.add(FormProposalTemplateModel.fromJson(template, isProposalPage: true));
    });
    attachments = <AttachmentResourceModel>[];
    json['attachments']?['data']?.forEach((dynamic attachment) {
      attachments?.add(AttachmentResourceModel.fromJson(attachment));
    });
    if(json['type'] == 'google_sheet'){
      googleSheetId = json['google_sheet_id'];
      googleSheetLink = json['google_sheet_url'];
    }  
    worksheet = (json['worksheet'] is Map) ? WorksheetModel.fromJson(json['worksheet']) : null;
    if (json['linked_invoices'] != null) {
      linkedInvoicesLists = <JobInvoices>[];
      json['linked_invoices']['data'].forEach((dynamic v) {
        linkedInvoicesLists!.add(JobInvoices.fromJson(v));
      });
    }
    if (json['digital_sign_queue_status'] != null) {
      digitalSignStatus = (json['digital_sign_queue_status'] != null && (json['digital_sign_queue_status'] is Map))
          ? json["digital_sign_queue_status"]["status"] : json['digital_sign_queue_status'];
    }
    classType = getClassType(json);
  }

  FilesListingModel.fromJobPhotosJson(Map<String, dynamic> json) {
    id = json["id"].toString();
    parentId = json["parent_id"];
    name = json["name"];
    if(json["is_dir"] != null) {
      isDir = json["is_dir"] is bool ? json["is_dir"] ? 1 : 0 : json["is_dir"];
    }
    path = json["path"];
    relativePath = json["relative_path"];
    meta = json["meta"] ?? [];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
    type = json["type"];
    createdBy = json["created_by"];
    origin = json["origin"];
    if (json["locked"] != null) {
      locked = json["locked"] is bool ? json["locked"] ? 1 : 0 : json["locked"];
      locked = (locked == 1 || (type == "worksheet" && worksheetId != null)) ? 1 : 0;
    }
    noOfChild = json["no_of_child"];
    noOfChildDir = json["no_of_child_dir"];
    url = json['url'];
    thumbUrl = json['thumb_url'] ?? url;
    originalFilePath = json['original_file_path'];
    if (json['multi_size_image'] != null) {
      final isImage = FileHelper.checkIfImage(path ?? "");
      multiSizeImage = isImage ? 1 : json['multi_size_image'] is bool ? json['multi_size_image'] ? 1 : 0 : json['multi_size_image'];
    }
    isSelected = false;
    multiSizeImages = Helper.isValueNullOrEmpty(json["multi_size_images"]) ? null
        : List<String>.from(json["multi_size_images"]);
    showThumbImage = isDir != null && isDir == 0 && multiSizeImage != null && multiSizeImage == 1;
    if (isDir != null) {
      jpThumbType = isDir == 1 ? JPThumbType.folder : multiSizeImage == 0 ? JPThumbType.icon : JPThumbType.image;
    }
    if (isDir != null && multiSizeImage != null && multiSizeImage == 0 && originalFilePath != null) {
      jpThumbIconType = Helper.getIconTypeAccordingToExtension(originalFilePath!);
    }

    if (json['ancestors'] != null && json['ancestors']['data'] != null) {
      ancestors = [];
      json['ancestors']['data'].forEach((dynamic v) {
        ancestors!.add(Ancestor.fromJson(v));
      });
    }
    expirationId = json['expiration_id'];
    expirationDate = json['expiration_date'];
    expirationDescription = json['expiration_description'];
    size = json["size"];
    isGoogleDriveLink = json['type'] == 'google_drive_link';
    isShownOnCustomerWebPage = (isGoogleDriveLink! || (json['share_on_hop'] != null && json['share_on_hop'] == 1));
    worksheet = (json['worksheet'] != null && (json['worksheet'] is Map)) ? WorksheetModel.fromJson(json['worksheet']) : null;
    classType = getClassType(json);
    isRestricted = Helper.isTrue(json["is_restricted"]);
  }

  FilesListingModel.fromStageResourceJson(Map<String, dynamic> json) {
    id = json["id"]?.toString();
    parentId = json["parent_id"];
    name = json["name"];
    isDir = json["is_dir"];
    path = json["path"];
    relativePath = json["relative_path"];
    meta = json["meta"] ?? [];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
    type = json["type"];
    createdBy = json["created_by"];
    origin = json["origin"];
    if (json["locked"] != null) {
      locked = json["locked"] is bool ? json["locked"] ? 1 : 0 : json["locked"];
      locked = (locked == 1 || (type == "worksheet" && worksheetId != null)) ? 1 : 0;
    }
    noOfChild = json["no_of_child"];
    noOfChildDir = json["no_of_child_dir"];
    url = json['url'];
    thumbUrl = json['thumb_url'] ?? url;
    originalFilePath = json['original_file_path'];
    if (json['multi_size_image'] != null) {
      final isImage = FileHelper.checkIfImage(path ?? "");
      multiSizeImage = isImage ? 1 : json['multi_size_image'] is bool ? json['multi_size_image'] ? 1 : 0 : json['multi_size_image'];
    }
    isSelected = false;
    multiSizeImages = json["multi_size_images"] == null
        ? null
        : List<String>.from(json["multi_size_images"]);
    showThumbImage = isDir != null && isDir == 0 && multiSizeImage != null && multiSizeImage == 1;
    if (isDir != null) {
      jpThumbType = isDir == 1 ? JPThumbType.folder : multiSizeImage == 0 ? JPThumbType.icon : JPThumbType.image;
    }
    if (isDir != null && multiSizeImage != null && multiSizeImage == 0 && originalFilePath != null) {
      jpThumbIconType = Helper.getIconTypeAccordingToExtension(originalFilePath!);
    }

    if (json['ancestors'] != null && json['ancestors']['data'] != null) {
      ancestors = [];
      json['ancestors']['data'].forEach((dynamic v) {
        ancestors!.add(Ancestor.fromJson(v));
      });
    }
    size = json["size"];
    expirationId = json['expiration_id'];
    expirationDate = json['expiration_date'];
    expirationDescription = json['expiration_description'];
    classType = getClassType(json);
  }

  FilesListingModel.fromInstantPhotoJson(Map<String, dynamic> json) {
    id = json["id"]?.toString();
    parentId = json["parent_id"];
    name = json["name"];
    isDir = json["is_dir"];
    path = json["path"];
    relativePath = json["relative_path"];
    meta = json["meta"] ?? [];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
    type = json["type"];
    createdBy = json["created_by"];
    origin = json["origin"];
    url = json['url'];
    thumbUrl = json['thumb_url'] ?? url;
    originalFilePath = json['original_file_path'];
    if (json['multi_size_image'] != null) {
      final isImage = FileHelper.checkIfImage(path ?? "");
      multiSizeImage = isImage ? 1 : json['multi_size_image'] is bool ? json['multi_size_image'] ? 1 : 0 : json['multi_size_image'];
    }
    isSelected = false;
    multiSizeImages = json["multi_size_images"] == null
        ? null
        : List<String>.from(json["multi_size_images"]);
    showThumbImage = isDir != null && isDir == 0 && multiSizeImage != null && multiSizeImage == 1;
    if (isDir != null) {
      jpThumbType = isDir == 1 ? JPThumbType.folder : multiSizeImage == 0 ? JPThumbType.icon : JPThumbType.image;
    }
    if (isDir != null && multiSizeImage != null && multiSizeImage == 0 && originalFilePath != null) {
      jpThumbIconType = Helper.getIconTypeAccordingToExtension(originalFilePath!);
    }
    size = json["size"];
    createdByDetails = (json['created_by_details'] != null && (json['created_by_details'] is Map)) ? CreatedByDetails.fromJson(json['created_by_details']) : null;
    classType = getClassType(json);
  }


  FilesListingModel.fromCompanyFilesJson(Map<String, dynamic> json) {
    id = json["id"]?.toString();
    parentId = json["parent_id"];
    name = json["name"];
    if(json["is_dir"] != null) {
      isDir = json["is_dir"] is bool ? json["is_dir"] ? 1 : 0 : json["is_dir"];
    }
    path = json["path"];
    relativePath = json["relative_path"];
    meta = json["meta"] ?? [];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
    type = json["type"];
    createdBy = json["created_by"];
    origin = json["origin"];
    if (json["locked"] != null) {
      locked = json["locked"] is bool ? json["locked"] ? 1 : 0 : json["locked"];
      locked = (locked == 1 || (type == "worksheet" && worksheetId != null)) ? 1 : 0;
    }
    noOfChild = json["no_of_child"];
    noOfChildDir = json["no_of_child_dir"];
    url = json['url'];
    thumbUrl = json['thumb_url'] ?? url;
    originalFilePath = json['original_file_path'];
    if (json['multi_size_image'] != null) {
      final isImage = FileHelper.checkIfImage(path ?? "");
      multiSizeImage = isImage ? 1 : json['multi_size_image'] is bool
          ? json['multi_size_image'] ? 1 : 0
          : json['multi_size_image'];
    }
    isSelected = false;
    multiSizeImages = json["multi_size_images"] == null
        ? null
        : List<String>.from(json["multi_size_images"]);
    showThumbImage = isDir != null && isDir == 0 && multiSizeImage != null && multiSizeImage == 1;
    if (isDir != null) {
      jpThumbType = isDir == 1 ? JPThumbType.folder : multiSizeImage == 0 ? JPThumbType.icon : JPThumbType.image;
    }

    if (isDir != null && multiSizeImage != null && multiSizeImage == 0 && originalFilePath != null) {
      jpThumbIconType = Helper.getIconTypeAccordingToExtension(originalFilePath!);
    }

    if (json['ancestors'] != null && json['ancestors']['data'] != null) {
      ancestors = [];
      json['ancestors']['data'].forEach((dynamic v) {
        ancestors!.add(Ancestor.fromJson(v));
      });
    }
    size = json["size"];
    expirationId = json['expiration_id'];
    expirationDate = json['expiration_date'];
    expirationDescription = json['expiration_description'];
    classType = getClassType(json);
  }

  FilesListingModel.fromTemplateListingJson(Map<String, dynamic> json) {
    id = json["id"]?.toString();
    parentId = json["parent_id"];
    name = json["title"];
    if(json["is_dir"] != null) {
      isDir = json["is_dir"] is bool ? json["is_dir"] ? 1 : 0 : json["is_dir"];
    }
    isFile = isDir == 0;
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
    createdBy = json["created_by"];
    type = json["type"];
    groupId = json['group_id'];
    groupName = json['group_name'];
    noOfChild = json["no_of_child"];
    noOfChildDir = json["no_of_child_dir"];
    url = json['image'];
    showThumbImage = json['google_sheet_id'] != null && json['thumb'] != null;
    thumbUrl = json['thumb'] ?? url;
    originalFilePath = json['original_file_path'];

    if (json['multi_size_image'] != null) {
      final isImage = FileHelper.checkIfImage(path ?? "");
      multiSizeImage = isImage ? 1 : json['multi_size_image'] is bool
          ? json['multi_size_image'] ? 1 : 0
          : json['multi_size_image'];
    }

    isSelected = false;

    isGroup = json['group_id'] != null;

    if (isFile ?? false) {
      jpThumbIconType = isGroup! ? JPThumbIconType.templateGroup : JPThumbIconType.template;
      jpThumbType = JPThumbType.icon;
    } else {
      jpThumbType = JPThumbType.folder;
    }

    if (json['ancestors'] is Map && json['ancestors']?['data'] != null) {
      ancestors = [];
      json['ancestors']['data'].forEach((dynamic v) {
        ancestors!.add(Ancestor.fromJson(v));
      });
    }
    size = json["size"];
    expirationId = json['expiration_id'];
    expirationDate = json['expiration_date'];
    expirationDescription = json['expiration_description'];
    proposalTemplatePages = <FormProposalTemplateModel>[];
    if (json['pages'] is List) {
      json['pages']?.forEach((dynamic template) {
        final page = FormProposalTemplateModel.fromJson(template);
        page.title = name;
        page.pageType = pageType;
        proposalTemplatePages?.add(page);
      });
    } else if (!(isGroup ?? false)){
      json['pages']?['data']?.forEach((dynamic template) {
        final page = FormProposalTemplateModel.fromJson(template);
        proposalTemplatePages?.add(page);
        page.title = name;
        page.pageType = pageType;
      });
    }
    pageType = json['page_type'];
    totalPages = json['count'] ?? 0;
    showSubPages = false;
    googleSheetId = json['google_sheet_id'];
    googleSheetLink = json['google_sheet_url'];
    classType = getClassType(json);
  }

  FilesListingModel.fromUserDocumentsJson(Map<String, dynamic> json) {
    id = json["id"]?.toString();
    parentId = json["parent_id"];
    name = json["name"];
    isDir = json["is_dir"];
    path = json["path"];
    relativePath = json["relative_path"];
    meta = json["meta"] ?? [];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
    type = json["type"];
    createdBy = json["created_by"];
    origin = json["origin"];
    if (json["locked"] != null) {
      locked = json["locked"] is bool ? json["locked"] ? 1 : 0 : json["locked"];
      locked = (locked == 1 || (type == "worksheet" && worksheetId != null)) ? 1 : 0;
    }
    noOfChild = json["no_of_child"];
    noOfChildDir = json["no_of_child_dir"];
    url = json['url'];
    thumbUrl = json['thumb_url'] ?? url;
    originalFilePath = json['original_file_path'];
    if (json['multi_size_image'] != null) {
      final isImage = FileHelper.checkIfImage(path ?? "");
      multiSizeImage = isImage ? 1 : json['multi_size_image'] is bool ? json['multi_size_image'] ? 1 : 0 : json['multi_size_image'];
    }
    isSelected = false;
    multiSizeImages = json["multi_size_images"] == null
        ? null
        : List<String>.from(json["multi_size_images"]);
    showThumbImage = isDir != null && isDir == 0 && multiSizeImage != null && multiSizeImage == 1;
    if (isDir != null) {
      jpThumbType = isDir == 1 ? JPThumbType.folder : multiSizeImage == 0 ? JPThumbType.icon : JPThumbType.image;
    }
    if (isDir != null && multiSizeImage != null && multiSizeImage == 0 && originalFilePath != null) {
      jpThumbIconType = Helper.getIconTypeAccordingToExtension(originalFilePath!);
    }

    if (json['ancestors'] != null && json['ancestors']['data'] != null) {
      ancestors = [];
      json['ancestors']['data'].forEach((dynamic v) {
        ancestors!.add(Ancestor.fromJson(v));
      });
    }
    size = json["size"];
    expirationId = json['expiration_id'];
    expirationDate = json['expiration_date'];
    expirationDescription = json['expiration_description'];
    classType = getClassType(json);
  }

  FilesListingModel.fromCustomerFilesJson(Map<String, dynamic> json) {
    id = json["id"]?.toString();
    parentId = json["parent_id"];
    name = json["name"];
    isDir = json["is_dir"];
    path = json["path"];
    relativePath = json["relative_path"];
    meta = json["meta"] ?? [];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
    type = json["type"];
    createdBy = json["created_by"];
    origin = json["origin"];
    if (json["locked"] != null) {
      locked = json["locked"] is bool ? json["locked"] ? 1 : 0 : json["locked"];
      locked = (locked == 1 || (type == "worksheet" && worksheetId != null)) ? 1 : 0;
    }
    noOfChild = json["no_of_child"];
    noOfChildDir = json["no_of_child_dir"];
    url = json['url'];
    thumbUrl = json['thumb_url'] ?? url;
    originalFilePath = json['original_file_path'];
    if (json['multi_size_image'] != null) {
      final isImage = FileHelper.checkIfImage(path ?? "");
      multiSizeImage = isImage ? 1 : json['multi_size_image'] is bool ? json['multi_size_image'] ? 1 : 0 : json['multi_size_image'];
    }
    isSelected = false;
    multiSizeImages = json["multi_size_images"] == null
        ? null
        : List<String>.from(json["multi_size_images"]);
    showThumbImage = isDir != null && isDir == 0 && multiSizeImage != null && multiSizeImage == 1;
    if (isDir != null) {
      jpThumbType = isDir == 1 ? JPThumbType.folder : multiSizeImage == 0 ? JPThumbType.icon : JPThumbType.image;
    }
    if (isDir != null && multiSizeImage != null && multiSizeImage == 0 && originalFilePath != null) {
      jpThumbIconType = Helper.getIconTypeAccordingToExtension(originalFilePath!);
    }

    if (json['ancestors'] != null && json['ancestors']['data'] != null) {
      ancestors = [];
      json['ancestors']['data'].forEach((dynamic v) {
        ancestors!.add(Ancestor.fromJson(v));
      });
    }
    size = json["size"];
    isShownOnCustomerWebPage = json['share_on_hop'] == 1;
    expirationId = json['expiration_id'];
    expirationDate = json['expiration_date'];
    expirationDescription = json['expiration_description'];
    classType = getClassType(json);
  }

  FilesListingModel.fromDropboxJson(Map<String, dynamic> json) {
    id = json["id"]?.toString();
    name = json["name"];
    isDir = json["tag"] == 'folder' ? 1 : 0;
    isSelected = false;

    if(json['thumb'] != null) {
      base64Image = base64.decode(json["thumb"]);
    }
    noOfChild = -1;

    if (isDir != null) {
      jpThumbType = isDir == 1 ? JPThumbType.folder : (FileHelper.checkIfImage(name!) && base64Image != null) ? JPThumbType.image : JPThumbType.icon;
    }

    if (isDir == 0 && name != null) {
      jpThumbIconType = Helper.getIconTypeAccordingToExtension(name!);
    }
    size = json["size"];
  }

  FilesListingModel.fromPaymentReceive(Map<String, dynamic> json) {
    id = json["id"].toString();
    name = '${JobFinancialHelper.getCurrencyFormattedValue(value: json['payment'])} (${json['method']})';
    isSelected = false;
  }

  FilesListingModel.fromFinancialInvoiceJson(Map<String, dynamic> json) {
    id = json["id"]?.toString();
    invoiceNumber = json['invoice_number'];
    unitNumber = json['unit_number'];
    title = json['title'];
    type = json['type'];
    status = json['status'];
    name = type == 'change_order' ? 'Order #: $invoiceNumber' : 'Invoice #: $invoiceNumber';
    url = json['file_path'];
    path = json["file_path"];
    originalFilePath = json['file_path'];
    proposalId = json['proposal_id'];
    openBalance = json['open_balance'];
    if( json['proposal_share_url'] != null){
      proposalUrl = json['proposal_share_url'];
    }
    if(json['proposal'] != null){
      proposalUrl = json['proposal']['file_path'];
    }
    isSelected = false;
    noOfChild = 0;
    isDir = 0;

    if (isDir != null) {
      jpThumbType = isDir == 1 ? JPThumbType.folder : (FileHelper.checkIfImage(name!)) ? JPThumbType.image : JPThumbType.icon;
    }

    if (isDir == 0 && originalFilePath != null) {
      jpThumbIconType = Helper.getIconTypeAccordingToExtension(originalFilePath!);
    }
    size = int.parse(json["file_size"]);
    unsavedResourceId = json['unsaved_resource_id'];
    jobId = json['job_id'];
    classType = getClassType(json);
    qbDesktopId = json['qb_desktop_id'];
    quickBookSyncStatus = json['quickbook_sync_status'];
    quickbookId = json['quickbook_id'];
    origin = json['origin'].toString();
    isAcceptingLeapPay = json['leap_pay_enabled'] == null ? true : Helper.isTrue(json['leap_pay_enabled']);
    isFeePassoverEnabled = Helper.isTrue(json['fee_passover_enabled']);
    defaultPaymentMethod = json["payment_method"];
    beaconAccountId = json['beacon_account_id'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  FilesListingModel.fromCompanyCamJson(Map<String, dynamic> json) {
    id = json['id'];
    creatorType = json['creator_type'];
    creatorName = json['creator_name'];
    name = json['name'];
    photoCount = json['photo_count'];
    isSelected = false;
    address = json['address'] != null ? AddressModel.fromCompanyCamJson(json['address']) : null;
    addressString = Helper.convertAddress(address);
    if (json['feature_image'] != null) {
      featureImage = <FeatureImageModal>[];
      json['feature_image'].forEach((dynamic v) {
        featureImage!.add(FeatureImageModal.fromJson(v));
      });
    }
    isDir = 1;
    if (isDir == 1) {
      jpThumbType ??= JPThumbType.folder;
    }
  }

  FilesListingModel.fromBeaconOrderStatus(Map<String, dynamic> json) {
    id = json['order_id']?.toString();
    status = json['status'];
  }

  FilesListingModel.fromCompanyCamImagesJson(Map<String, dynamic> json) {
    id = json['id'];
    creatorName = json['creator_name'];
    showThumbImage ??= true;
    status = json['status'];
    projectId = json['project_id'];
    isDir = 0;
    if (isDir == 0) {
      jpThumbType ??= JPThumbType.image;
    }
    isSelected = false;
    thumbUrl = json['uris'][3]['uri'].toString().split('?').first;
    name = json['id'];
    path = json["photo_url"];
    originalFilePath = json['uris'][3]['uri'].toString().split('?').first;
    updatedAt = DateTimeHelper.unixToDateTime(json['updated_at']);
  }

  FilesListingModel.fromUnsavedResourceJson(Map<String, dynamic> data) {
    Map<String, dynamic> temp = json.decode(data['data']);
    id = temp['id']?.toString() ?? temp["order_id"]?.toString() ?? temp["template_id"]?.toString();
    unsavedResourceId = data['id'] ?? data['unsaved_resource_id'];
    unitNumber = temp["unit_number"]?.toString();
    type = ResourceType.unsavedResource;
    unsavedResourceType = data["type"];
    if(unsavedResourceType == UnsavedResourcesHelper.getUnsavedResourcesString(UnsavedResourceType.proposalForm)
        || unsavedResourceType == UnsavedResourcesHelper.getUnsavedResourcesString(UnsavedResourceType.handWrittenTemplate)) {
      name = "(${"auto_saved".tr}) ${temp['title']?.toString() ?? data['type'].toString().capitalize}";
    } else {
      name = "(${"auto_saved".tr}) ${data['type'].toString().capitalize}";
    }

    isSelected = false;
    openBalance = temp["total_price"]?.toString();
    noOfChild = 0;
    isDir = 0;
    size = 0;
    createdAt = data["created_at"];
    updatedAt = data["updated_at"];
    isWorkSheet = false;
    if (isDir != null) {
      jpThumbType = JPThumbType.icon;
    }

    if (isDir == 0 && originalFilePath != null) {
      jpThumbIconType = Helper.getIconTypeAccordingToExtension(originalFilePath!);
    }
  }

  factory FilesListingModel.fromFinancialListModel(FinancialListingModel model) {
    return FilesListingModel(
        id: model.id.toString(),
        name: FileHelper.getFileName(model.url!),
        url: model.url,
        path: model.url,
        jpThumbIconType: Helper.getIconTypeAccordingToExtension(model.url!)
    );
  }

  Map<String, dynamic> toJobInvoiceJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = int.tryParse(id ?? "");
    data['parent_id'] = parentId;
    data['name'] = name;
    data['invoice_number'] = invoiceNumber;
    data['unit_number'] = unitNumber;
    data['quickbook_invoice_id'] = qbInvoiceId;
    data['proposal_id'] = proposalId;
    data['open_balance'] = openBalance;
    data['proposal_share_url'] = proposalUrl;
    data['file_size'] = size.toString();
    data['type'] = type;
    data['title'] =  title;
    data['path'] = path;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['file_path'] = originalFilePath;
    data['thumb_url'] = thumbUrl;
    data['unsaved_resource_id'] = unsavedResourceId;
    data['job_id'] = jobId;
    data['leap_pay_enabled'] = Helper.isTrueReverse(isAcceptingLeapPay);
    data['fee_passover_enabled'] = Helper.isTrueReverse(isFeePassoverEnabled);
    data['payment_method'] = defaultPaymentMethod;
    data['beacon_account_id'] = beaconAccountId;
    return data;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] =id;
    data['parent_id'] = parentId;
    data['name'] = name;
    data['size'] = size;
    data['path'] = path;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['url'] = url;
    data['thumb_url'] = thumbUrl;
    data['my_favourite_entity'] = myFavouriteEntity?.toJson();
    data['class_type'] = classType;
    return data;
  }

  /// [hasLinkedMaterialItem] helps in checking if there is any material supplier
  /// or material items in linked material list
  bool hasLinkedMaterialItem({String? key}) {
    if (key != null) {
      final supplierId = Helper.getSupplierId(key: key);
      return linkedMaterialLists?.any((supplier) => supplier.forSupplierId == supplierId) ?? false;
    } else {
      return linkedMaterialLists?.any((supplier) => supplier.forSupplierId == null) ?? false;
    }
  }

  // This method takes in a JSON map and returns the class type based on the provided mime types.
  // If no mime types are available, it sets a default mime type of "application/pdf".
  String getClassType(Map<String, dynamic> json) {
    // Get the mime types from the JSON map
    mimeType = json["mime_type"];
    fileMimeType = json["file_mime_type"];

    // Check if there are no mime types and the type is not "dropbox"
    bool hasNotMimeTypes = !json.containsKey("mime_type") &&
        !json.containsKey("file_mime_type") &&
        type != "dropbox";

    // If there are no mime types, set the default mime type to "application/pdf"
    if (hasNotMimeTypes) {
      mimeType = "application/pdf";
    }

    // Create temporary variables to store mime types
    String tempMimeType = "";

    // Set the temporary mime type based on the available mime types
    if (!Helper.isValueNullOrEmpty(mimeType)) {
      tempMimeType = mimeType!;
    } else if (!Helper.isValueNullOrEmpty(fileMimeType)) {
      tempMimeType = fileMimeType!;
    }

    // Get the class type based on the temporary mime type
    String tempClassType = FileHelper.getClassType(tempMimeType);

    // If the class type is "jpg", change it to "png"
    if (tempClassType == "jpg") {
      tempClassType = "png";
    }

    // Check if the class type is "unknown"
    isUnSupportedFile = tempClassType == "unknown";

    // Return the class type
    return tempClassType;
  }

  /// [getRelativeTime] helps in displaying relative time over file
  String? getRelativeTime() {
    // Relative time should not be displayed over folders
    bool isFolder = jpThumbType == JPThumbType.folder;
    // Relative time should not be displayed over when updated at does not exists
    DateTime? parsedLastModifiedTime = DateTime.tryParse(updatedAt ?? "");
    // Relative time should not be displayed over when updated at does not exists
    if (isFolder || Helper.isValueNullOrEmpty(parsedLastModifiedTime)) return null;
    // Parsing updateAt to relative time
    if (DateTimeHelper.now().isBefore(parsedLastModifiedTime!)) {
      updatedAt = DateTimeHelper.now().toString();
    }
    String relativeTime = DateTimeHelper.formatDate(updatedAt!, 'am_time_ago');
    return relativeTime;
  }

  void setCreatedBy(Map<String, dynamic> json) {
    dynamic createByJson = json['created_by'] ?? json['createdBy'];
    if (createByJson is Map) {
      createdBy = CreatedByDetails.fromJson(createByJson as Map<String, dynamic>).id;
    } else {
      createdBy = int.tryParse(createByJson.toString());
    }
  }

  /// Converts a FilesListingModel to a PhotoDetails model for use in the photo viewer.
  /// 
  /// This method transforms the current file listing item into a PhotoDetails object
  /// that can be displayed in the photo viewer dialog. It handles different file sources
  /// and ensures proper URL structure based on the module type.
  /// 
  /// Parameters:
  /// - [type]: The module type (FLModule) that determines how URLs are structured
  /// 
  /// Returns:
  /// A PhotoDetails object ready to be displayed in the photo viewer
  PhotoDetails toPhotoDetailModel(FLModule type) {
    // Create a new PhotoDetails object with properties from this file listing
    final photoDetails = PhotoDetails(
      name ?? 'photos'.tr,  // Use file name or default to 'photos' translation
      urls: multiSizeImages ?? (originalFilePath != null ? [originalFilePath!] : null),
      base64Image: base64Image,  // Pass through any base64 image data
      id: id.toString(),
      parentId: parentId.toString(),
    );

    // For non-Dropbox listings, insert the thumbnail URL at the beginning of the URLs list
    // This ensures thumbnails are used for preview while full images are used for viewing
    if (FLModule.dropBoxListing != type) photoDetails.urls!.insert(0, thumbUrl!);

    return photoDetails;
  }
}

class Ancestor {
  int? id;
  String? name;
  int? parentId;

  Ancestor({this.id, this.name, this.parentId});

  Ancestor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    parentId = json['parent_id'];
  }
}

class CreatedByDetails {
  int? id;
  String? name;

  CreatedByDetails({this.id, this.name});

  CreatedByDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}