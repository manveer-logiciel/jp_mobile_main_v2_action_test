import 'package:flutter/material.dart';
import 'package:jobprogress/core/constants/work_flow_stage_color.dart';
import 'package:jobprogress/global_widgets/listview/index.dart';
import 'package:jobprogress/modules/home/controller.dart';
import 'package:jobprogress/modules/home/widgets/stage_list_shimmer.dart';
import 'package:jp_mobile_flutter_ui/ToolTip/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../../core/constants/widget_keys.dart';

class HomePageStages extends StatelessWidget {
  const HomePageStages({
    super.key,
    required this.controller
  });

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16),
      padding: const EdgeInsets.all(10),
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: JPAppTheme.themeColors.base.withValues(alpha: 0.3),
      ),
      child: Column(
        children: [
          controller.isStageListLoading
            ? const StageListShimmer()
            : JPListView(
            key: const ValueKey(WidgetKeys.workflowStages),
            scrollDirection: Axis.horizontal,
            listCount: controller.stages.length,
            itemBuilder: (_, index) {
              if(index < controller.stages.length) {
                return Row(
                  children: [
                    JPToolTip(
                       message: controller.stages[index].name,
                            decoration:  BoxDecoration(
                              color: JPAppTheme.themeColors.dimBlack,
                              borderRadius: BorderRadius.circular(8)
                            ),
                      verticalOffset: 17,
                      child: Material(
                        borderRadius: BorderRadius.circular(18),
                        color: WorkFlowStageConstants.colors[controller.stages[index].color],
                        child: InkWell(
                          key: ValueKey('${WidgetKeys.workflowStages}[$index]'),
                          borderRadius: BorderRadius.circular(18),
                          onTap: () {
                            controller.navigateToJobListing(controller.stages[index].code);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            constraints: const BoxConstraints(
                              minHeight: 28,
                              minWidth: 35
                            ),
                            child:Ink(
                              padding: const EdgeInsets.only(left: 6, right: 6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                color: WorkFlowStageConstants.colors[controller.stages[index].color],
                              ),
                              child: JPText(
                                text: controller.stages[index].jobsCount.toString(),
                                textColor: JPAppTheme.themeColors.base,
                              )
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                );
              } else {
                return const SizedBox.shrink();
              }
            }
          ),
        ],
      ),
    );
                          
  }
}