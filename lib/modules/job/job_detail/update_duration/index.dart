import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/modules/job/job_detail/update_duration/widget/duration_dialog.dart';
import 'package:jp_mobile_flutter_ui/CommonFiles/color.dart';
import '../../../../global_widgets/safearea/safearea.dart';
import 'controller.dart';

class DurationDialogBody extends StatelessWidget {
  final int jobId;
  final String duration;
  final Function(String?)? updateDurationCallback;
  const DurationDialogBody({super.key,required this.jobId,required this.duration,this.updateDurationCallback});

  @override
  Widget build(BuildContext context) {
    return JPSafeArea(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: GetBuilder<UpdateDurationController>(
          init: UpdateDurationController(duration),
          global: false,
          builder: (UpdateDurationController controller) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: JPColor.white,
            ),
            padding: const EdgeInsets.all(16),
            child: DurationDialog(jobId: jobId,controller: controller,updateDurationCallback: updateDurationCallback,),
          ),
        ),
      ),
    );
  }
}
