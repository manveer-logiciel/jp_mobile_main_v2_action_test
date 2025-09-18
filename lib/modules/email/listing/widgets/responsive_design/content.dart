
import 'package:flutter/material.dart';
import 'package:jobprogress/modules/email/detail/page.dart';
import 'package:jobprogress/modules/email/listing/controller.dart';

class EmailListingContent extends StatelessWidget {
  const EmailListingContent({
    super.key,
    required this.controller
  });

  final EmailListingController controller;

  @override
  Widget build(BuildContext context) {
    return EmailDetailView(
      argEmailId: controller.selectedEmailId,
      argAvatarColor: controller.selectedAvatarColor,
      selectedLabelId: controller.selectedLabel?.id,
      onControllerChange: (updatedController) {
        controller.emailDetailController = updatedController;
      },
      handleOnEmailSent: controller.handleOnEmailSent,
    );
  }
}
