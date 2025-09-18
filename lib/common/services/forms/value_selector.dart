import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/sheet_line_item_type.dart';
import 'package:jobprogress/common/enums/attach_file.dart';
import 'package:jobprogress/common/enums/network_singleselect.dart';
import 'package:jobprogress/common/enums/page_type.dart';
import 'package:jobprogress/common/models/address/address.dart';
import 'package:jobprogress/common/models/attachment.dart';
import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/common/models/financial_product_search/financial_product_search.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jobprogress/common/models/network_singleselect/params.dart';
import 'package:jobprogress/common/services/file_attachment/quick_actions.dart';
import 'package:jobprogress/core/constants/file_uploder.dart';
import 'package:jobprogress/core/constants/navigation_parms_constants.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/core/utils/file_helper.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/network_singleselect/index.dart';
import 'package:jobprogress/modules/appointments/create_appointment/select_jobs_of_customer/index.dart';
import 'package:jobprogress/routes/pages.dart';
import 'package:jp_mobile_flutter_ui/AccountingHeadSingleSelect/index.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/index.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

/// FormValueSelectorService helps in selecting necessary form data (users, attachments, jobs etc.)
class FormValueSelectorService {
  static openMultiSelect({
    required List<JPMultiSelectModel> list,
    List<JPMultiSelectModel>? tags,
    required String title,
    String? inputHintText,
    JPInputBoxController? controller,
    VoidCallback? onSelectionDone,
  }) {
    showJPBottomSheet(
        child: (_) {
          return JPMultiSelect(
            mainList: list,
            inputHintText: 'search_here'.tr,
            title: title,
            subList: tags,
            canShowSubList: (tags?.isNotEmpty ?? false) ? true : false,
            onDone: (result) {
              list.clear();
              list.addAll(result);
              if(controller != null)  parseMultiSelectData(result, controller);
              Get.back();
              if (onSelectionDone != null) onSelectionDone();
            },
          );
        },
        isScrollControlled: true);
  }

  static void parseMultiSelectData(List<JPMultiSelectModel> result, JPInputBoxController controller) {
    final selectedValuesList = getSelectedMultiSelectValues(result); // filtering selected options
    controller.text = selectedValuesList.map((e) => e.label).toList().join(', ');
  }

  static List<JPMultiSelectModel> parseJobsListToMultiselect(List<JobModel> job) {
    List<JPMultiSelectModel> selectedJobList = [];
    String trade = '';
    for(int i = 0;i < job.length; i++){
      if (!Helper.isValueNullOrEmpty(job[i].trades)) {
        trade = job[i].trades!.first.name ?? '';
      }

      selectedJobList.add(JPMultiSelectModel(label: '${Helper.getJobName(job[i])} / $trade' , id: job[i].id.toString(), isSelect: true));
    }
    return selectedJobList;
  }

  static void openSingleSelect({
      required List<JPSingleSelectModel> list,
      JPInputBoxController? controller,
      required String selectedItemId,
      required Function(String) onValueSelected,
      Widget Function(JPSingleSelectModel jpSingleSelectModel)? contentWidget,
      String? title
      }
  ) {
    showJPBottomSheet(
      isScrollControlled: true,
      ignoreSafeArea: false,
      child: (_) {
        return JPSingleSelect(
          mainList: list,
          inputHintText: 'search_here'.tr,
          title: title ?? 'select'.tr,
          selectedItemId: selectedItemId,
          onItemSelect: (val) {
            if(val == 'custom') {
              Get.back();
              onValueSelected(val);
            } else {
              selectedItemId = val;
              controller?.text = list.firstWhere((element) => element.id == val).label;
              onValueSelected(val);
              Get.back();
            }
          }
        );
      },
    );
  }

  static void openAccountingHeadSingleSelect(
      {required List<JPSingleSelectModel> list,
        required JPInputBoxController controller,
        required String selectedItemId,
        required Function(String) onValueSelected,
        String? title
      }
      ) {
    showJPBottomSheet(
      isScrollControlled: true,
      child: (_) {
        return AccountingHeadSingleSelect(
            mainList: list,
            inputHintText: 'search_here'.tr,
            title: title ?? 'select'.tr,
            selectedItemId: selectedItemId,
            onItemSelect: (val) {
                selectedItemId = val;
                onValueSelected(val);
                controller.text = list.firstWhere((element) => element.id == val).label;
                Get.back();
            }
        );
      },
    );
  }

  static Future<void> openNetworkSingleSelect({
    JPInputBoxController? controller,
    required String selectedItemId,
    required Function(JPSingleSelectModel) onValueSelected,
    String? title,
    JPSingleSelectParams? params,
    JPNetworkSingleSelectType networkListType = JPNetworkSingleSelectType.cities,
    List<JPSingleSelectModel>? optionsList,
  }) async {

    await showJPBottomSheet(
      isScrollControlled: true,
      child: (_) {
        return JPNetworkSingleSelect(
          selectedItemId: selectedItemId,
          inputHintText: 'search_here'.tr,
          title: title ?? 'select'.tr,
          type: networkListType,
          requestParams: params,
          optionsList: optionsList ?? [],
          onDone: (item) {
            selectedItemId = item.id;
            controller?.text = item.label;
            onValueSelected(item);
            Get.back();
          },
        );
      },
    );
  }

  static Future<void> selectJob({
      required JobModel? jobModel,
      required JPInputBoxController controller,
      required Function(JobModel) onSelectionDone
  }) async {
    final job = await Get.toNamed(Routes.customerJobSearch,
        arguments: {
          NavigationParams.pageType: PageType.selectJob,
        },
        preventDuplicates: false);

    if (job != null) {
      jobModel = job;
      setJobName(jobModel: jobModel!, controller: controller);
      onSelectionDone(job);
    }
  }

  static void setJobName({
    required JobModel jobModel,
    required JPInputBoxController controller,
  }) {
    String? customerName = jobModel.customer?.fullName;
    controller.text = (customerName != null ? '$customerName / ' : '') + Helper.getJobName(jobModel);
  }

  static Future<void> selectCustomer({
    required JPInputBoxController customerController,
    required CustomerModel? customerModel,
    required Function(CustomerModel) onSelectionDone}) async {
    final customerDetail = await Get.toNamed(Routes.customerJobSearch,
        arguments: { NavigationParams.pageType: PageType.selectCustomer},
        preventDuplicates: false);

    if (customerDetail != null) {
      setCustomerName(customerModel: customerDetail!, controller: customerController);
      onSelectionDone(customerDetail);
    }
  }

  static void setCustomerName({
    required JPInputBoxController controller,
    required CustomerModel customerModel,
  }) {
    String? customerName = customerModel.fullName;
    controller.text = (customerName ?? '');
  }

  static Future<void> selectJobOfCustomer({
    required CustomerModel? customerModel,
    required JPInputBoxController controller,
    required List<JobModel> selectedJobs,
    required Function(List<JobModel>) onSelectionDone,}) async {
    List<JobModel>? job = await showJPBottomSheet(
      child: (context) {
        return SelectJobOfCustomerBottomSheet(customerID: customerModel!.id,selectedJobs: selectedJobs,);
      },);
    if(job != null) {
      onSelectionDone(job);
    }
  }

  static Future<void> selectDate({
    String? initialDate,
    bool isPreviousDateSelectionAllowed = false,
    required DateTime? date,
    required JPInputBoxController controller,
    required Function(DateTime) onDateSelected,
    String? firstDate,
  }) async {
    initialDate ??= DateTime.now().toString();

    if (!isPreviousDateSelectionAllowed) {
      DateTime today = DateTime.now();
      initialDate = (DateTime.parse(initialDate).isBefore(today))
          ? today.toString()
          : initialDate;
    }

    final selectDate = await DateTimeHelper.openDatePicker(
      initialDate: initialDate,
      isPreviousDateSelectionAllowed: isPreviousDateSelectionAllowed,
      firstDate: firstDate
    );
    if (selectDate != null) {
      controller.text = DateTimeHelper.convertHyphenIntoSlash(
          selectDate.toString().substring(0, 10));
      onDateSelected(selectDate);
    }
  }

  // selectAttachments() : displays quick actions sheet to select files from
  static Future<void> selectAttachments({
    required List<AttachmentResourceModel> attachments,
    VoidCallback? onSelectionDone,
    int? jobId,
    String? companyCamProjectId,
    String uploadType = FileUploadType.attachment,
    bool dirWithImageOnly = false,
    AttachmentOptionType type = AttachmentOptionType.jobDependent,
    bool isSrs = false,
    required int maxSize,
  }) async {
    Helper.hideKeyboard();

    await FileAttachService.openQuickActions(
      dirWithImageOnly: dirWithImageOnly,
      companyCamProjectId: companyCamProjectId,
      type: type,
      uploadType: uploadType,
      isSrs: isSrs,
      maxSize: maxSize,
      onFilesSelected: (selectedAttachments) {
        addSelectedFilesToAttachment(
          selectedAttachments,
          attachments: attachments,
          uploadType: uploadType,
          dirWithImageOnly: dirWithImageOnly,
        );
        if (onSelectionDone != null) onSelectionDone();
      },
      allowMultiple: true,
      jobId: jobId,
    );
  }

  // addSelectedFilesToAttachment() : add files to attachment list
  static void addSelectedFilesToAttachment(
    List<AttachmentResourceModel> files, {
    int? jobId,
    String uploadType = FileUploadType.attachment,
    bool dirWithImageOnly = false,
    required List<AttachmentResourceModel> attachments,
  }) {
    for (var file in files) {
      if (dirWithImageOnly) {
        // checking whether file is already attached and is it an image file
        if (FileHelper.checkIfImage(file.path ?? "") && (uploadType == FileUploadType.template || !attachments.any((element) => element.id == file.id))) {
          attachments.add(AttachmentResourceModel.fromAttachmentResourceModel(file));
        }
      } else {
        // checking whether file is already attached
        if (uploadType == FileUploadType.template || !attachments.any((element) => element.id == file.id)) {
          attachments.add(AttachmentResourceModel.fromAttachmentResourceModel(file));
        }
      }
    }
  }

  static List<JPMultiSelectModel> getSelectedMultiSelectValues(List<JPMultiSelectModel> list) {
    return  list.where((element) => element.isSelect).toList();
  }

  static String getSelectedSingleSelectValue(List<JPSingleSelectModel> list, String id) {
    final selectedValue = (list.firstWhereOrNull((element) {
      return element.id == id;
    }));
    id = (selectedValue?.id ?? '');
    return (selectedValue?.label) ?? '';
  }

  // selectAddress(): can be used to navigate to search location page
  //                  to select address
  static void selectAddress({
    required JPInputBoxController controller,
    Function(AddressModel)? onDone,
  }) async {
    dynamic response = await Get.toNamed(Routes.searchLocation, arguments: {
      NavigationParams.address : controller.text
    }, preventDuplicates: false);
    if (response != null && response is AddressModel) {
      controller.text = (response).address ?? "";
      onDone?.call(response);
    }
  }

  static List<int> getDivisionIdsFromJobs({required List<JobModel> jobs}) {
    List<int?> divisionIds = jobs.map((job) => job.division?.id).toList();
    divisionIds.removeWhere((id) => id == null);
    return divisionIds.cast<int>();
  }

  static JPSingleSelectModel getSelectedSingleSelect(List<JPSingleSelectModel> list, String id) {
    final selectedValue = (list.firstWhereOrNull((element) => element.id == id));
    return selectedValue ?? JPSingleSelectModel(label: '', id: '');
  }

  static List<String> getSelectedMultiSelectIds(List<JPMultiSelectModel> list) {
    return list.where((element) => element.isSelect)
        .map((element) => element.id.toString())
        .toList();
  }

  static Future<dynamic>? searchFinancialProduct(
    FinancialProductSearchModel searchModel, 
    AddLineItemFormType pageType,
    {
      bool? enableAddButton,
      String? worksheetType
    }) async {
      return await Get.toNamed(
        Routes.financialProductSearch, arguments: {
          NavigationParams.filterParams: searchModel,
          NavigationParams.addLineItemFormType: pageType,
          NavigationParams.enabledAddButton: enableAddButton,
          NavigationParams.worksheetType: worksheetType
        }
      );
    }
}
