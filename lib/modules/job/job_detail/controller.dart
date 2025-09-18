import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/calendars.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/models/customer/customer.dart';
import 'package:jobprogress/common/models/files_listing/delivery_date.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_quick_action_params.dart';
import 'package:jobprogress/common/models/insurance/insurance_model.dart';
import 'package:jobprogress/common/models/job/customer_info.dart';
import 'package:jobprogress/common/models/job/job_division.dart';
import 'package:jobprogress/common/models/job/job_type.dart';
import 'package:jobprogress/common/models/phone.dart';
import 'package:jobprogress/common/models/schedules/schedules.dart';
import 'package:jobprogress/common/repositories/customer_listing.dart';
import 'package:jobprogress/common/repositories/job_type.dart';
import 'package:jobprogress/common/repositories/material_lists.dart';
import 'package:jobprogress/common/repositories/schedule.dart';
import 'package:jobprogress/common/services/files_listing/set_view_delivery_date/index.dart';
import 'package:jobprogress/common/services/forms/value_selector.dart';
import 'package:jobprogress/common/services/job/index.dart';
import 'package:jobprogress/common/services/launch_darkly/index.dart';
import 'package:jobprogress/common/services/workflow_stages/index.dart';
import 'package:jobprogress/core/constants/date_formats.dart';
import 'package:jobprogress/core/constants/launchdarkly/flag_keys.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/core/utils/form/db_helper.dart';
import 'package:jobprogress/global_widgets/add_edit_work_crew_dialog_box/index.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/controller.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/call_dialog/index.dart';
import 'package:jobprogress/modules/job/job_detail/update_duration/index.dart';
import 'package:jobprogress/modules/job/job_detail/update_material_po/index.dart';
import 'package:jobprogress/modules/job/job_detail/widgets/cateory_edit_dialog.dart';
import 'package:jp_mobile_flutter_ui/ConfirmationDialog/index.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/QuickEditDialog/type.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../common/enums/job.dart';
import '../../../common/enums/job_quick_action_callback_type.dart';
import '../../../common/enums/parent_form_type.dart';
import '../../../common/models/job/job.dart';
import '../../../common/repositories/job.dart';
import '../../../common/services/progress_board/add_to_progress_board.dart';
import '../../../core/constants/navigation_parms_constants.dart';
import '../../../core/utils/helpers.dart';
import '../../../core/utils/location_helper.dart';
import '../../../global_widgets/loader/index.dart';
import '../../../routes/pages.dart';

class JobDetailController extends GetxController {

  JobModel? jobModel;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoading = true;
  bool showInsuranceClaim = false;
  String selectedCategoryId = "";
  String? updatedStageCode;
  int emailCount = Get.arguments?[NavigationParams.emailCount] ?? 0;

  List<JPMultiSelectModel> filterByMultiList = [];
  List<JPSingleSelectModel>? materialList;
  List<JPMultiSelectModel> progressBoardsList = [];
  SchedulesModel? schedule;
 
  JPInputBoxController categoryController = JPInputBoxController();

  Map<String, dynamic>? initialInsuranceDetailsJson;

  @override
  void onInit() {
    // Argument getting null on update method.
    if(Get.arguments is Map) {
      fetchJob(id: Get.arguments[NavigationParams.jobId]);
    }
    
    super.onInit();
  }

  Map<String, dynamic> getQueryParams(int id) => {
    "includes[0]":"job_workflow_history",
    "includes[1]":"count:with_ev_reports(true)",
    "includes[2]":"workflow",
    "includes[3]":"flags",
    "includes[4]":"sub_contractors",
    "includes[5]":"financial_details",
    "includes[6]":"invoice.proposal",
    "includes[7]":"production_boards",
    "includes[8]":"job_invoices",
    "includes[9]":"custom_tax",
    "includes[10]":"contact",
    "includes[11]":"contacts.emails",
    "includes[12]":"contacts.phones",
    "includes[13]":"contacts.address",
    "includes[14]":"insurance_details",
    "includes[15]":"customer.contacts",
    "includes[16]":"customer.referred_by",
    "includes[17]":"job_message_count",
    "includes[18]":"upcoming_appointment_count",
    "includes[19]":"Job_note_count",
    "includes[20]":"job_task_count",
    "includes[21]":"hover_job",
    "includes[22]":"upcoming_appointment",
    "includes[23]":"upcoming_schedule",
    "includes[24]":"delivery_dates",
    "includes[25]":"division",
    "includes[26]":"contacts.phones",
    "includes[27]":"follow_up_status.mentions",
    "includes[28]":"flags.color",
    "includes[29]":"reps",
    "includes[30]":"count",
    "includes[31]":"custom_fields.options.sub_options",
    "includes[32]":"delivery_dates.material_list.srs_order",
    "includes[33]":"customer",
    "includes[34]":"job_workflow",
    'includes[35]': 'custom_fields.users',
    if(LDService.hasFeatureEnabled(LDFlagKeyConstants.jobCanvaser))
    'includes[36]': 'canvasser',
    "track_job":"1",
    "id": id
  };

  ////////////////////////////    LAUNCH MAP    ////////////////////////////////
  void launchMapCallback() {
    LocationHelper.openMapBottomSheet(query: jobModel!.addressString!);
  }

  ////////////////////////////////   FETCH JOB   ///////////////////////////////
  Future<void> fetchJob({int? id}) async {
    try {
      await JobRepository.fetchJob(id!, params: getQueryParams(id))
        .then((Map<String, dynamic> response) {
        jobModel = response["job"];
      });
      if(jobModel?.isContactSameAsCustomer?? false){
        await fetchCustomerMeta();
      } else {
        await fetchJobMeta();
      }
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> fetchJobMeta() async {
    Map<String, dynamic> queryParams = {
      "type[0]": "phone_consents",
      "job_ids[]" : jobModel?.id
    };

    try {
      Map<String, dynamic> response = await JobRepository.fetchMetaList(queryParams);
      List<JobModel> jobs = response["list"];
      JobModel? metaData = jobs.isNotEmpty ? jobs.first : null;
      
      for (var metaIndex = 0; metaIndex < (metaData?.phoneConsents?.length ?? 0); metaIndex++) {
        for (var index = 0; index < (jobModel?.contactPerson?.length ?? 0); index++) {
          for (PhoneModel phoneData in jobModel?.contactPerson?[index].phones ?? []) {
            if (phoneData.number == metaData?.phoneConsents?[metaIndex].phoneNumber) {
              phoneData.consentStatus = metaData?.phoneConsents?[metaIndex].status;
              phoneData.consentCreatedAt = metaData?.phoneConsents?[metaIndex].createdAt;
              phoneData.consentEmail = metaData?.phoneConsents?[metaIndex].email;
            }
          }
        }
      }
     
      update();
    }catch (e) {
      rethrow;
    }
  }

  Future<void> fetchCustomerMeta() async {
    Map<String, dynamic> queryParams = {
      "type[0]": "phone_consents",
      "customer_ids[]" : jobModel?.customerId
    };

    try {
      Map<String, dynamic> metaListApiResponse = await CustomerListingRepository().fetchMetaList(queryParams);
      List<CustomerModel> metaDataList = metaListApiResponse["list"];
      CustomerModel? firstMetaData = metaDataList.isNotEmpty ? metaDataList.first : null;
    
      if (firstMetaData != null) {
        for (var metaIndex = 0; metaIndex < (firstMetaData.phoneConsents?.length ?? 0); metaIndex++) {
          for (var index = 0; index < (jobModel?.contactPerson?.length ?? 0); index++) {
            for (PhoneModel phoneData in jobModel?.contactPerson?[index].phones ?? []) {
              if (phoneData.number == firstMetaData.phoneConsents?[metaIndex].phoneNumber) {
                phoneData.consentStatus = firstMetaData.phoneConsents?[metaIndex].status;
                phoneData.consentCreatedAt = firstMetaData.phoneConsents?[metaIndex].createdAt;
                phoneData.consentEmail = firstMetaData.phoneConsents?[metaIndex].email;
              }
            }
          }
        }  
      }
      update();
    } catch (e) {
      rethrow;
    }
  }

  
 Future<void> fetchSchedule() async {
    Map<String, dynamic> params ={
      'job_id':  Get.arguments[NavigationParams.jobId]
    };
    try {
      showJPLoader(
        msg: 'fetching_schedule'.tr
      );
      await ScheduleRepository().fetchScheduleList(params)
        .then((Map<String, dynamic> response) {
          schedule = response["list"][0];
      });
    } catch (e) {
      rethrow;
    } finally {
      Get.back();
    }
  }
  ///////////////////////////  MATERIAL DELIVERY DATE ///////////////////////////

  void handleMaterialDeliveryDateActions(int index, String type) {

    switch (type) {
      case 'remove':
        showConfirmationToRemoveDeliveryDate(index);
        break;

      case 'add':
        showSetViewDeliveryDateDialog();
        break;

      case 'update':
        showSetViewDeliveryDateDialog(index: index);
        break;
    }

  }

  void handleMaterialPOActions(int jobId, String materialPO) => showJPBottomSheet(child:(_) => UpdateMaterialPODialog(jobId:jobId,materialPO:materialPO,updateMaterialPOCallback: updateMaterialPO,), ignoreSafeArea: false, isScrollControlled: true);
  
  Future<void> handleJobCompletionDateActions(int jobId, String? jobCompletionDate) async {
    DateTime? completionDate;
    DateTime? apiCompletionDate;

    if (jobCompletionDate != null) {
      completionDate = await DateTimeHelper.openDatePicker(initialDate: jobCompletionDate);
      if (completionDate == null) return;
      apiCompletionDate = completionDate.subtract(const Duration(days: 1));
    }

    try {
      showJPLoader();
      
      bool result = await JobRepository.jobCompletionDateAction(jobId.toString(), apiCompletionDate?.toString() ?? "");
      
      if(result) {
        jobModel!.completionDate = DateTimeHelper.formatDate(completionDate.toString(), DateFormatConstants.dateOnlyFormat);
        update();
      }
    } catch(e) {
      rethrow;
    } finally {
      Get.back();
    }
  }

  Future<void> handleJobContractActions(int jobId, String? jobContractDate) async {
    String serveFormatDate = "";
    DateTime? contractDate;

    if (jobContractDate != null) {
      contractDate = await DateTimeHelper.openDatePicker(initialDate: jobContractDate);
      if (contractDate == null) return;
      serveFormatDate = DateTimeHelper.formatDate(contractDate.toString(), DateFormatConstants.dateServerFormat);
    }

    try {
      showJPLoader();
      
      bool result = await JobRepository.contractSignedDateAction(jobId.toString(), serveFormatDate);
      
      if(result == true) {
        jobModel!.contractSignedDate = DateTimeHelper.formatDate(contractDate.toString(), DateFormatConstants.dateOnlyFormat);
        update();
      }
    } catch(e) {
      rethrow;
    } finally {
      Get.back();
    }
  }
  
  void handleDurationActions(int jobId, String duration) {
    showJPBottomSheet(
      child:(_) => DurationDialogBody(
        jobId:jobId,
        duration:duration,
        updateDurationCallback: updateDuration,), 
      ignoreSafeArea: false,
      isScrollControlled: true);}
  /// update job name
  void handleEditJobNameActions(int jobId, String currentValue) {
    FocusNode updateDialogFocusNode = FocusNode();
     showJPGeneralDialog(
        child: (controller){
          return JPQuickEditDialog(
            type: JPQuickEditDialogType.inputBox,
            title: 'update_job_name'.tr.toUpperCase(),
            label:  'job_name'.tr,
            suffixIcon: showJPConfirmationLoader(show: controller.isLoading),
            disableButton: controller.isLoading,
            fillValue: currentValue.trim(),
            autofocus: true,
            onSuffixTap: (value) async {
              controller.toggleIsLoading();
              await updateJobName(jobId , value);
              controller.toggleIsLoading();
            },
            focusNode: updateDialogFocusNode,
            suffixTitle: controller.isLoading ? '' : 'update'.tr.toUpperCase(),
            maxLength: 50,
          );
        });
  }
  
  /// API call to update job name
  Future<void> updateJobName(int jobId ,String value) async {
    try {
      Map<String,dynamic> params = {
        'name' : value,
        'includes[0]': 'custom_fields',
      };

      JobModel updatedJobModel = await JobRepository.updateJobFields(params, jobId.toString());
      jobModel!.name = updatedJobModel.name;
      update();
    } catch(e){
      rethrow;
    } finally{
      Get.back();
    }
  }

  /// Updates the job's division and synchronizes local model with server changes
  /// This method handles the core division update operation while maintaining data consistency
  ///
  /// Business Logic:
  /// - Division updates affect both the job's assignment and potentially its workflow
  /// - Local model must be synchronized with server changes for UI consistency
  /// - User feedback is provided for both success and failure scenarios
  ///
  /// [division] - The new division to assign to the job
  Future<void> updateJobDivision(JPSingleSelectModel division) async {
    try {
      // Show progress indicator as division updates may take time
      showJPLoader(msg: "updating_job_division".tr);

      // Prepare API parameters for division update
      Map<String,dynamic> params = {
        'division_id' : division.id,
        'stage' : updatedStageCode,
      };

      // Update division on server
      await JobRepository.updateJobFields(params, jobModel!.id.toString());
      
      // Synchronize local job model with server changes
      // This ensures UI components display the updated division information
      jobModel?.division ??= DivisionModel();
      jobModel?.division?.id = int.tryParse(division.id);
      jobModel?.division?.name = division.label;
      jobModel?.division?.code = division.additionalData;
      
      // Refresh UI to reflect division changes
      update();
      
      // Provide success feedback to user
      Helper.showToastMessage('job_division_updated_successfully'.tr);
      Get.back();

      await handleStageUpdate();
    } catch(e){
      Get.back();
      // Handle errors gracefully with user-friendly messaging
      Helper.showToastMessage('failed_to_update_job_division'.tr);
      rethrow;
    }
  }

  Future<void> showSetViewDeliveryDateDialog({int? index}) async {

    DeliveryDateModel? deliveryDate;
    bool updateDeliveryDate = index != null;

    if(updateDeliveryDate) {
      deliveryDate = jobModel?.deliveryDates?[index];
    } else {
      await loadMaterialList();
    }

    showJPBottomSheet(
      child: (_) => SetViewDeliveryDateDialog(
        fileParams: FilesListingQuickActionParams(
            fileList: updateDeliveryDate ? [
              deliveryDate?.materialsList ?? FilesListingModel(
                deliveryDateModel: deliveryDate,
                jobId: jobModel?.id,
              )
            ] : [],
            jobModel: jobModel!,
            onActionComplete: (result, action) {
              if(updateDeliveryDate) {
                jobModel?.deliveryDates?[index] = result.deliveryDateModel!;
              } else {
                jobModel?.deliveryDates?.add(result.deliveryDateModel!);
              }
              update();
            }
        ),
        action: updateDeliveryDate ? FLQuickActions.viewDeliveryDate : FLQuickActions.setDeliveryDate,
        materialList: materialList,
      ),
      ignoreSafeArea: false,
      isScrollControlled: true,
      enableInsets: true,
    );
  }

  Future<void> showConfirmationToRemoveDeliveryDate(int index) async {

    DeliveryDateModel? deliveryDate = jobModel?.deliveryDates?[index];

    if(deliveryDate == null) return;

    if(deliveryDate.materialsList == null) {
      await removeDeliveryDate(deliveryDate.id!, showLoader: true).then((value) {
        jobModel?.deliveryDates?.removeAt(index);
      });
      return;
    }

    showJPBottomSheet(
        child: (loader) => JPConfirmationDialog(
            title: 'confirmation'.tr,
            icon: Icons.warning_amber,
            subTitle: '${'remove_delivery_date_desc'.tr} ${deliveryDate.materialsList!.name}. ${'press_confirm_to_proceed'.tr.capitalizeFirst!}',
            suffixBtnIcon: showJPConfirmationLoader(
              show: loader.isLoading
            ),
            suffixBtnText: loader.isLoading ? '' : 'confirm'.tr.toUpperCase(),
            onTapSuffix: () async {
              loader.toggleIsLoading();
              await removeDeliveryDate(deliveryDate.id!).then((value) {
                jobModel?.deliveryDates?.removeAt(index);
              });
              loader.toggleIsLoading();
            },
        ),
    );
  }

  Future<void> removeDeliveryDate(int id, {bool showLoader = false}) async {

    try {

      if(showLoader) showJPLoader();

      Map<String, dynamic> params = {
        'jobId' : jobModel?.id.toString(),
        'materialId' : id.toString()
      };

      await MaterialListsRepository.deleteDeliveryDate(params);

      Helper.showToastMessage('delivery_date_removed'.tr);
    } catch (e) {
      rethrow;
    } finally {
      Get.back();
      update();
    }

  }

  Future<void> loadMaterialList() async {

    try {

      showJPLoader();

      Map<String, dynamic> params = {
        'exclude_abc_material': 1,
        'job_id': jobModel?.id,
        'limit': 0,
        'without_delivery_date': 1,
      };

      final response = await MaterialListsRepository.fetchMaterialList(params);
      materialList = response;

    } catch (e) {
      rethrow;
    } finally {
      Get.back();
    }
  }

  /////////////////////////  ON TAP ADDITIONAL FLAGS  //////////////////////////

  void onTapAdditionalFlags(String pageType) async{
    switch(pageType) {
      case "email_recurring":
        Get.toNamed(Routes.jobRecurringEmail, arguments: {
          NavigationParams.jobId: jobModel?.id,
          NavigationParams.customerId: jobModel?.customerId
        });
        break;
      case "job_scheduled":
        if(jobModel!.scheduleCount! > 1){
          Get.toNamed(
            Routes.calendar, arguments: {'type' : CalendarType.production, 'job_id': jobModel!.id}, 
            preventDuplicates: false
          );
        } else {
          await fetchSchedule();
          Get.toNamed(Routes.scheduleDetail, arguments: {'id' :schedule!.id,});
        }
        break;
      case "progress_board":
        openProgressBoardBottomSheet();
        break;
    }
  }

  void openProgressBoardBottomSheet() {
    AddToProgressBoardHelper.inProgressBoard(
      jobModel: jobModel ?? JobModel(id: 0, customerId: 0),
      index: 0,
      onCallback: ({JobModel? job, int? currentIndex, JobQuickActionCallbackType? callbackType}) {
        jobModel?.productionBoards = job?.productionBoards;
        update();
      },
    );
  }

  void openCustomerCallDialog() {
    if (jobModel == null) return;

    final List<CustomerInfo> customerInfo = [];
    jobModel!.customer?.phones?.forEach((element) {
      customerInfo.add(CustomerInfo(label: element.label.toString().capitalize!, phone: element));
    });
    showJPGeneralDialog(
      isDismissible: false,
      child: (_) {
        return JPCallDialog(
          jobModel: jobModel!,
          customerInfo: customerInfo,
        );
      }
    );
  }

  void openDescriptionDialog() {
    JobService.openDescDialog(job: jobModel, updateScreen: update);
  }

  /// Opens a dialog for editing the work crew associated with the job
  void openWorkCrewDialog() async {
      // Get the list of user IDs for the work crew, or an empty list if jobModel or workCrew is null
      List<String> crewUsersIds = jobModel?.workCrew?.map((user) => user.id.toString()).toList() ?? [];
      // Get the list of user IDs for the subcontractors, or an empty list if jobModel or subContractors is null
      List<String> contractorsUsersIds = jobModel?.subContractors?.map((user) => user.id.toString()).toList() ?? [];

      // Get the company crew list using the user IDs of the work crew
      final companyCrewList = await FormsDBHelper.getAllUsers(
        crewUsersIds,
        withSubContractorPrime: false ,
        divisionIds: [jobModel?.division?.id]);

      // Get the subcontractors users using the user IDs of the subcontractors
      final contractorsUsers = await FormsDBHelper.getAllUsers(
        contractorsUsersIds, 
        useCompanyName: true,
        onlySub: true,
        isSubTextVisible: false,
        divisionIds: [jobModel?.division?.id]);
        
      // Get the tag list
      final tagList = await FormsDBHelper.getAllTags();
  
      // Show the general dialog
      showJPGeneralDialog(
        isDismissible: false,
        child: (dialogController) {
          return AbsorbPointer(
            absorbing: dialogController.isLoading,
            child: AddEditWorkCrewDialogBox(
              jobModel: jobModel!,
              tagList: tagList,
              companyCrewList: companyCrewList,
              subcontractorList: contractorsUsers,
              dialogController: dialogController,
              onFinish: (workCrewRepository) {
                // Fetch the job with the current jobModel ID
                fetchJob(id: jobModel?.id);
                update();
              },
            ),
          );
        }
      ); 
    }

    void setupJobCategoryDetails() {
      initialInsuranceDetailsJson = jobModel?.insuranceDetails?.toJson();
      if(jobModel?.jobTypes?.isNotEmpty ?? false) {
        selectedCategoryId = jobModel?.jobTypes?.first?.id.toString() ?? '';
        showInsuranceClaim = jobModel?.jobTypes?.first?.isInsuranceClaim ?? false;
      } else {
        selectedCategoryId = "";
        showInsuranceClaim = false;
      }
      categoryController.text = !Helper.isValueNullOrEmpty(jobModel?.jobTypesString)? jobModel!.jobTypesString! : 'none'.tr.capitalize!;
    }

    /// Opens a dialog for editing the work crew associated with the job
  void openCategoryDialog() async {
    setupJobCategoryDetails();
    showJPGeneralDialog(
      isDismissible: false,
      child: (dialogController) {
        return AbsorbPointer(
          absorbing: dialogController.isLoading,
          child: JobCategoryEditDialog(
            dialogController: dialogController,
            showInsuranceClaim: showInsuranceClaim,
            textController: categoryController,
            onTap: () => selectCategory(dialogController),
            onTapInsuranceClaim: selectInsuranceClaim,
            onCancel: () {
              setupJobCategoryDetails();
              Get.back();
            },
            onSave: () async {
              dialogController.toggleIsLoading();
              await updateCategory(jobModel!.id, selectedCategoryId);
              dialogController.toggleIsLoading();
            }
          )
        );
      }
    ); 
  }

  void selectInsuranceClaim() async {
    final insuranceDetails = await Get.toNamed(
      Routes.insuranceDetailsForm,
      preventDuplicates: false,
      arguments: {
        NavigationParams.insuranceDetails: jobModel?.insuranceDetails,
      },
    );
    if (insuranceDetails != null && insuranceDetails is InsuranceModel) {
      
      jobModel?.insuranceDetails = insuranceDetails;
    } 
  }

  /// [getCategories] loads categories from server
  Future<List<JPSingleSelectModel>> getCategories() async {
    List<JPSingleSelectModel> categoryList = [];
    try {
      final response = await JobTypeRepository.fetchCategories({});
      List<JobTypeModel> tempCategories = response['list'];

      categoryList.insert(0,
        JPSingleSelectModel(
          label: 'none'.tr, 
          id: '', 
          additionalData: false
        )
      );
      // local parsing as no global use of categories
      for (JobTypeModel category in tempCategories) {
        categoryList.add(
          JPSingleSelectModel(
            label: category.name ?? '',
            id: category.id.toString(),
            additionalData: category.isInsuranceClaim ?? false
          )
        );
      }
      return categoryList;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateCategory(int jobId ,String value) async {
    bool isInsuranceDetailsChanged = initialInsuranceDetailsJson.toString() != jobModel?.insuranceDetails?.toJson().toString();
    try {
      Map<String,dynamic> params = {
        'includes[]': 'insurance_details',
        'job_types' : value,
        if(showInsuranceClaim && isInsuranceDetailsChanged)...{
          'insurance_details': jobModel?.insuranceDetails?.toJson(),
        },
        'insurance' : showInsuranceClaim ? 1 : 0, 
      };
      if (Helper.isValueNullOrEmpty(jobModel?.insuranceDetails?.dateOfLoss)) {
        params['insurance_details']?.remove('date_of_loss');
      }
      if(Helper.isValueNullOrEmpty(jobModel?.insuranceDetails?.claimFiledDate)) {
        params['insurance_details']?.remove('claim_filed_date');
      }
      if(Helper.isValueNullOrEmpty(jobModel?.insuranceDetails?.contingencyContractSignedDate)) {
        params['insurance_details']?.remove('contingency_contract_signed_date');  
      }

      await JobRepository.updateCategory(params, jobId.toString());
      await fetchJob(id: jobId);
      update();
    } catch(e){
      rethrow;
    } finally{
      Get.back();
    }
  }

  void selectCategory(JPBottomSheetController dialogController) async {
    List<JPSingleSelectModel> categories = await getCategories();
    FormValueSelectorService.openSingleSelect(
      title: 'select'.tr + " " + 'category'.tr,
      list: categories,
      selectedItemId: selectedCategoryId,
      controller: categoryController,
      onValueSelected: (val) {
        selectedCategoryId = val;
        final selectedItem = FormValueSelectorService.getSelectedSingleSelect(categories, val);
        showInsuranceClaim = selectedItem.additionalData;
        dialogController.update();
      },
    );  
  }

  ///////////////////////////   UI MANAGEMENT   ////////////////////////////////

  bool spaceBtwContactPersonNdDescriptionTile() => (
      (jobModel?.description?.isNotEmpty ?? false)
      || (jobModel?.leadNumber?.isNotEmpty ?? false)
      || (jobModel?.ghostJob?.isNotEmpty ?? false)
      || (jobModel?.name?.isNotEmpty ?? false) || (jobModel?.tradesString.isNotEmpty ?? false)
      || (jobModel?.duration?.isNotEmpty ?? false)
      || (jobModel?.amount?.isNotEmpty ?? false));

  bool spaceBtwDescriptionNdCustomerAddressTile() => (
      (jobModel?.addressString?.isNotEmpty ?? false)
      || (jobModel?.currentStage?.name.isNotEmpty ?? false)
      || (jobModel?.reps?.isNotEmpty ?? false)
      || (jobModel?.jobWorkflow?.stageLastModified?.isNotEmpty ?? false)
      || (jobModel?.workCrew?.isNotEmpty ?? false));

  bool spaceBtwCustomerAddressNdJobContractTile() =>  (
      (jobModel?.contractSignedDate?.isNotEmpty ?? false)
      || (jobModel?.completionDate?.isNotEmpty ?? false)
      || (jobModel?.deliveryDates?.isNotEmpty ?? false)
      || (jobModel?.stageLastModified?.isNotEmpty ?? false));

  void refreshPage() {
    jobModel = null;
    isLoading = true;
    update();
    fetchJob(id: Get.arguments[NavigationParams.jobId]);
  }

  void updateMaterialPO(String? purchaseOrderNumber) {
    jobModel?.purchaseOrderNumber = purchaseOrderNumber;
    update();
  }

  void updateDuration(String? duration) {
    jobModel?.duration = duration;
    update();
  }

  void navigateToAddScreen(){
    if (jobModel?.isProject ?? false) {
      Get.toNamed(Routes.projectForm, arguments: {
        NavigationParams.type: JobFormType.add,
        NavigationParams.jobModel: jobModel,
        NavigationParams.parentFormType: ParentFormType.individual
      });
    } else {
      Get.toNamed(Routes.jobForm, arguments: {
        NavigationParams.type: JobFormType.add,
        NavigationParams.jobModel: jobModel,
      });
    }
  }

  void navigateToEditScreen(){
    if (jobModel?.isProject ?? false) {
      Get.toNamed(Routes.projectForm, arguments: {
        NavigationParams.type: JobFormType.edit,
        NavigationParams.jobModel: jobModel,
        NavigationParams.parentFormType: ParentFormType.individual
      });
    } else {
      Get.toNamed(Routes.jobForm, arguments: {
        NavigationParams.type: JobFormType.edit,
        NavigationParams.jobModel: jobModel
      });
    }
  }

  void navigateToEditCustomerScreen() {
    Get.toNamed(Routes.customerForm, arguments: {
      NavigationParams.customerId: jobModel?.customerId,
    })?.then((value) {
      if (value != null) {
        refreshPage();
      }
    });
  }



  /// Opens the division selection dialog and handles the complete division change process
  /// This method presents available divisions to the user and orchestrates the complex
  /// workflow of updating both the job division and associated workflow stages
  ///
  /// Business Logic:
  /// - Users can change a job's division from the job details screen
  /// - Division changes may impact available workflow stages
  /// - The process includes validation, user confirmation, and workflow updates
  /// - Only actual division changes trigger the workflow update process
  /// 
  Future<void> openJobDivisionDialog() async {
    // Validate job model exists before attempting to show division options
    if (jobModel == null) {
      Helper.showToastMessage('job_data_not_available'.tr);
      return;
    }

    try {
      // Fetch all available divisions for the user
      // includeNone: true allows users to unassign division if needed
      List<JPSingleSelectModel> jobDivisionList = await FormsDBHelper.getAllDivisions(forUser: false, includeNone: true);
      
      // Validate that divisions are available for selection
      if (jobDivisionList.isEmpty) {
        Helper.showToastMessage('no_divisions_available'.tr);
        return;
      }

      // Present division selection interface
      FormValueSelectorService.openSingleSelect(
          title: 'job_division'.tr,
          list: jobDivisionList,
          // Pre-select current division if one exists
          selectedItemId: (jobModel?.division?.id ?? "").toString(),
          onValueSelected: (val) async {
            // Small delay to ensure UI transition completion
            await Future<void>.delayed(const Duration(milliseconds: 200));
            
            // Get the selected division object with full details
            JPSingleSelectModel selectedDivision = FormValueSelectorService.getSelectedSingleSelect(jobDivisionList, val);
            
            // Check if the division has actually changed
            // Only process changes to avoid unnecessary workflow updates
            bool isDivisionChanged = (jobModel?.division?.id).toString() != selectedDivision.id;
            
            if (isDivisionChanged) {
              // Execute the complete division change process:
              // 1. Confirm workflow impacts and get user approval (if feature flag enabled)
              // 2. Handle workflow stage updates if needed (if feature flag enabled)
              // 3. Update the job division on server and local model
              if (LDService.hasFeatureEnabled(LDFlagKeyConstants.divisionBasedMultiWorkflows)) {
                await confirmAndSetUpdatedStage(val).then((result) {
                  if (result) updateJobDivision(selectedDivision);
                });
              }
            }
          });
    } catch (e) {
      // Handle division loading errors gracefully
      Helper.showToastMessage('failed_to_load_divisions'.tr);
    }
  }

  /// Orchestrates the complete workflow stage update process when job division changes
  /// This method manages the complex multi-step process of updating workflow stages
  /// to align with the new division's requirements
  ///
  /// Business Logic:
  /// - Division changes can affect available workflow stages for a job
  /// - Users must confirm they understand the workflow implications
  /// - If confirmed, users select the appropriate stage from the new division's workflow
  /// - The workflow update is processed with proper task and automation handling
  ///
  /// [divisionId] - The ID of the new division being assigned to the job
  /// Returns true if workflow stage was successfully updated, false otherwise
  Future<bool> confirmAndSetUpdatedStage(String divisionId) async {
    // Feature flag check: only proceed with workflow updates if feature is enabled
    if (!LDService.hasFeatureEnabled(LDFlagKeyConstants.divisionBasedMultiWorkflows)) {
      return true;
    }

    // Validate job model exists before attempting workflow updates
    if (Helper.isValueNullOrEmpty(jobModel)) return true;
    
    try {
      updatedStageCode = null;
      
      // Step 1: Get user confirmation about potential workflow impacts
      // This ensures users understand that division changes may affect workflow stages
      bool doUpdateDivisionAndWorkFlow = await WorkFlowStagesService.divisionImpactWorkflowConfirmation();
      
      // Step 2: If user confirmed, proceed with workflow stage selection
      if (doUpdateDivisionAndWorkFlow) {
        // Initialize workflow controller with new division context
        // This sets up the stage selection UI with division-specific workflow stages
        await WorkFlowStagesService.setUpController(jobId: jobModel?.id ?? -1, divisionId: divisionId);
        
        // Present stage selection interface to user
        // User must choose which stage the job should be in under the new division
        updatedStageCode = await WorkFlowStagesService.showStageSwitcher(jobId: jobModel?.id);
      }
      // Return success status based on whether a valid stage was selected
      return !Helper.isValueNullOrEmpty(updatedStageCode);
    } catch (e) {
      // Handle workflow update errors gracefully
      Helper.showToastMessage('failed_to_update_workflow_stage'.tr);
      return false;
    }
  }

  Future<void> handleStageUpdate() async {
    // Step 3: If user selected a stage, apply the workflow update
    if (!Helper.isValueNullOrEmpty(updatedStageCode)) {
      // Process the stage update with proper task completion and automation
      await WorkFlowStagesService.handleStageUpdate(jobId: jobModel?.id);
      updatedStageCode = null;
    }
  }

}