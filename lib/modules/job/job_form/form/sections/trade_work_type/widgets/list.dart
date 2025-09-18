import 'package:flutter/material.dart';
import 'package:jobprogress/modules/job/job_form/form/sections/trade_work_type/controller.dart';
import 'package:jobprogress/modules/job/job_form/form/sections/trade_work_type/widgets/tile.dart';

class JobTradeWorkTypeInputsList extends StatelessWidget {
  const JobTradeWorkTypeInputsList({
    required this.controller,
    required this.isDisabled,
    required this.hideAddButton,
    super.key,
  });

  final JobTradeWorkTypeInputsController controller;

  /// [isDisabled] helps in disabling fields and buttons
  final bool isDisabled;

  /// [hideAddButton] helps in removing add button
  final bool hideAddButton;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      primary: false,
      itemBuilder: (_, index) {

        final data = controller.tradeWorkTypeList[index];

        return JobFormTradeWorkTypeTile(
          data: data,
          controller: controller,
          index: index,
          isDisabled: isDisabled,
          hideAddButton: hideAddButton,
          isTradeTypeDisabled: data.isTradeScheduled,
        );
      },
      separatorBuilder: (_, index) {
        return SizedBox(
          height: controller.uiHelper.inputVerticalSeparator,
        );
      },
      itemCount: controller.tradeWorkTypeList.length,
    );
  }
}
