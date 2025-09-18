import 'package:flutter/material.dart';
import 'package:jobprogress/common/models/attachment.dart';
import 'package:jobprogress/global_widgets/attachments_detail/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class ScheduleDetailAttachments extends StatelessWidget {
  const ScheduleDetailAttachments({
    super.key,
    required this.attachments,
    required this.title,
    this.tapHereText,
    this.onTapCancelIcon,
    this.addCallback,
    this.onSelect,
    this.headerActions,
    this.isEdit = false,
    this.isDisabled = false,
  });

  final String title;
  final List<AttachmentResourceModel> attachments;
  final bool isEdit;
  final bool isDisabled;
  final String? tapHereText;
  final Function(int index)? onTapCancelIcon;
  final Function()? addCallback;
  final Function()? onSelect;
  final List<Widget>? headerActions;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: JPAppTheme.themeColors.base,
      borderRadius: BorderRadius.circular(JPAppTheme.formUiHelper.sectionBorderRadius),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: JPAppTheme.formUiHelper.verticalPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            JPAttachmentDetail(
              titleText: title,
              isEdit: isEdit,
              titleTextColor: JPAppTheme.themeColors.darkGray,
              tapHereText: tapHereText,
              attachments: attachments,
              disabled: isDisabled,
              addCallback: addCallback,
              onTapCancelIcon: onTapCancelIcon,
              headerActions: [
                if(isEdit)...{
                  JPButton(
                    onPressed: () => onSelect!(),
                    disabled: isDisabled,
                    text: "select".toUpperCase(),
                    size: JPButtonSize.extraSmall,
                  )
                },
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget getEditableWidget() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        JPAttachmentDetail(
          titleText: title,
          isEdit: isEdit,
          titleTextColor: JPAppTheme.themeColors.darkGray,
          tapHereText: tapHereText,
          attachments: attachments,
          disabled: isDisabled,
          addCallback: addCallback,
          onTapCancelIcon: onTapCancelIcon,
          headerActions: [
            JPButton(
              onPressed: () => onSelect!(),
              disabled: isDisabled,
              text: "select".toUpperCase(),
              size: JPButtonSize.extraSmall,
            ),
          ],
        )
      ]
  );

  Widget getViewOnlyWidget() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (attachments.isNotEmpty)
        JPAttachmentDetail(
          attachments: attachments,
          titleTextColor: JPAppTheme.themeColors.darkGray,
          titleText: title,
          isEdit: isEdit,
          tapHereText: tapHereText,
          addCallback: addCallback,
          onTapCancelIcon: onTapCancelIcon,
          disabled: isDisabled,
          headerActions: headerActions,
        ),
    ],
  );



}
