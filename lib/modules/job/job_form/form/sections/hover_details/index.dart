import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/files_listing/hover/job.dart';
import 'package:jobprogress/common/services/phone_masking.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'tile.dart';

class JobFormHoverDetails extends StatelessWidget {
  const JobFormHoverDetails({
    super.key,
    required this.hoverJob,
    this.isDisable = false,
    this.onTapEdit,
    this.canEdit = true
  });

  /// [hoverJob] holds data of hover job
  final HoverJob hoverJob;

  /// [isDisable] helps in disabling fields
  final bool isDisable;

  /// [onTapEdit] handles tap on edit button
  final VoidCallback? onTapEdit;

  /// [canEdit] helps in deciding whether to display edit button or not
  final bool canEdit;

  String get title => "${'hover_job'.tr} ${(hoverJob.isCaptureRequest ?? false) ? "with_capture_request".tr : ""}";

  @override
  Widget build(BuildContext context) {

    return Material(
      borderRadius: BorderRadius.circular(8),
      color: JPAppTheme.themeColors.inverse.withValues(alpha: 0.3),
      child: Padding(
          padding: const EdgeInsets.all(10),
        child: Column(
          children: [

            ///   Header (title & edit button)
            Row(
              children: [
                Expanded(
                  child: JPText(
                    text: title,
                    textSize: JPTextSize.heading5,
                    textColor: JPAppTheme.themeColors.tertiary,
                    textAlign: TextAlign.start,
                  ),
                ),

                if (canEdit)
                  JPTextButton(
                  text: 'edit'.tr.toUpperCase(),
                  color: JPAppTheme.themeColors.primary,
                  textSize: JPTextSize.heading5,
                  isDisabled: isDisable,
                  onPressed: onTapEdit,
                )
              ],
            ),

            const SizedBox(
              height: 5,
            ),

            ///   Request For
            if (hoverJob.isCaptureRequest ?? false) ...{
              JobFormHoverDetailTile(
                title: 'request_for'.tr,
                data: hoverJob.customerName ?? "-",
              ),
            },

            ///   Hover User
            JobFormHoverDetailTile(
              title: 'hover_user'.tr,
              data: hoverJob.hoverUser?.fullName ?? "-",
            ),

            ///   Hover Deliverable
            JobFormHoverDetailTile(
              title: 'hover_deliverable'.tr,
              data: (hoverJob.deliverableType ?? "-").toString(),
            ),

            ///   Phone & Email
            if (hoverJob.isCaptureRequest ?? false) ...{

              JobFormHoverDetailTile(
                title: 'phone'.tr,
                data: PhoneMasking.maskPhoneNumber(hoverJob.customerPhone ?? ""),
              ),

              JobFormHoverDetailTile(
                title: 'email'.tr,
                data: hoverJob.customerEmail ?? "-",
              ),

            }
          ],
        ),
      ),
    );
  }
}
