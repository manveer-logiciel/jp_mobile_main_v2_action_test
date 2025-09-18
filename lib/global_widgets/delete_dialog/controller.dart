import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/extensions/mix_panel/extension.dart';
import 'package:jobprogress/common/repositories/customer.dart';
import 'package:jobprogress/common/repositories/job.dart';
import 'package:jobprogress/common/repositories/job_financial.dart';
import 'package:jobprogress/core/constants/financial_quick_actions.dart';
import 'package:jobprogress/core/constants/mix_panel/titles.dart';
import 'package:jobprogress/core/utils/helpers.dart';

import '../../common/enums/cj_list_type.dart';


class DeleteDialogController extends GetxController  {

  final GlobalKey<FormState> deleteFormKey = GlobalKey<FormState>();
  String? password;
  String? note;
  
  bool isDeleteButtonDisabled = false;
  bool isPasswordVisible = true;

  void updateVisibility() {
    isPasswordVisible = !isPasswordVisible;
    update();
  }

  void delete({dynamic model, String? actionFrom, void Function(dynamic model ,String action)? deleteCallback}) async {
    if(deleteFormKey.currentState?.validate() ?? false) {
      deleteFormKey.currentState!.save();
      isDeleteButtonDisabled = true;
      update();
        switch(actionFrom){
          case 'job_financial':
            try {
              final deleteInvoiceParams = <String, dynamic>{
                'invoice_id': model.id,
                'password': password,
                'reason': note,
              };
              await JobFinancialRepository
                  .removeFinancialInvoice(deleteInvoiceParams)
                  .trackDeleteEvent(MixPanelEventTitle.invoiceDelete);
              deleteCallback!(model, FinancialQuickAction.deleteInvoice); 
              Helper.showToastMessage('invoice_deleted'.tr);
              Get.back();
            } catch (e) {
              rethrow;
            } finally {
              isDeleteButtonDisabled = false;
              update();   
            }
            break;

          case 'job':
            try {
              Map<String, dynamic> queryParams = {
                "id": model.id,
                "note": note,
                "password": password,
              };
              await JobRepository.deleteJob(queryParams).then((response) {
                if(response == null) {
                  return;
                } else {
                  Helper.showToastMessage(model.listType == CJListType.projectJobs ? 'project_deleted'.tr : 'job_deleted'.tr );
                }
              }).trackDeleteEvent(MixPanelEventTitle.jobDelete);
              deleteCallback!(model, '');
            } catch(e) {
              rethrow;
            } finally {
              isDeleteButtonDisabled = false;
              update();
            }
            break;
          
          case 'customer':
            try {
              Map<String, dynamic> queryParams = {
                "id": model.id,
                "note": note,
                "password": password,
              };
              await CustomerRepository.deleteCustomer(queryParams).then((response) {
                if(response == null) {
                  return;
                } else {
                  Helper.showToastMessage('customer_deleted'.tr);
                  deleteCallback!(model, '');
                }
              }).trackDeleteEvent(MixPanelEventTitle.customerDelete);
            } catch(e){
              rethrow;
            } finally{
              isDeleteButtonDisabled = false;
              update();
            }
            break;
        }    
      }      
    }
  }
