import 'package:flutter/cupertino.dart';
import 'package:get/get_utils/src/extensions/export.dart';
import 'package:jobprogress/core/constants/permission.dart';
import 'package:jobprogress/core/utils/job_financial_helper.dart';
import 'package:jobprogress/global_widgets/has_permission/index.dart';
import 'package:jobprogress/modules/job_financial/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class ApporveRejectJobRequestTile extends StatelessWidget{
  const ApporveRejectJobRequestTile({super.key, required this.controller});
  final JobFinancialController controller;
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(left: 16, right: 16,bottom: 20),
      decoration: BoxDecoration(color: JPAppTheme.themeColors.base, borderRadius: BorderRadius.circular(18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          JPText(
          text: controller.job?.isProject ?? false ? 'project_price_update_request'.tr :  'job_price_update_request'.tr.toUpperCase(),
          fontWeight: JPFontWeight.medium,
          textAlign: TextAlign.left,
          ),
          const SizedBox(height: 10,),
          if(!controller.isRequestSubmittedByLoggedInUser())
          JPRichText(
            text: JPTextSpan.getSpan(
              controller.job?.isProject ?? false ? '${'you_have_a_new_project_price_update_request_from'.tr} ${controller.jobPriceRequestedUpdate!.requestedBy!.fullName} ${'for'.tr} ' : 
                '${'you_have_a_new_job_price_update_request_from'.tr} ${controller.jobPriceRequestedUpdate!.requestedBy!.fullName} ${'for'.tr} ',
              textColor: JPAppTheme.themeColors.tertiary,
              height: 1.6,
              children: [
                JPTextSpan.getSpan(
                  controller.jobPriceRequestedUpdate!.taxable == 0 ?
                  JobFinancialHelper.getCurrencyFormattedValue(
                    value:controller.jobPriceRequestedUpdate!.amount
                  ):
                  '${JobFinancialHelper.getCurrencyFormattedValue(value:controller.jobPriceRequestedUpdate!.amount)} + ${JobFinancialHelper.getCurrencyFormattedValue(
                  value: controller.financialDataModel.updatRequestedestimateTax)}(Tax) = ${
                  JobFinancialHelper.getCurrencyFormattedValue(
                  value: controller.financialDataModel.updateRequestedJobPrice)}',
                  textColor: JPAppTheme.themeColors.primary
                )
              ]
            ),
          ),
          if(controller.isRequestSubmittedByLoggedInUser())
          JPRichText(
            text: JPTextSpan.getSpan(
              '${'you_have_submitted_a_job_price_update_request_for'.tr} ',
              textColor: JPAppTheme.themeColors.tertiary,
              height: 1.6,
              children: [
                JPTextSpan.getSpan(
                controller.jobPriceRequestedUpdate!.taxable == 0 ?
                  JobFinancialHelper.getCurrencyFormattedValue(
                    value:controller.jobPriceRequestedUpdate!.amount
                  ):
                  '${JobFinancialHelper.getCurrencyFormattedValue(value:controller.jobPriceRequestedUpdate!.amount)} + ${JobFinancialHelper.getCurrencyFormattedValue(
                  value: controller.financialDataModel.updatRequestedestimateTax)}(Tax) = ${
                  JobFinancialHelper.getCurrencyFormattedValue(
                  value: controller.financialDataModel.updateRequestedJobPrice)}',
                  textColor: JPAppTheme.themeColors.primary
                  ),
                JPTextSpan.getSpan(' ${'and_its_approval_is_awaited'.tr}', textColor: JPAppTheme.themeColors.tertiary)
              ]
            ),
          ),
          const SizedBox(height: 15,),
          HasPermission(
            permissions: const [PermissionConstants.approveJobPriceRequest],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children:[
                JPButton(
                  onPressed: (){
                    controller.updateJobPrice(false);
                  },
                  size: JPButtonSize.extraSmall,
                  colorType: JPButtonColorType.tertiary,
                  text: 'reject'.tr.toUpperCase(),
                ),
                const SizedBox(width: 5,),
                JPButton(
                  onPressed: (){
                    controller.updateJobPrice(true);
                  },
                  size: JPButtonSize.extraSmall,
                  text: 'approve'.tr.toUpperCase(),
                ),
              ],
            ),
          )
        ],
      ),
    );  
  }
}
