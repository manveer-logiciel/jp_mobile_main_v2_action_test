import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/task_listing/task_listing.dart';
import 'package:jp_mobile_flutter_ui/IconButton/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class TaskTemplateListTile extends StatelessWidget {
  final TaskListModel data;
  final VoidCallback? onTap;
  final VoidCallback? onViewPressed;
  final int index;

  const TaskTemplateListTile({
    super.key, 
    required this.data, 
    this.onTap, 
    this.onViewPressed, 
    required this.index, 
  });

  @override
  Widget build(BuildContext context) {
    return 
    InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: JPAppTheme.themeColors.lightBlue.withValues(alpha: 0.8)),
              child: Center(
                child: JPText(
                    textColor: JPAppTheme.themeColors.primary,
                    text: (index + 1).toString(),
                ),
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 5 ,bottom: 7),
                decoration: BoxDecoration(border:Border(bottom: BorderSide(width: 1, color:JPAppTheme.themeColors.dimGray, style: BorderStyle.solid))),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: JPText(
                                  text: data.title.capitalize!,
                                  fontWeight: JPFontWeight.medium,
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if(data.attachments?.isNotEmpty ?? false)
                                const Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: JPIcon(Icons.attachment_outlined),
                                )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: JPText(
                              text: data.notes ?? '',
                              textAlign: TextAlign.left,
                              textColor: JPAppTheme.themeColors.tertiary,
                              textSize: JPTextSize.heading5,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10,),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                      child: JPIconButton(
                        backgroundColor: JPColor.transparent,
                        onTap: onViewPressed,
                        icon: Icons.remove_red_eye_outlined,
                        iconSize: 24,
                        iconColor: JPAppTheme.themeColors.tertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
