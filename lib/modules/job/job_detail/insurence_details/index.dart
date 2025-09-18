import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/label_value.dart';
import 'package:jobprogress/global_widgets/no_data_found/index.dart';
import 'package:jobprogress/global_widgets/scaffold/index.dart';
import 'package:jobprogress/global_widgets/single_child_scroll_view.dart/index.dart';
import 'package:jobprogress/modules/job/job_detail/insurence_details/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class InsuranceDetails extends StatelessWidget {

  const InsuranceDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InsuranceDetailController>(
      global: false,
      init: InsuranceDetailController(),
      builder: (InsuranceDetailController controller) {
        final List<LabelValueModel> insuranceDataList = controller.insuranceDetailList;
        return JPScaffold(
          backgroundColor: JPAppTheme.themeColors.inverse,
          appBar: JPHeader(
            backgroundColor: JPAppTheme.themeColors.inverse,
            backIconColor: JPAppTheme.themeColors.text,
            title: controller.jobModel?.customer?.fullName ?? "",
            centerTitle: true,
            titleColor: JPAppTheme.themeColors.text,
            onBackPressed: () => Get.back(),
          ),
          scaffoldKey: controller.scaffoldKey,
          body:insuranceDataList.isNotEmpty ? Column(
            children: [
              JPSingleChildScrollView(
                item: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: JPColor.white,
                  ),
                  padding: const EdgeInsets.all(16),
                  child:Column(
                    children: [
                      for (int i=0; i< insuranceDataList.length; i++)...{
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              JPText( 
                                text: insuranceDataList[i].label,
                                textSize: JPTextSize.heading4,
                                textAlign: TextAlign.start,
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              JPText(
                                text: insuranceDataList[i].value,
                                textSize: JPTextSize.heading4,
                                textColor: JPAppTheme.themeColors.darkGray,
                                textAlign: TextAlign.start,
                              ),
                              Divider(
                                height:i != insuranceDataList.length-1 ? 20 : 0, 
                                color: i != insuranceDataList.length-1 ? JPAppTheme.themeColors.dimGray: JPAppTheme.themeColors.base,
                              ),
                            ],
                          ),
                        ),
                      }
                    ],
                  )
                 
                )
                 
              ),
            ],
          ):
          NoDataFound(
            icon:  Icons.assignment_outlined,
            title: 'no_detail_found'.tr.capitalize,)
        );
      }
    );
  }
}