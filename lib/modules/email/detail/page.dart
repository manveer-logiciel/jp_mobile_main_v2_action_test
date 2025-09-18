import 'package:flutter/material.dart';
import 'package:jobprogress/common/extensions/get_navigation/extension.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/no_data_found/index.dart';
import 'package:jobprogress/global_widgets/replace_job_id_with_company_setting/job_name_with_company_setting.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jobprogress/global_widgets/scaffold/index.dart';
import 'package:jobprogress/modules/email/detail/controller.dart';
import 'package:jobprogress/modules/email/detail/shimmer.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import 'email_tile.dart';

class EmailDetailView extends StatelessWidget {
  const EmailDetailView({
    super.key,
    this.argEmailId,
    this.argAvatarColor,
    this.handleOnEmailSent,
    this.onControllerChange, 
    this.selectedLabelId,
  });

  final int? argEmailId;

  final int? selectedLabelId;

  final Color? argAvatarColor;

  final Function(int)? handleOnEmailSent;

  final Function(EmailDetailController?)? onControllerChange;


  @override
  Widget build(BuildContext context) {
    return GetBuilder<EmailDetailController>(
        global: false,
        init: EmailDetailController(
          argEmailId: argEmailId,
          handleOnEmailSent: handleOnEmailSent,
          argAvatarColor: argAvatarColor,
          selectedLabelId: selectedLabelId
        ),
        didChangeDependencies: (state) {
          onControllerChange?.call(state.controller);
        },
        builder: (EmailDetailController controller) {
          return JPScaffold(
              scaffoldKey: controller.scaffoldKey,
              backgroundColor: JPAppTheme.themeColors.inverse,
              appBar: !JPScreen.isDesktop
                  ? JPHeader(
                      backIconColor: JPAppTheme.themeColors.text,
                      backgroundColor: JPAppTheme.themeColors.inverse,
                      elevation: 0,
                      onBackPressed: Get.splitPop,
                      actions: [
                        Visibility(
                          visible: controller.showMoveButton,
                          child: JPTextButton(
                            iconSize: 24,
                            icon: Icons.sync_alt_outlined,
                            onPressed: controller.openMoveToEmail,
                          ),
                        ),
                        JPTextButton(
                          iconSize: 24,
                          icon: Icons.delete_outline,
                          onPressed: controller.showConfirmationForDeleteEmail,
                        ),
                        JPTextButton(
                          iconSize: 24,
                          icon: Icons.print_outlined,
                          onPressed: controller.printEmail,
                        ),
                        const SizedBox(width: 16),
                      ],
                    )
                  : null,
              body: JPSafeArea(
                top: !JPScreen.isDesktop,
                child: controller.isLoading
                    ? const EmailDetailShimmer()
                    : Helper.isValueNullOrEmpty(controller.emailDetail)?
                    NoDataFound(
                      icon: Icons.warning_amber,
                      title: 'something_went_wrong'.tr.capitalize,
                    ):
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 16, left: 16, right: 16, bottom: 7),
                          child: Row(
                            children: [
                              Expanded(
                                child: JPText(
                                  textAlign: TextAlign.left,
                                  text: controller.emailDetail[0].subject
                                      .toString(),
                                  textSize: JPTextSize.heading3,
                                  fontWeight: JPFontWeight.medium,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if(!Helper.isValueNullOrEmpty(controller.emailDetail[0].customer) && 
                            !Helper.isInvalidValue(controller.emailDetail[0].jobs) && 
                            controller.emailDetail[0].jobs!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 15),
                            child: JobNameWithCompanySetting(
                              job: controller.emailDetail[0].jobs![0],
                              textColor: JPAppTheme.themeColors.darkGray,
                              textDecoration: TextDecoration.underline,
                              isClickable: true,
                            ),
                          ),
                        Expanded(
                          child: SingleChildScrollView(
                            padding: EdgeInsets.only(
                              left: JPScreen.isDesktop ? 16 : 0,
                              right: JPScreen.isDesktop ? 16 : 0,
                              bottom: JPResponsiveDesign.floatingButtonSize,
                            ),
                            child: EmailMessageTile(
                              controller: controller,
                            ),
                          ),
                        ),
                      ],
                    ),
              ),
          );
        });
  }
}
