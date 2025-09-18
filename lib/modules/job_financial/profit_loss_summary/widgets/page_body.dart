import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/permission.dart';
import 'package:jobprogress/core/constants/permission.dart';
import '../controller.dart';
import 'summary_card.dart';

class ProfitLossSummaryViewBody extends StatelessWidget {

  final JobProfitLossSummaryController controller;

  const ProfitLossSummaryViewBody({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            ///   Financials
            ProfitLossSummaryAmountTile(
              isTileVisible: controller.financialsSummary.isNotEmpty,
              title: "financials_summary".tr,
              list:  controller.financialsSummary,
            ),
            ///   Projected
            ProfitLossSummaryAmountTile(
              isTileVisible: controller.projectSummary.isNotEmpty,
              title: "projected".tr,
              list:  controller.projectSummary,
            ),
            ///   Actual
            if(PermissionService.hasUserPermissions([PermissionConstants.viewUnitCost]))
              ProfitLossSummaryAmountTile(
                isTileVisible: controller.actualSummary.isNotEmpty,
                title: "actual".tr,
                list:  controller.actualSummary,
              ),
          ],
        ),
      ),
    );
  }
}
