
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/modules/clock_in_clock_out/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class ClockInClockOutFooter extends StatelessWidget {
  const ClockInClockOutFooter({
    super.key,
    required this.controller
  });

  final ClockInClockOutController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /// clock out & switch job button
          if(controller.forClockOut)...{
            Expanded(
              flex: JPResponsiveDesign.popOverButtonFlex,
              child: JPButton(
                text: controller.updatingCheckOutStatus ? '' : 'clock_out'.tr.toUpperCase(),
                size: JPButtonSize.medium,
                iconWidget: showJPConfirmationLoader(
                    show: controller.updatingCheckOutStatus
                ),
                disabled: controller.updatingCheckOutStatus,
                onPressed: controller.checkOut,
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              flex: JPResponsiveDesign.popOverButtonFlex,
              child: JPButton(
                text: 'switch_job'.tr.toUpperCase(),
                size: JPButtonSize.medium,
                colorType: JPButtonColorType.lightGray,
                onPressed: () => controller.selectJob(doSwitchJob: true),
              ),
            ),
          } else...{
            /// clock-in button
            Expanded(
              flex: JPResponsiveDesign.popOverButtonFlex,
              child: JPButton(
                text: controller.updatingCheckInStatus ? '' : 'clock_in'.tr.toUpperCase(),
                size: JPButtonSize.medium,
                iconWidget: showJPConfirmationLoader(
                    show: controller.updatingCheckInStatus
                ),
                disabled: controller.updatingCheckInStatus,
                onPressed: controller.checkIn,
              ),
            ),
          }
        ],
      ),
    );
  }
}
