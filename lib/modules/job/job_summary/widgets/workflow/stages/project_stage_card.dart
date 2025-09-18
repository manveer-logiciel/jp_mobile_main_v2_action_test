import 'package:flutter/material.dart';
import 'package:jobprogress/common/models/workflow/project_stages.dart';
import 'package:jobprogress/core/constants/permission.dart';
import 'package:jobprogress/global_widgets/has_permission/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../card_painter.dart';

class JobOverViewWorkFlowProjectStageCard extends StatelessWidget {

  const JobOverViewWorkFlowProjectStageCard({
    super.key,
    required this.stage,
    this.isCurrentStage = false,
    this.isCompleted = false,
    this.onTapMove,
    this.hideMoveButton = false,
    this.stageWidth = 70
  });

  /// stage stores data of particular stage
  final ProjectStageModel stage;

  /// isCurrentStage checks if stage is current stage, default value is [false]
  final bool isCurrentStage;

  /// isCompleted is used to display completed status
  final bool isCompleted;

  /// onTapMove handle tap on move
  final VoidCallback? onTapMove;

  /// hideMoveButton is used to hide move button
  final bool hideMoveButton;

  /// [stageWidth] helps in flexibly displaying long stage names
  final double stageWidth;

  double get internalPadding => 24;

  double get actualStageWidth => stageWidth + internalPadding;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        /// painter card
        SizedBox(
          height: 60,
          width: actualStageWidth,
          child: CustomPaint(
            painter: WorkFlowStageCardPainter(
                cardColor(),
                isActive(),
                style: PaintingStyle.stroke
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
              child: Center(
                child: JPText(
                  text: stage.name ?? '',
                  textColor: JPAppTheme.themeColors.tertiary,
                  textSize: JPTextSize.heading5,
                  fontWeight: JPFontWeight.medium,
                  maxLine: 2,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 12,
        ),

        SizedBox(
          width: (actualStageWidth + 20),
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

              actions(),

            ],
          ),
        )
      ],
    );
  }

  bool isActive() {
    return isCurrentStage || isCompleted;
  }

  Color cardColor() {
    return JPAppTheme.themeColors.tertiary;
  }

  // actions will be displayed only when user has [PermissionConstants.enableWorkFlow]
  Widget actions() {
    return HasPermission(
      permissions: const[PermissionConstants.enableWorkFlow],
      forSubcontractor: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          const SizedBox(
            height: 2,
          ),

          /// move icon
          if(isCurrentStage && !hideMoveButton)
            HasPermission(
              permissions: const [PermissionConstants.manageFullJobWorkFlow],
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
