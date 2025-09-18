import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/services/clock_in_clock_out.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/scaffold/index.dart';
import 'package:jobprogress/modules/clock_in_clock_out/controller.dart';
import 'package:jobprogress/modules/clock_in_clock_out/widgets/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class ClockInClockOutView extends StatelessWidget {
  const ClockInClockOutView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ClockInClockOutController>(
      init: ClockInClockOutService.controller,
      initState: (state) {
        ClockInClockOutService.controller?.onInit();
      },
      builder: (controller) => GestureDetector(
        onTap: Helper.hideKeyboard,
        child: JPScaffold(
          backgroundColor: JPAppTheme.themeColors.base,
          appBar: JPHeader(
            title: controller.forClockOut ? 'clock_out'.tr : 'clock_in'.tr,
            onBackPressed: controller.clearData,
          ),
          body: ClockInClockOutContent(
            controller: controller,
          ),
        ),
      ),
    );
  }
}
