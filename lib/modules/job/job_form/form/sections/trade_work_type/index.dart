import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/company_trades/company_trades_model.dart';
import 'package:jobprogress/common/models/job/job_type.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'controller.dart';
import 'widgets/list.dart';

class JobTradeWorkTypeInputs extends StatefulWidget {
  const JobTradeWorkTypeInputs({
    super.key,
    this.isDisabled = false,
    required this.tradesList,
    required this.workTypesList,
    required this.otherTradeDescriptionController,
    this.hideAddButton = false,
    this.isTradeTypeDisabled = false,
  });

  /// [isDisabled] helps in disabling fields and buttons
  final bool isDisabled;

  /// [tradesList] holds data of selected trades
  final List<CompanyTradesModel> tradesList;

  /// [workTypesList] holds data of selected work types
  final List<JobTypeModel> workTypesList;

  /// [hideAddButton] helps in removing add button
  final bool hideAddButton;

  /// [isTradeTypeDisabled] helps in disabling trade type field
  final bool isTradeTypeDisabled;

  /// [otherTradeDescriptionController] is used to handle other trade description
  final JPInputBoxController otherTradeDescriptionController;

  @override
  State<JobTradeWorkTypeInputs> createState() => JobTradeWorkTypeInputsState();
}

class JobTradeWorkTypeInputsState extends State<JobTradeWorkTypeInputs> {

  late JobTradeWorkTypeInputsController controller;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<JobTradeWorkTypeInputsController>(
      init: JobTradeWorkTypeInputsController(
        tradesList: widget.tradesList,
        workTypesList: widget.workTypesList,
      ),
      didChangeDependencies: (state) {
        controller = state.controller!;
      },
      global: false,
      builder: (controller) {
        return Column(
          children: [
            Form(
              key: controller.formKey,
              child: JobTradeWorkTypeInputsList(
                controller: controller,
                isDisabled: widget.isDisabled,
                hideAddButton: widget.hideAddButton,
              ),
            ),
            if (controller.isAnyTradeWithOtherType()) ... {
              SizedBox(
                height: controller.uiHelper.horizontalPadding,
              ),
              JPInputBox(
                inputBoxController: widget.otherTradeDescriptionController,
                type: JPInputBoxType.withLabel,
                label: 'other_trade_description'.tr,
                disabled: widget.isDisabled,
                fillColor: JPAppTheme.themeColors.base,
              )
            }
          ],
        );
      }
    );
  }

  bool validate({bool scrollOnValidate = true}) {
    return controller.validateForm(scrollOnValidate: scrollOnValidate);
  }

}
