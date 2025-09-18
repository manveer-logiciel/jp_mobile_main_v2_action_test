import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/popover_action.dart';
import 'package:jobprogress/common/services/schedule_details/actions.dart';
import 'package:jobprogress/core/constants/permission.dart';
import 'package:jobprogress/global_widgets/has_permission/index.dart';
import 'package:jobprogress/global_widgets/main_drawer/index.dart';
import 'package:jobprogress/global_widgets/scaffold/index.dart';
import 'package:jobprogress/global_widgets/will_pop_scope/index.dart';
import 'package:jobprogress/modules/schedule/details/controller.dart';
import 'package:jobprogress/modules/schedule/details/widgets/main_body.dart';
import 'package:jp_mobile_flutter_ui/PopUpMenu/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class ScheduleDetail extends StatelessWidget {

  const ScheduleDetail({
    super.key,
    this.scheduleId,
    this.onScheduleDelete,
  });

  final String? scheduleId;

  final VoidCallback? onScheduleDelete;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ScheduleDetailController>(
        global: false,
        init: ScheduleDetailController(
            scheduleId: scheduleId,
            onScheduleDelete: onScheduleDelete,
        ),
        builder: (controller) {
          return JPWillPopScope(
            onWillPop: controller.onWillPop,
            child: JPScaffold(
                endDrawer: JPMainDrawer(
                  selectedRoute: '',
                ),
                scaffoldKey: controller.scaffoldKey,
                backgroundColor: JPAppTheme.themeColors.inverse,
                appBar: JPHeader(
                  backgroundColor: JPAppTheme.themeColors.inverse,
                  onBackPressed: controller.onWillPop,
                  backIconColor: JPAppTheme.themeColors.text,
                  actions: [
                    /// email button
                    Material(
                       shape: const CircleBorder(),
                       color: JPAppTheme.themeColors.inverse,
                       clipBehavior: Clip.hardEdge,
                       child: IconButton(
                         padding: EdgeInsets.zero,
                         constraints: const BoxConstraints(minHeight: 35, minWidth: 35),
                         icon: JPIcon(
                           Icons.mail_outline,
                           color: JPAppTheme.themeColors.text,
                         ),
                         onPressed: controller.openEmail,
                       ),
                     ),

                    /// more options
                    HasPermission(
                      permissions: const [PermissionConstants.manageJobSchedule],
                      child: Material(
                        shape: const CircleBorder(),
                        color: JPAppTheme.themeColors.inverse,
                        clipBehavior: Clip.hardEdge,
                        child: JPPopUpMenuButton(
                          popUpMenuButtonChild: SizedBox(
                            height: 35,
                            width: 35,
                            child: JPIcon(
                              Icons.more_vert,
                              color: JPAppTheme.themeColors.text,
                            ),
                          ),
                          childPadding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 12),
                          itemList: ScheduleDetailsActions.getActions(),
                          onTap: (PopoverActionModel selected) {
                            controller.handleHeaderActions(selected.value);
                          },
                          popUpMenuChild: (PopoverActionModel val) {
                            return JPText(text: val.label);
                          },
                        ),
                      ),
                    ),

                    /// drawer icon
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: Material(
                        shape: const CircleBorder(),
                        color: JPAppTheme.themeColors.inverse,
                        clipBehavior: Clip.hardEdge,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(minHeight: 35, minWidth: 35),
                          icon: JPIcon(
                            Icons.menu,
                            color: JPAppTheme.themeColors.text,
                          ),
                          onPressed: () {
                            controller.scaffoldKey.currentState!.openEndDrawer();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                body: ScheduleDetailMainBody(
                    controller: controller,
                ),
            ),
          );
        },
    );
  }
}
