import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/workflow_stage.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/core/constants/permission.dart';
import 'package:jobprogress/core/constants/work_flow_stage_color.dart';
import 'package:jobprogress/global_widgets/has_permission/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../card_painter.dart';

class JobOverViewWorkFlowJobStageCard extends StatelessWidget {

  const JobOverViewWorkFlowJobStageCard({
    super.key,
    required this.stage,
    this.isCurrentStage = false,
    this.doShowMarkAsComplete = false,
    this.doShowReInitiate = false,
    this.stageDate,
    this.onTapMove,
    this.onTapDate,
    this.onTapReInstate,
    this.onTapMarkAsCompleted,
    this.hideMoveButton = false,
    this.stageWidth = 100
  });

  /// stage stores data of particular stage
  final WorkFlowStageModel stage;

  /// isCurrentStage checks if stage is current stage, default value is [false]
  final bool isCurrentStage;

  /// stageDate is used to display stage date
  final String? stageDate;

  /// doShowMarkAsComplete helps in displaying mark as complete button
  final bool doShowMarkAsComplete;

  /// doShowReInitiate helps in displaying reinstate button
  final bool doShowReInitiate;

  /// onTapMove handle tap on move
  final VoidCallback? onTapMove;

  /// onTapDate handles tap on date
  final VoidCallback? onTapDate;

  /// onTapMarkAsCompleted handles tap on Mark As complete
  final VoidCallback? onTapMarkAsCompleted;

  /// onTapReInstate handles tap on Reinstate
  final VoidCallback? onTapReInstate;

  /// hideMoveButton is used to hide move button
  final bool hideMoveButton;

  /// [stageWidth] helps in flexibly displaying long stage names
  final double stageWidth;

  double get internalPadding => 32;

  double get actualStageWidth => stageWidth + internalPadding;

  bool get hideMoveOnAwardedStage => (AuthService.isStandardUser() && (stage.isOrAfterAwardedStage ?? false));

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        /// painter card
        Container(
          constraints:  BoxConstraints(
            minHeight: 70,
            maxWidth: actualStageWidth,
          ),
          child: CustomPaint(
            painter: WorkFlowStageCardPainter(cardColor(), isActive()),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 2, 12, 16),
              child: Center(
                child: JPText(
                  text: stage.name,
                  textColor: isActive() ? JPAppTheme.themeColors.base : JPAppTheme.themeColors.tertiary,
                  textSize: JPTextSize.heading5,
                  fontWeight: JPFontWeight.medium,
                  maxLine: 3,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 12,
        ),

        Container(
          constraints:  BoxConstraints(
            minWidth: (actualStageWidth + 10)
          ),
          child: Column(
            children: [
              /// circle/check icon
              Container(
                height: 14,
                width: 14,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive() && !isCurrentStage ? cardColor() : JPAppTheme.themeColors.base,
                  border: !isActive() || isCurrentStage ? Border.all(
                    color: isCurrentStage ? cardColor() : JPAppTheme.themeColors.dimGray,
                    width: 2
                  ) : null,
                ),
                child: !isCurrentStage  ? JPIcon(
                  Icons.check,
                  size: 12,
                  color: JPAppTheme.themeColors.base,
                ) : null,
              ),

              /// date
              if(stageDate != null)...{
                const SizedBox(
                  height: 10,
                ),

                JPTextButton(
                  text: stageDate!,
                  textSize: JPTextSize.heading5,
                  padding: 2,
                  isExpanded: false,
                  onPressed: isCurrentStage ? null : onTapDate,
                ),
              },

              actions(),

            ],
          ),
        )
      ],
    );
  }

  bool isActive() {
    return stage.completedDate != null || doShowReInitiate;
  }

  Color cardColor() {
    return WorkFlowStageConstants.colors[stage.color]!;
  }

  // actions will be displayed only when user has [PermissionConstants.enableWorkFlow]
  Widget actions() {
    return HasPermission(
      permissions: const [PermissionConstants.enableWorkFlow],
      forSubcontractor: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if(doShowMarkAsComplete)...{
            const SizedBox(
              height: 2,
            ),
            /// mark as complete button
            JPTextButton(
              text: 'mark_as_complete'.tr,
              textSize: JPTextSize.heading5,
              color: JPAppTheme.themeColors.primary,
              padding: 0,
              isExpanded: false,
              paddingInsets: const EdgeInsets.symmetric(
                horizontal: 4,
                vertical: 2
              ),
              onPressed: onTapMarkAsCompleted,
            )
            
          },
          if(doShowReInitiate)...{
            const SizedBox(
              height: 2,
            ),
            /// reinstate button
            JPTextButton(
              text: 'reinstate'.tr,
              textSize: JPTextSize.heading5,
              color: JPAppTheme.themeColors.primary,
              padding: 2,
              onPressed: onTapReInstate,
            ),
          },
          /// move icon
          if(isCurrentStage && !doShowReInitiate && !hideMoveButton)
            HasPermission(
              permissions: const [PermissionConstants.manageFullJobWorkFlow],
              orOtherCondition: !hideMoveOnAwardedStage,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: JPTextButton(
                      icon: Icons.multiple_stop_outlined,
                      onPressed: onTapMove,
                      color: JPAppTheme.themeColors.primary,
                      iconSize: 20,
                      padding: 3,
                    ),
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }

}
