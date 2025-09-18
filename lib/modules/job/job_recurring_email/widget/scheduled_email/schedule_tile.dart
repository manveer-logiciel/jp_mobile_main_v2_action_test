import 'package:flutter/material.dart';
import 'package:jobprogress/common/models/job/recurring_email_scheduler.dart';
import 'package:jobprogress/modules/job/job_recurring_email/controller.dart';
import 'package:jp_mobile_flutter_ui/ToolTip/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class ScheduledEmailTile extends StatelessWidget {

  const ScheduledEmailTile({
    super.key,
    required this.item,
    required this.controller,
    required this.canceledBy,
    required this.cancelledNote,
    this.historyButton,
    this.doShowRail = true,
  });

  final RecurringEmailSchedulerModel item;

  final JobRecurringEmailController controller;

  final String canceledBy;

  final String cancelledNote;

  final bool doShowRail;

  final Widget? historyButton;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              if (doShowRail)
                VerticalDivider(
                  color: controller.getEmailSchedulerProcessSpreadRadiusColor(item),
                  thickness: 2,
                  width: 12,
                  indent: 18,
                ),
              Transform.translate(
                offset: const Offset(0, -2),
                child: Container(
                  height: 12,
                  width: 12,
                  margin: const EdgeInsets.only(top: 5),
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: controller.getEmailSchedulerProcessSpreadRadiusColor(item), width: 2),
                      shape: BoxShape.circle,
                      color: controller.getEmailSchedulerProcessDotColor(item),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Transform.translate(
              offset: const Offset(0, -2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  JPRichText(
                      text: JPTextSpan.getSpan(
                        controller.getEmailSchedulerTitle(item:item,name: canceledBy) +
                        controller.getEmailSchedulerDate(item: item),
                        textColor:JPAppTheme.themeColors.darkGray,
                        textSize: JPTextSize.heading5,
                        height: 1.55,
                        children:[
                          if(cancelledNote.isNotEmpty && item.status == 'canceled')
                            WidgetSpan(child: Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: JPToolTip(
                                message: cancelledNote,
                                child: JPIcon(
                                  Icons.info,
                                  color: JPAppTheme.themeColors.primary,
                                  size: 14,
                                ),
                              ),
                            )
                            )],
                      ),
                  ),
                  historyButton ?? const SizedBox(),
                  if (doShowRail)
                    const SizedBox(
                      height: 10,
                    )
                ],
              ),
            ),
          )
        ],
      ),
    );


  }
}
