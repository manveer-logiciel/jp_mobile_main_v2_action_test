import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/file_listing.dart';
import 'package:jobprogress/common/models/workflow_stage.dart';
import 'package:jobprogress/core/constants/work_flow_stage_color.dart';
import 'package:jobprogress/routes/pages.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../core/constants/permission.dart';
import '../../../global_widgets/has_permission/index.dart';

class WorkFlowStageTile extends StatelessWidget {
  final WorkFlowStageModel stage;
  final VoidCallback onTileTap;
  
  const WorkFlowStageTile({
    required this.stage,
    required this.onTileTap,
    super.key
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16),
      child: Card(
        elevation: 4,
        shadowColor: JPAppTheme.themeColors.inverse,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6)
        ),
        margin: const EdgeInsets.only(bottom: 10),
        child: InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: onTileTap,
          child: ClipPath(
            clipper: ShapeBorderClipper(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6)
              )
            ),
            child: Container(
              foregroundDecoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: WorkFlowStageConstants.colors[stage.color]!,
                    width: 6
                  )
                )
              ),
              padding: const EdgeInsets.fromLTRB(22, 16, 15, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        JPText(
                          text: stage.name,
                          textSize: JPTextSize.heading3,
                          fontWeight: JPFontWeight.medium
                        ),

                        HasPermission(
                          permissions: const [PermissionConstants.viewResourceViewer, PermissionConstants.manageResourceViewer],
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  JPButton(
                                    type: JPButtonType.outline,
                                    size: JPButtonSize.extraSmall,
                                    onPressed: () {
                                      Get.toNamed(
                                          Routes.filesListing,
                                          arguments: {
                                            'type': FLModule.stageResources,
                                            'selectedStageCode': stage.code
                                          }, preventDuplicates: false);
                                    },
                                    fontFamily: JPFontFamily.montserrat,
                                    text: "resources".tr.toUpperCase(),
                                  ),
                                  const SizedBox(width: 5,),
                                  JPButton(
                                    type: JPButtonType.outline,
                                    fontFamily: JPFontFamily.montserrat,
                                    size: JPButtonSize.extraSmall,
                                    onPressed: () {
                                      Get.toNamed(
                                          Routes.filesListing,
                                          arguments: {
                                            'type': FLModule.stageResources,
                                            'selectedTabForStageResources': 'goal',
                                            'selectedStageCode': stage.code
                                          },
                                          preventDuplicates: false
                                      );
                                    },
                                    text: "goal".tr.toUpperCase(),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  JPText(
                    text: stage.jobsCount.toString(),
                    fontFamily: JPFontFamily.montserrat,
                    textColor: WorkFlowStageConstants.colors[stage.color],
                    textSize: JPTextSize.heading1,
                    fontWeight: JPFontWeight.medium,
                  )
                ],
              ),
            ),
          ),
        ),
      )
    );
  }
}