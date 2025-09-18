import 'package:flutter/material.dart';
import 'package:jobprogress/common/models/attachment.dart';
import 'package:jobprogress/global_widgets/attachments_detail/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class AppointmentDetailAttachments extends StatelessWidget {
  const AppointmentDetailAttachments({
    required this.attachments,
    super.key});

  final List<AttachmentResourceModel> attachments;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: JPAppTheme.themeColors.base),
      child: Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (attachments.isNotEmpty)
              JPAttachmentDetail(
                attachments: attachments,
                titleTextColor: JPAppTheme.themeColors.darkGray,
              ),
          ],
        ),
      ),
    );
  }
}
