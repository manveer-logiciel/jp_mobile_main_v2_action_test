import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/job/job.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class JobFinancialMainTile extends StatelessWidget {
  const JobFinancialMainTile({
    super.key,
    required this.jobPrice, 
    required this.invoiceAmount, 
    required this.estimatedTax, 
    required this.invoicedTax,
    this.job 
  });

  final String jobPrice;
  final String invoiceAmount;
  final String estimatedTax;
  final String invoicedTax;
  final JobModel? job;

  @override
  Widget build(BuildContext context) {
    return Container( 
      padding: const EdgeInsets.only(top: 20, right: 40, left: 20, bottom: 19),
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
      decoration: BoxDecoration(color: JPAppTheme.themeColors.base, borderRadius: BorderRadius.circular(18)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TitleValueComponent(title: job?.isProject ?? false ? 'project_price'.tr.capitalize! : 'job_price'.tr.capitalize!, value: jobPrice),
                const SizedBox(height: 15),
                TitleValueComponent(title: 'invoiced_amount'.tr, value: invoiceAmount),
              ],
            )
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TitleValueComponent(title: 'estimated_tax'.tr, value: estimatedTax),
                const SizedBox(height: 15),
                TitleValueComponent(title: 'invoiced_tax'.tr, value: invoicedTax,),
              ],
            )
          )
        ],
      )
    );
  }
}

class TitleValueComponent extends StatelessWidget {
  const TitleValueComponent({super.key, required this.title, required this.value,});
 final String title;
 final String value;

 
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:[
        JPText(text: title,textColor: JPAppTheme.themeColors.tertiary,textAlign: TextAlign.left),
        const SizedBox(height: 5),
        JPText(text: value, fontWeight: JPFontWeight.bold, textSize: JPTextSize.heading1,textAlign: TextAlign.left)    
      ],
    );
  }
}
