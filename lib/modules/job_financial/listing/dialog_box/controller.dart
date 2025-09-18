import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/job_financial/financial_listing.dart';
import 'package:jobprogress/common/repositories/job_financial.dart';
import 'package:jobprogress/core/constants/financial_quick_actions.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jp_mobile_flutter_ui/DatePicker/index.dart';


class PayCommissionDialogController extends GetxController {
  
  PayCommissionDialogController({this.model});

  bool isLoading = false;
  bool isValidate = false;
  
  String? selectedDate = DateTime.now().toString().substring(0,10);
  String? amount;

  TextEditingController dateController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  FinancialListingModel? model;

  @override
  void onInit() {
    dateController.text = DateTimeHelper.convertHyphenIntoSlash(DateTime.now().toString().substring(0,10));
    amountController.text =JobFinancialHelper.getRoundOff(double.parse(model!.dueAmount!)) ;
    super.onInit();
  }
  
  @override
  void onClose() {
    amountController.dispose();
    super.onClose();
  }

  void pickDate() async {
    DateTime firstDate = DateTime.now();
    DateTime? dateTime = await Get.dialog(
      JPDatePicker(
        initialDate: selectedDate == null ? firstDate : DateTime.parse(selectedDate!),
      ),
    );
    if(dateTime != null) {
      String dateOnly = dateTime.toString().substring(0,10);
      String formattedDate = DateTimeHelper.convertHyphenIntoSlash(dateOnly);
      dateController.text = formattedDate;
      selectedDate = dateOnly;
      update();   
    }
  }

  String validateAmount(String value, double amount){
    if(value.isEmpty || double.parse(value) == 0) {
      return 'enter_valid_amount'.tr;
    }
    if(double.parse(value) > amount){
      return 'amount_cannot_ more_than_commission'.tr;
    } 
    return '';
  }

  String getDueAmount(String dueAmount, String amount){
    double tempDueAmount = double.parse(dueAmount);
    double tempAmount = double.parse(amount);
    return (tempDueAmount - tempAmount).toString();
  }
  void onSave(void Function(FinancialListingModel model, String action) onApply) async {
    if(formKey.currentState!.validate()) {
      formKey.currentState!.save();
      model!.dueAmount = getDueAmount(model!.dueAmount!, amount!); 
      isLoading = true;
      update();
      try {
        final payCommissionParams = <String, dynamic> {
          'commission_id': model!.id,
          'amount': amount,
          'paid_on': selectedDate,
          'include[0]': 'commission',
      };
        await JobFinancialRepository().payCommission(payCommissionParams: payCommissionParams);
        onApply(model!, FinancialQuickAction.payCommission); 
        Helper.showToastMessage('${'commission'.tr} ${'paid'.tr.toLowerCase()}');
        Get.back();
      } catch (e) {
        rethrow;
      } finally {
        isLoading = false;
        update();   
      }   
    }
  }
}