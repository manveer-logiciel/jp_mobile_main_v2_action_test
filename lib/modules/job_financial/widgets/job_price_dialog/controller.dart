import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/extensions/mix_panel/extension.dart';
import 'package:jobprogress/common/services/company_settings.dart';
import 'package:jobprogress/core/constants/company_seetings.dart';
import 'package:jobprogress/core/constants/mix_panel/titles.dart';
import 'package:jobprogress/core/utils/single_select_helper.dart';
import 'package:jp_mobile_flutter_ui/CommonFiles/confirmation_dialog_type.dart';
import 'package:jp_mobile_flutter_ui/ConfirmationDialog/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../../../core/utils/helpers.dart';
import '../../../../common/models/job/job.dart';
import '../../../../common/models/job_financial/job_price_dialog_model.dart';
import '../../../../common/models/job_financial/tax_model.dart';
import '../../../../common/repositories/job.dart';
import '../../../../common/services/quick_book.dart';
import '../../../../core/utils/job_financial_helper.dart';
import '../../../../global_widgets/bottom_sheet/controller.dart';
import '../../../../global_widgets/bottom_sheet/index.dart';

class JobPriceDialogController extends GetxController {

  late JobPriceDialogModel jobPriceModel;
  late JobPriceDialogModel defaultJobPriceModel;
  JobModel? jobModel;

  bool taxStatusRadioGroup = false;
  bool revisedTaxRadioGroup = false;
  bool isLoading = false;
  bool isInfoVisible = false;

  TextEditingController amountController = TextEditingController();
  TextEditingController totalJobPriceController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<TaxModel> taxList = [];
  List<JPSingleSelectModel> singleSelectTaxList = [];

  JobPriceDialogController({this.jobModel}) {
    setDefaultKeys(JobPriceDialogModel(
      jobId : jobModel?.id,
      taxable: jobModel?.taxable ?? 0,
      amount: double.parse(jobModel?.amount?.toString() ?? "0"),
      total: JobFinancialHelper.getTotalPrice(jobModel),
      taxRate: num.tryParse(jobModel?.taxRate?.toString() ?? "0"),
    ),);
  }

  //////////////////////////    FETCH JOB DETAILS   ////////////////////////////

  void fetchJobDetail(JobPriceDialogModel? jobPriceDialogModel) {
    final jobSummaryParams = <String, dynamic> {
      "id": jobPriceDialogModel?.jobId,
      "includes[0]":"address.state_tax",
      "includes[1]":"parent.address.state_tax",
      "includes[2]":"custom_tax",
      "includes[3]":"financial_details",
      "includes[4]":"job_invoices",
      "includes[5]":"flags.color",
    };
    JobRepository.fetchJob(jobPriceDialogModel!.jobId!, params: jobSummaryParams).then((value) {
      jobModel = value["job"];
      update();
      setDefaultKeys(jobPriceDialogModel);
    });
  }

  //////////////////////////    SET DEFAULT VALUES   ///////////////////////////

  void setDefaultKeys(JobPriceDialogModel params) {

    params.taxRate = num.tryParse(jobModel?.taxRate?.toString() ?? "") ?? getTaxRate(jobModel);
    params.isDerivedTax = (jobModel?.financialDetails?.isDerivedTax ?? 0) == 1;
    params.taxAmount = ((params.amount ?? 1) * (params.taxRate ?? 1)) / 100;

    jobPriceModel = JobPriceDialogModel.copy(params);
    defaultJobPriceModel = JobPriceDialogModel.copy(params);

    taxStatusRadioGroup = jobPriceModel.taxable == 1;
    amountController.text = jobPriceModel.amount == 0 ? "" : JobFinancialHelper.getRoundOff(jobPriceModel.amount!).toString();
    totalJobPriceController.text = jobPriceModel.total == 0 ? "" : JobFinancialHelper.getRoundOff(jobPriceModel.total!).toString();
    if(jobModel?.jobInvoices?.isEmpty ?? false) {
      fetchTaxList();
    }
    update();
  }

  ////////////////////////////    FETCH TAX LIST   /////////////////////////////

  void fetchTaxList() {
    Map<String,dynamic> params = {
      "limit":0
    };
    JobRepository.fetchCustomTax(params)
        .then((value) {
      if(value is List<TaxModel>) {
        taxList.addAll(value);
        for (var element in value) {
          singleSelectTaxList.add(JPSingleSelectModel(
            id: element.id.toString(),
            label: "${element.title} - (${element.taxRate} %)",
          ));
        }
      }
    }).catchError((onError) {});
  }

  //////////////////////////    UPDATE TAX STATUS   ////////////////////////////

  void updateRadioValue(bool val) {
    taxStatusRadioGroup = val;
    jobPriceModel.taxable = taxStatusRadioGroup ? 1 : 0;
    onAmountTextChange(amountController.text.trim());
    update();
  }

  ///////////////////////////   AMOUNT CALCULATIONS   //////////////////////////

  void onAmountTextChange(String text) {
    double tempAmount = double.parse(text.isEmpty ? "0" : text);
    jobPriceModel.amount = tempAmount;
    jobPriceModel.taxAmount = (tempAmount * (jobPriceModel.taxRate ?? 1)) / 100;
    jobPriceModel.total = tempAmount + (jobPriceModel.taxAmount ?? 0);
    totalJobPriceController.text = jobPriceModel.total == 0 ? "" : JobFinancialHelper.getRoundOff(jobPriceModel.total!).toString();
    update();
  }

  void onTotalPriceTextChange(String value) {
    double tempAmount = double.parse(value.isEmpty ? "0" : value);
    jobPriceModel.total = tempAmount;
    jobPriceModel.taxAmount = (tempAmount * (jobPriceModel.taxRate ?? 1)) / 100;
    jobPriceModel.amount = tempAmount - (jobPriceModel.taxAmount ?? 0);
    amountController.text = jobPriceModel.amount == 0 ? "" : JobFinancialHelper.getRoundOff(jobPriceModel.amount!).toString();
    update();
  }

  ////////////////////////////    TAX LIST  HANDLING    ////////////////////////

  void openBottomSheet() {
    SingleSelectHelper.openSingleSelect(
        singleSelectTaxList,
        jobPriceModel.customTaxId.toString(),
        "select_tax".tr,
            (value) {
          jobPriceModel.customTaxId = int.tryParse(value);
          jobPriceModel.taxRate = taxList.firstWhereOrNull((element) => element.id == int.tryParse(value))?.taxRate;
          onAmountTextChange(amountController.text.trim());
          Get.back();
        }
    );
  }

  void updateAppliedTax(bool val) {

    if(val) {
      revisedTaxRadioGroup = !revisedTaxRadioGroup;
      jobPriceModel.taxRate = defaultJobPriceModel.taxRate;
      onAmountTextChange(amountController.text.trim());
    } else {
      showJPBottomSheet(
          isDismissible: true,
          child: (JPBottomSheetController controller) {
            return JPConfirmationDialog(
              icon: Icons.info_outline,
              title: "confirmation".tr.toUpperCase(),
              subTitle: "${"apply_revised_tax_conformation".tr} (${JobFinancialHelper.getRoundOff(getTaxRate(jobModel, isRevised: true))} %)?".tr,
              type: JPConfirmationDialogType.message,
              prefixBtnText: "no".tr,
              suffixBtnText: "yes".tr,
              onTapSuffix: () {
                revisedTaxRadioGroup = !revisedTaxRadioGroup;
                jobPriceModel.taxRate = getTaxRate(jobModel, isRevised: true);
                onAmountTextChange(amountController.text.trim());
                Get.back();
              },
            );
          });
    }
  }

  ///////////////////////////    SAVE UPDATED  AMOUNT    ///////////////////////

  void onSave(void Function() onApply) {
    Helper.hideKeyboard();
    if(formKey.currentState!.validate()) {
      formKey.currentState!.save();
      if(compareJobPriceVsInvoicesSum) {
        Helper.showToastMessage("error_toast_new_amount_less_then_old_amount".tr);
      } else if(isTryingToChangeTaxable) {
        showConformationDialog();
      } else {
        updateOnServer(onApply);
      }
      update();
    }
  }

  //////////////////////////   CONFORMATION DIALOGS    /////////////////////////

  void showConformationDialog() {
    showJPBottomSheet(
        isDismissible: true,
        child: (JPBottomSheetController controller) {
          return JPConfirmationDialog(
            icon: Icons.info_outline,
            title: "alert".tr.toUpperCase(),
            subTitle: "error_toast_tax_status_change".tr,
            type: JPConfirmationDialogType.alert,
          );
        });
  }

  ///////////////////////////   HIT API TO UPDATE   ///////////////////////////

  void updateOnServer(void Function() onApply) {
    updateLoader();
    Map<String,dynamic> params = {
      ...jobPriceModel.toJson()..removeWhere((dynamic key, dynamic value) => (key == null || value == null)),
    };
    bool isAllowedToUpdate = Helper.isTrue(CompanySettingsService.getCompanySettingByKey(CompanySettingConstants.enableJobPriceRequestSubmitFeature));
    if(!isAllowedToUpdate) {
      params.removeWhere((key, value) => key == "job_id");
      params['id'] = jobPriceModel.jobId;
    }
    JobRepository.updateJobPrice(params, isAllowedToUpdate)
        .then((value) => value ? onApply() : updateLoader())
        .catchError((onError) => updateLoader()).trackUpdateEvent(MixPanelEventTitle.jobPriceUpdate);
  }

  //////////////////////////////////////////////////////////////////////////////

  void updateInfoVisible () {
    isInfoVisible = !isInfoVisible;
    update();
  }

  void updateLoader () {
    isLoading = !isLoading;
    update();
  }

  bool isRevisedTaxCheckboxVisible() => (jobModel?.jobInvoices?.isEmpty ?? true)
      && taxStatusRadioGroup
      && (jobModel?.taxRate ?? 0) == getTaxRate(jobModel, isRevised: true)
      && (jobModel?.taxRate?.isNotEmpty ?? false) ;

  List<String> getStringList() {
    List<String> strings = [];

    if(jobModel?.jobInvoices?.isEmpty ?? true) {
      strings.add("job_price_updated_from_worksheet_tax_exists_along_with_all_tax".tr);
    } else {
      strings.add("job_price_updated_from_worksheet_tax_exists_along_with_all_tax".tr);
      strings.add("multiple_invoices_having_different_tax_rates".tr);
      strings.add("invoice_having_few_line_items_as_taxable".tr);
    }
    return strings;
  }

  num getTaxRate(JobModel? jobModel, {bool isRevised = false}) {
    if ((QuickBookService.isQuickBookConnected() || QuickBookService.isQBDConnected())) {
      if(jobModel?.customTax?.taxRate != null) {
        return jobModel!.customTax!.taxRate!;
      } else {
        return 0;
      }
    } else {
      if((jobModel?.taxRate?.isNotEmpty ?? false) && !isRevised) {
        return num.parse(jobModel!.taxRate!.toString());
      } else if(jobModel?.customTax?.taxRate != null) {
        return jobModel!.customTax!.taxRate!;
      } else if(jobModel?.parent?.address?.stateTax != null) {
        return jobModel!.parent!.address!.stateTax!;
      } else if(jobModel?.address?.stateTax != null) {
        return jobModel!.address!.stateTax!;
      } else if(CompanySettingsService.getCompanySettingByKey(CompanySettingConstants.taxRate) is bool
          ? false :  CompanySettingsService.getCompanySettingByKey(CompanySettingConstants.taxRate).toString().isNotEmpty) {
        return num.parse(CompanySettingsService.getCompanySettingByKey(CompanySettingConstants.taxRate).toString());
      } else {
        return 0;
      }
    }
  }

  num getTotalInvoiceAmount() {
    num totalJobInvoiceAmount = 0;
    jobModel?.jobInvoices?.forEach((element) => totalJobInvoiceAmount += element.totalAmount ?? 0);
    return totalJobInvoiceAmount;
  }

  bool get compareJobPriceVsInvoicesSum =>
      (jobModel?.jobInvoices?.isNotEmpty ?? false) && (jobPriceModel.total ?? 0) < getTotalInvoiceAmount();

  bool get isTryingToChangeTaxable => (jobModel?.jobInvoices?.isNotEmpty ?? false) && (jobPriceModel.taxable != defaultJobPriceModel.taxable);

  @override
  void onClose() {
    amountController.dispose();
    totalJobPriceController.dispose();
    super.onClose();
  }




}