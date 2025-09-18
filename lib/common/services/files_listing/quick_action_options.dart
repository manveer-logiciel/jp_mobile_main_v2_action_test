import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/models/files_listing/linked_material.dart';
import 'package:jobprogress/common/services/files_listing/quick_actions.dart';
import 'package:jobprogress/core/constants/assets_files.dart';
import 'package:jobprogress/core/constants/common_constants.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jp_mobile_flutter_ui/QuickAction/model.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

// FileListingQuickActionOptions contains actions that will be displayed on quick action popup
class FileListingQuickActionOptions {

  static const double iconSize = 20;

  static JPQuickActionModel rename = JPQuickActionModel(
    id: FLQuickActions.rename.toString(),
    label: 'rename'.tr,
    child: const JPIcon(Icons.drive_file_rename_outline, size: iconSize),
  );

  static JPQuickActionModel insurance = JPQuickActionModel(
    id: FLQuickActions.insurance.toString(),
    label: 'insurance'.tr.capitalize!, 
    child: const JPIcon(Icons.calendar_view_month_outlined, size: iconSize), 
    sublist: FilesListingService.insuranceOptions,
  );

  static JPQuickActionModel worksheet = JPQuickActionModel(
    id: FLQuickActions.worksheet.toString(),
    label: 'worksheet'.tr.capitalize!,
    child: const JPIcon(Icons.calendar_view_month_outlined, size: iconSize),
  );

  static JPQuickActionModel print = JPQuickActionModel(
      id: FLQuickActions.print.toString(),
      label: 'print'.tr,
      child: const JPIcon(Icons.print_outlined, size: iconSize));

  static JPQuickActionModel move = JPQuickActionModel(
      id: FLQuickActions.move.toString(),
      label: 'move_to'.tr,
      child: const JPIcon(Icons.drive_file_move_outline, size: iconSize));

  static JPQuickActionModel moveToJob = JPQuickActionModel(
      id: FLQuickActions.moveToJob.toString(),
      label: 'move_to_job'.tr.capitalize!,
      child: const JPIcon(Icons.drive_file_move_outline, size: iconSize));

  static JPQuickActionModel rotate = JPQuickActionModel(
    id: FLQuickActions.rotate.toString(),
    label: 'rotate'.tr,
    child: const JPIcon(Icons.refresh, size: iconSize),
    sublist: FilesListingService.rotationOptions,
  );

  static JPQuickActionModel dropBox = JPQuickActionModel(
    id: FLQuickActions.dropBox.toString(),
    label: 'dropbox'.tr,
    child: SvgPicture.asset(AssetsFiles.dropBox, colorFilter: ColorFilter.mode(JPAppTheme.themeColors.text.withValues(alpha: 0.8), BlendMode.srcIn)));

  static JPQuickActionModel delete = JPQuickActionModel(
      id: FLQuickActions.delete.toString(),
      label: 'delete'.tr,
      child: const JPIcon(Icons.delete_outlined, size: iconSize));

  static JPQuickActionModel info = JPQuickActionModel(
      id: FLQuickActions.info.toString(),
      label: 'info'.tr,
      child: const JPIcon(Icons.info_outlined, size: iconSize));

  static JPQuickActionModel spreadSheetTemplate = JPQuickActionModel(
      id: FLQuickActions.spreadSheetTemplate.toString(),
      label: 'google_spreadsheet_template'.tr,
      child: Image.asset(AssetsFiles.googleSpreadsheet));

  static JPQuickActionModel newSpreadsheet = JPQuickActionModel(
      id: FLQuickActions.newSpreadsheet.toString(),
      label: 'new_google_spreadsheet'.tr,
      child: Image.asset(AssetsFiles.googleSpreadsheet));

  static JPQuickActionModel uploadExcel = JPQuickActionModel(
      id: FLQuickActions.uploadExcel.toString(),
      label: 'upload_excel_sheet'.tr,
      child: Image.asset(AssetsFiles.msExcel));            

  static JPQuickActionModel view = JPQuickActionModel(
      id: FLQuickActions.view.toString(),
      label: 'view'.tr,
      child: const JPIcon(Icons.remove_red_eye_outlined, size: iconSize));

  static JPQuickActionModel showOnCustomerWebPage = JPQuickActionModel(
      id: FLQuickActions.showOnCustomerWebPage.toString(),
      label: 'show_on_customer_web_page'.tr,
      child: const JPIcon(Icons.remove_red_eye_outlined, size: iconSize));


  static JPQuickActionModel removeFromCustomerWebPage = JPQuickActionModel(
      id: FLQuickActions.removeFromCustomerWebPage.toString(),
      label: 'remove_from_customer_web_page'.tr,
      child: const JPIcon(Icons.visibility_off_outlined, size: iconSize));


  static JPQuickActionModel sendViaText = JPQuickActionModel(
      id: FLQuickActions.sendViaText.toString(),
      label: 'send_via_text'.tr,
      child: const JPIcon(Icons.send_to_mobile_outlined, size: iconSize),
      sublist: FilesListingService.sendViaTextOptions(),
      );

  static JPQuickActionModel sendViaJobProgress = JPQuickActionModel(
    id: FLQuickActions.sendViaJobProgress.toString(),
    label: 'send_via_text'.tr,
    child: const JPIcon(Icons.send_to_mobile_outlined, size: iconSize),
  );

  static JPQuickActionModel share = JPQuickActionModel(
      id: FLQuickActions.share.toString(),
      label: 'share'.tr,
      child: const JPIcon(Icons.share, size: iconSize));


  static JPQuickActionModel viewLinkedForm = JPQuickActionModel(
      id: FLQuickActions.viewLinkedForm.toString(),
      label: 'view_linked_form_proposal'.tr,
      child: const JPIcon(Icons.remove_red_eye_outlined, size: iconSize));

  static JPQuickActionModel viewLinkedWorkOrder = JPQuickActionModel(
      id: FLQuickActions.viewLinkedWorkOrder.toString(),
      label: 'view_linked_work_order'.tr,
      child: const JPIcon(Icons.remove_red_eye_outlined, size: iconSize));

  static JPQuickActionModel viewLinkedMaterialList({List<LinkedMaterialModel>? materials}) {

    List<JPQuickActionModel> subList = [];
    if ((materials?.length ?? 0) > 1) {
      materials?.forEach((material) {
        // Checking the linked material type
        bool isSRSMaterial = Helper.isSRSv1Id(material.forSupplierId) || Helper.isSRSv2Id(material.forSupplierId);
        bool isBeaconMaterial = material.forSupplierId == Helper.getSupplierId(key: CommonConstants.beaconId);
        bool isABCMaterial = material.forSupplierId == Helper.getSupplierId(key: CommonConstants.abcSupplierId);
        String label = ""; // holds the label to be displayed
        String id = ""; // holds the unique id
        // Checking the linked material type and setting up label and unique id accordingly
        if (isSRSMaterial) {
          label = 'view_linked_srs_order_form'.tr;
          id = FLQuickActions.viewLinkedSRSOrderForm.toString();
        } else if (isBeaconMaterial) {
          label = 'view_linked_beacon_order_form'.tr;
          id = FLQuickActions.viewLinkedBeaconOrderForm.toString();
        } else if (isABCMaterial) {
          label = 'view_linked_abc_order_form'.tr;
          id = FLQuickActions.viewLinkedBeaconOrderForm.toString();
        } else {
          label = 'view_linked_material_list'.tr;
          id = FLQuickActions.viewLinkedMaterialList.toString();
        }
        // Setting up list
        subList.add(JPQuickActionModel(
          id: '$id ${material.filePath}',
          label: label,
          child: const JPIcon(Icons.remove_red_eye_outlined, size: iconSize),
        ));
      });
    }

    final parentFilePath = (subList.isEmpty ? (materials?.first.filePath ?? "") : '');

    return JPQuickActionModel(
        id: FLQuickActions.viewLinkedMaterialList.toString() + parentFilePath,
        label: subList.isNotEmpty ? 'view_material_list'.tr : 'view_linked_material_list'.tr,
        child: const JPIcon(Icons.remove_red_eye_outlined, size: iconSize),
        sublist: subList.isEmpty ? null : subList
    );
  }


  static JPQuickActionModel viewLinkedMeasurement = JPQuickActionModel(
      id: FLQuickActions.viewLinkedMeasurement.toString(),
      label: 'view_linked_measurement'.tr,
      child: const JPIcon(Icons.remove_red_eye_outlined, size: iconSize));

  static JPQuickActionModel unMarkAsFavourite = JPQuickActionModel(
      id: FLQuickActions.unMarkAsFavourite.toString(),
      label: 'unmark_mark_as_favourite'.tr,
      child: const JPIcon(Icons.grade_outlined, size: iconSize));

  static JPQuickActionModel email = JPQuickActionModel(
      id: FLQuickActions.email.toString(),
      label: 'email'.tr,
      child: const JPIcon(Icons.email_outlined, size: iconSize));
  
  static JPQuickActionModel markAsCompleted = JPQuickActionModel(
      id: FLQuickActions.markAsCompleted.toString(),
      label: 'mark_as_completed'.tr.capitalize!,
      child: const JPIcon(Icons.check_circle_outline_outlined, size: iconSize));
  
  static JPQuickActionModel markAsPending = JPQuickActionModel(
      id: FLQuickActions.markAsPending.toString(),
      label: 'mark_as_pending'.tr.capitalize!,
      child: const JPIcon(Icons.unpublished_outlined, size: iconSize)); 
  
  static JPQuickActionModel assignTo = JPQuickActionModel(
      id: FLQuickActions.assignTo.toString(),
      label: 'assign_to'.tr.capitalize!,
      child: const JPIcon(Icons.group_outlined, size: iconSize));

  static JPQuickActionModel editPhoto = JPQuickActionModel(
      id: FLQuickActions.editPhoto.toString(),
      label: 'edit_photo'.tr,
      child: const JPIcon(Icons.edit_outlined, size: iconSize)
  );
  static JPQuickActionModel editMeasurement = JPQuickActionModel(
      id: FLQuickActions.editMeasurement.toString(),
      label: 'edit'.tr,
      child: const JPIcon(Icons.edit_outlined, size: iconSize)
  );

  static JPQuickActionModel edit = JPQuickActionModel(
      id: FLQuickActions.edit.toString(),
      label: 'edit'.tr,
      child: const JPIcon(Icons.edit_outlined, size: iconSize));

  static JPQuickActionModel editGoogleSheet = JPQuickActionModel(
      id: FLQuickActions.editGoogleSheet.toString(),
      label: 'edit'.tr,
      child: const JPIcon(Icons.edit_outlined, size: iconSize));    
  
  static JPQuickActionModel editInsurance = JPQuickActionModel(
      id: FLQuickActions.editInsurance.toString(),
      label: 'edit'.tr,
      child: const JPIcon(Icons.edit_outlined, size: iconSize));

  static JPQuickActionModel editWorksheet = JPQuickActionModel(
      id: FLQuickActions.editWorksheet.toString(),
      label: 'edit'.tr,
      child: const JPIcon(Icons.edit_outlined, size: iconSize));

  static JPQuickActionModel editProposalTemplate = JPQuickActionModel(
      id: FLQuickActions.editProposalTemplate.toString(),
      label: 'edit'.tr,
      child: const JPIcon(Icons.edit_outlined, size: iconSize));

  static JPQuickActionModel signTemplateProposal = JPQuickActionModel(
      id: FLQuickActions.signTemplateFormProposal.toString(),
      label: 'sign_form_proposal'.tr,
      child: const JPIcon(Icons.draw_outlined, size: iconSize));

  static JPQuickActionModel worksheetSignProposal = JPQuickActionModel(
      id: FLQuickActions.worksheetSignFormProposal.toString(),
      label: 'sign_form_proposal'.tr,
      child: const JPIcon(Icons.draw_outlined, size: iconSize));

  static JPQuickActionModel openPublicForm = JPQuickActionModel(
      id: FLQuickActions.openPublicForm.toString(),
      label: 'open_public_form_proposal_page'.tr,
      child: const JPIcon(Icons.open_in_new, size: iconSize));

  static JPQuickActionModel viewLinkedInvoice = JPQuickActionModel(
      id: FLQuickActions.viewLinkedInvoice.toString(),
      label: 'view_linked_invoice'.tr,
      child: const JPIcon(Icons.remove_red_eye_outlined, size: iconSize));

  static JPQuickActionModel formProposalNote = JPQuickActionModel(
      id: FLQuickActions.formProposalNote.toString(),
      label: 'form_proposal_note'.tr,
      child: const JPIcon(Icons.note_outlined, size: iconSize));

  static JPQuickActionModel updateStatus = JPQuickActionModel(
      id: FLQuickActions.updateStatus.toString(),
      label: 'update_status'.tr,
      child: const JPIcon(Icons.update, size: iconSize));

  static JPQuickActionModel viewLinkedInvoices = JPQuickActionModel(
      id: FLQuickActions.viewLinkedInvoices.toString(),
      label: 'view_linked_invoices'.tr,
      child: const JPIcon(Icons.remove_red_eye_outlined, size: iconSize));

  static JPQuickActionModel makeACopy = JPQuickActionModel(
      id: FLQuickActions.makeACopy.toString(),
      label: 'make_a_copy'.tr,
      child: const JPIcon(Icons.copy_outlined, size: iconSize));

  static JPQuickActionModel viewLinkedEstimate = JPQuickActionModel(
      id: FLQuickActions.viewLinkedEstimate.toString(),
      label: 'view_linked_estimate'.tr,
      child: const JPIcon(Icons.remove_red_eye_outlined, size: iconSize));

  static JPQuickActionModel viewLinkedJobSchedules = JPQuickActionModel(
      id: FLQuickActions.viewLinkedJobSchedules.toString(),
      label: 'view_linked_job_schedules'.tr,
      child: const JPIcon(Icons.remove_red_eye_outlined, size: iconSize));

  static JPQuickActionModel generateJobInvoice = JPQuickActionModel(
      id: FLQuickActions.generateJobInvoice.toString(),
      label: 'generate_job_invoice'.tr,
      child: const JPIcon(Icons.receipt_outlined, size: iconSize));

  static JPQuickActionModel generateMaterialList = JPQuickActionModel(
      id: FLQuickActions.generateMaterialList.toString(),
      label: 'generate_material_list'.tr,
      child: const JPIcon(Icons.format_list_numbered_outlined, size: iconSize));

  static JPQuickActionModel materialList(bool hasSRsItem, bool hasBeaconItem, bool hasABCItem, bool canCreateMaterialList) => JPQuickActionModel(
      id: FLQuickActions.materialList.toString(),
      label: 'material_list'.tr.capitalize!,
      child: const JPIcon(Icons.format_list_numbered_outlined, size: iconSize),
      sublist: [
        if(canCreateMaterialList)generateMaterialList,
        if (hasSRsItem) generateSRSOrderForm,
        if (hasBeaconItem) generateBeaconOrderForm,
        if (hasABCItem) generateABCOrderForm,
      ]
  );

  static JPQuickActionModel viewLinkedSRSOrderForm(String? path) => JPQuickActionModel(
      id: '${FLQuickActions.viewLinkedSRSOrderForm} $path',
      label: 'view_linked_srs_order_form'.tr,
      child: const JPIcon(Icons.remove_red_eye_outlined, size: iconSize));

  static JPQuickActionModel viewLinkedBeaconOrderForm(String? path) => JPQuickActionModel(
      id: '${FLQuickActions.viewLinkedBeaconOrderForm} $path',
      label: 'view_linked_beacon_order_form'.tr,
      child: const JPIcon(Icons.remove_red_eye_outlined, size: iconSize));

  static JPQuickActionModel viewLinkedABCOrderForm(String? path) => JPQuickActionModel(
      id: '${FLQuickActions.viewLinkedABCOrderForm} $path',
      label: 'view_linked_abc_order_form'.tr,
      child: const JPIcon(Icons.remove_red_eye_outlined, size: iconSize));

  static JPQuickActionModel generateSRSOrderForm = JPQuickActionModel(
      id: FLQuickActions.generateSRSOrderForm.toString(),
      label: 'Generate_srs_order_form'.tr,
      child: const JPIcon(Icons.list_alt_outlined, size: iconSize));

  static JPQuickActionModel generateBeaconOrderForm = JPQuickActionModel(
      id: FLQuickActions.generateBeaconOrderForm.toString(),
      label: 'generate_beacon_order_form'.tr,
      child: const JPIcon(Icons.list_alt_outlined, size: iconSize));

  static JPQuickActionModel generateABCOrderForm = JPQuickActionModel(
      id: FLQuickActions.generateABCOrderForm.toString(),
      label: 'generate_abc_order_form'.tr,
      child: const JPIcon(Icons.list_alt_outlined, size: iconSize));

  static JPQuickActionModel placeSRSOrder = JPQuickActionModel(
      id: FLQuickActions.placeSRSOrder.toString(),
      label: 'place_srs_order'.tr,
      child: const JPIcon(Icons.list_alt_outlined, size: iconSize));

  static JPQuickActionModel placeBeaconOrder = JPQuickActionModel(
      id: FLQuickActions.placeBeaconOrder.toString(),
      label: 'place_beacon_order'.tr,
      child: const JPIcon(Icons.list_alt_outlined, size: iconSize));

  static JPQuickActionModel placeABCOrder = JPQuickActionModel(
      id: FLQuickActions.placeABCOrder.toString(),
      label: 'place_abc_order_form'.tr,
      child: const JPIcon(Icons.list_alt_outlined, size: iconSize));

  static JPQuickActionModel generateWorkOrder = JPQuickActionModel(
      id: FLQuickActions.generateWorkOrder.toString(),
      label: 'generate_work_order'.tr,
      child: const JPIcon(Icons.receipt_long_outlined, size: iconSize));

  static JPQuickActionModel syncWithQBD = JPQuickActionModel(
      id: FLQuickActions.syncWithQBD.toString(),
      label: 'sync_with_qbd'.tr,
      child: const JPIcon(Icons.sync_outlined, size: iconSize));

  static JPQuickActionModel updateJobInvoice = JPQuickActionModel(
      id: FLQuickActions.updateJobInvoice.toString(),
      label: 'update_job_invoice'.tr,
      child: const JPIcon(Icons.update_outlined, size: iconSize));

  static JPQuickActionModel updateJobPrice(String price) => JPQuickActionModel(
      id: FLQuickActions.updateJobPrice.toString(),
      label: "${'update_job_price'.tr} ($price)",
      child: JPIcon(JobFinancialHelper.getCurrencyIcon(), size: iconSize));

  static JPQuickActionModel markAsFavourite = JPQuickActionModel(
      id: FLQuickActions.markAsFavourite.toString(),
      label: 'mark_as_favourite'.tr,
      child: const JPIcon(Icons.grade_outlined, size: iconSize));

  static JPQuickActionModel expiresOn = JPQuickActionModel(
      id: FLQuickActions.expireOn.toString(),
      label: 'expires_on'.tr,
      child: const JPIcon(Icons.event_note_outlined, size: iconSize));

  static JPQuickActionModel generateFormProposal = JPQuickActionModel(
      id: FLQuickActions.generateForm.toString(),
      label: 'generate_form_proposal'.tr,
      child: const JPIcon(Icons.view_quilt_outlined, size: iconSize));

  static JPQuickActionModel generateWorkSheet = JPQuickActionModel(
      id: FLQuickActions.generateWorkSheet.toString(),
      label: 'generate_work_sheet'.tr,
      child: const JPIcon(Icons.view_quilt_outlined, size: iconSize));

  static JPQuickActionModel insurancePDF(String path) => JPQuickActionModel(
      id: "${FLQuickActions.insurancePdf} $path",
      label: 'insurance_pdf'.tr,
      child: const JPIcon(Icons.picture_as_pdf_outlined, size: iconSize));

  static JPQuickActionModel viewMeasurementValues = JPQuickActionModel(
      id: FLQuickActions.viewMeasurementValues.toString(),
      label: 'view_measurement_values'.tr,
      child: const JPIcon(Icons.remove_red_eye_outlined, size: iconSize));

  static JPQuickActionModel hoverImages = JPQuickActionModel(
      id: FLQuickActions.hoverImages.toString(),
      label: 'hover_images'.tr,
      child: const JPIcon(Icons.info_outlined, size: iconSize));

  static JPQuickActionModel upgradeToHoverRoofOnly = JPQuickActionModel(
      id: FLQuickActions.upgradeToHoverRoofOnly.toString(),
      label: 'upgrade_to_hover_roof_only'.tr,
      child: const JPIcon(Icons.info_outlined, size: iconSize));

  static JPQuickActionModel upgradeToHoverRoofComplete = JPQuickActionModel(
      id: FLQuickActions.upgradeToHoverRoofComplete.toString(),
      label: 'upgrade_to_hover_roof_complete'.tr,
      child: const JPIcon(Icons.info_outlined, size: iconSize));

  static JPQuickActionModel open3DModel = JPQuickActionModel(
      id: FLQuickActions.open3DModel.toString(),
      label: 'open_3d_model'.tr,
      child: const JPIcon(Icons.info_outlined, size: iconSize));

  static JPQuickActionModel viewReports({List<JPQuickActionModel>? subList}) => JPQuickActionModel(
      id: FLQuickActions.viewReports.toString(),
      label: 'view_reports'.tr,
      sublist: subList,
      child: const JPIcon(Icons.view_quilt_outlined, size: iconSize));

  static JPQuickActionModel viewInfo = JPQuickActionModel(
      id: FLQuickActions.viewInfo.toString(),
      label: 'view_info'.tr,
      child: const JPIcon(Icons.info_outlined, size: iconSize));

  static JPQuickActionModel setDeliveryDate = JPQuickActionModel(
      id: FLQuickActions.setDeliveryDate.toString(),
      label: 'set_delivery_date'.tr,
      child: const JPIcon(Icons.calendar_today_outlined, size: iconSize));

  static JPQuickActionModel editWorkOrder = JPQuickActionModel(
      id: FLQuickActions.editWorkOrder.toString(),
      label: 'edit_work_order'.tr,
      child: const JPIcon(Icons.edit_outlined, size: iconSize));

  static JPQuickActionModel schedule = JPQuickActionModel(
      id: FLQuickActions.schedule.toString(),
      label: 'schedule'.tr,
      child: const JPIcon(Icons.event_note_outlined, size: iconSize));

  static JPQuickActionModel copyToJob = JPQuickActionModel(
      id: FLQuickActions.copyToJob.toString(),
      label: 'copy_to_job'.tr,
      child: const JPIcon(Icons.copy_outlined, size: iconSize));

  static JPQuickActionModel viewOrderDetails = JPQuickActionModel(
      id: FLQuickActions.viewOrderDetails.toString(),
      label: 'view_order_details'.tr,
      child: const JPIcon(Icons.visibility_outlined, size: iconSize));
  
  static JPQuickActionModel viewBeaconOrderDetails = JPQuickActionModel(
      id: FLQuickActions.viewBeaconOrderDetails.toString(),
      label: 'view_order_details'.tr,
      child: const JPIcon(Icons.visibility_outlined, size: iconSize));

  static JPQuickActionModel viewDeliveryDate = JPQuickActionModel(
      id: FLQuickActions.viewDeliveryDate.toString(),
      label: 'view_delivery_date'.tr,
      child: const JPIcon(Icons.event_note_outlined, size: iconSize));

  static JPQuickActionModel viewCumulativeInvoice = JPQuickActionModel(
      id: FLQuickActions.viewCumulativeInvoice.toString(),
      label: 'view'.tr,
      child: const JPIcon(Icons.remove_red_eye_outlined, size: iconSize));

  static JPQuickActionModel printCumulativeInvoice = JPQuickActionModel(
      id: FLQuickActions.printCumulativeInvoice.toString(),
      label: 'print'.tr,
      child: const JPIcon(Icons.print_outlined, size: iconSize));

  static JPQuickActionModel emailCumulativeInvoice = JPQuickActionModel(
      id: FLQuickActions.emailCumulativeInvoice.toString(),
      label: 'email'.tr,
      child: const JPIcon(Icons.email_outlined, size: iconSize));

  static JPQuickActionModel cumulativeInvoiceNote = JPQuickActionModel(
      id: FLQuickActions.cumulativeInvoiceNote.toString(),
      label: 'note'.tr,
      child: const JPIcon(Icons.description_outlined, size: iconSize));

  ///   Add More Quick Actions
  static JPQuickActionModel upload = JPQuickActionModel(
      id: FLQuickActions.upload.toString(),
      label: 'upload'.tr,
      child: const JPIcon(Icons.cloud_upload_outlined, size: iconSize));

  static JPQuickActionModel quickMeasure = JPQuickActionModel(
      id: FLQuickActions.quickMeasure.toString(),
      label: 'quick_measure'.tr,
      child: Image.asset(AssetsFiles.quickMeasure,
        height: iconSize,
        width: iconSize,
      ));

  static JPQuickActionModel eagleView = JPQuickActionModel(
      id: FLQuickActions.eagleView.toString(),
      label: 'eagle_view'.tr,
      child: Image.asset(AssetsFiles.eagleView,
        height: iconSize,
        width: iconSize,
      ));

  static JPQuickActionModel measurementForm = JPQuickActionModel(
      id: FLQuickActions.measurementForm.toString(),
      label: 'measurement_form'.tr,
      child: SvgPicture.asset(AssetsFiles.measurement,
        height: iconSize,
        width: iconSize,));

  static JPQuickActionModel hover = JPQuickActionModel(
      id: FLQuickActions.hover.toString(),
      label: 'sync_and_create_with_hover'.tr,
      child: Image.asset(AssetsFiles.hoverLogo,
        height: iconSize,
        width: iconSize,
      ),
  );
  static JPQuickActionModel jobFormProposalTemplate = JPQuickActionModel(
      id: FLQuickActions.jobFormProposalTemplate.toString(),
      label: 'form_proposal_template'.tr,
      child: const Icon(Icons.view_list_outlined,)
  );

  static JPQuickActionModel jobFormProposalMerge = JPQuickActionModel(
      id: FLQuickActions.jobFormProposalMerge.toString(),
      label: 'Merge Template'.tr,
      child: const Icon(Icons.view_list_outlined,)
  );

  static JPQuickActionModel editUnsavedResource = JPQuickActionModel(
    id: FLQuickActions.editUnsavedResource.toString(),
    label: 'edit'.tr,
    child: const JPIcon(Icons.edit_outlined, size: iconSize));

  static JPQuickActionModel deleteUnsavedResource = JPQuickActionModel(
    id: FLQuickActions.deleteUnsavedResource.toString(),
    label: 'delete'.tr,
    child: const JPIcon(Icons.delete_outlined, size: iconSize));

  static JPQuickActionModel handwrittenTemplate = JPQuickActionModel(
    id: FLQuickActions.handwrittenTemplate.toString(),
    label: 'handwritten_template'.tr,
    child: const Icon(Icons.view_list_outlined,)
  );

  static JPQuickActionModel editEstimateTemplate = JPQuickActionModel(
    id: FLQuickActions.editEstimateTemplate.toString(),
    label: 'edit'.tr,
    child: const JPIcon(Icons.edit_outlined, size: iconSize));

  static JPQuickActionModel chooseSupplierSettings = JPQuickActionModel(
      id: FLQuickActions.chooseSupplierSettings.toString(),
      label: 'choose_supplier_settings'.tr,
      child: const JPIcon(Icons.edit_outlined, size: iconSize));
}
