import 'package:flutter/material.dart';
import 'package:jobprogress/common/models/email/email.dart';
import 'package:jobprogress/core/constants/date_formats.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/global_widgets/replace_job_id_with_company_setting/job_name_with_company_setting.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class EmailListTile extends StatelessWidget {
  const EmailListTile({
    super.key,
    required this.email,
    required this.avatarColor,
    required this.showFirstLetterOfEmail,
    required this.showEmailListWithThreeDots,
    required this.onTap,
    required this.onLongPress,
    this.isFirst = false,
    this.isLast = false,
    this.isSelected = false,
  });

  final EmailListingModel email;

  final Color avatarColor;

  final String Function(EmailListingModel email) showFirstLetterOfEmail;

  final String Function(EmailListingModel email) showEmailListWithThreeDots;

  final VoidCallback onTap;

  final VoidCallback onLongPress;

  final bool isFirst;

  final bool isLast;

  final bool isSelected;

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
        borderRadius: getBorderRadius(),
        color: email.checked
            ? JPAppTheme.themeColors.lightBlue.withValues(alpha: 0.8)
            : !email.isRead! || isSelected
            ? JPAppTheme.themeColors.lightBlue.withValues(alpha: 0.4)
            : null,
      ),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: getBorderRadius(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16, bottom: 12, top: isFirst ? 4 : 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: JPAvatar(
                      size: JPAvatarSize.large,
                      backgroundColor: email.checked
                          ? JPAppTheme.themeColors.primary
                          : avatarColor,
                      child: email.checked
                          ? JPIcon(Icons.done,
                          color: JPAppTheme.themeColors.base)
                          : JPText(
                        text: showFirstLetterOfEmail(email),
                        textSize: JPTextSize.heading3,
                        textColor: JPAppTheme.themeColors.base,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 7),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: Row(
                                      children: [
                                        Flexible(
                                          child: JPText(
                                              textAlign: TextAlign.left,
                                              overflow: TextOverflow.ellipsis,
                                              text: email.to!.length > 3
                                                  ? (email.emailToName ?? "")
                                                  : showEmailListWithThreeDots(
                                                  email),
                                              fontWeight: !email.isRead!
                                                  ? JPFontWeight.bold
                                                  : JPFontWeight.medium),
                                        ),
                                        if(email.count != null && email.count != 1)
                                        Padding(
                                          padding: const EdgeInsets.only(left: 5),
                                          child: JPText(
                                            text: email.count.toString(),
                                            textColor: JPAppTheme.themeColors.darkGray,
                                            fontWeight:!email.isRead!
                                              ? JPFontWeight.bold
                                              : JPFontWeight.medium
                                          ),
                                        ),
                                        if (email.attachments!.isNotEmpty)
                                          Container(
                                              margin: const EdgeInsets.only(
                                                  left: 6.5),
                                              child: const JPIcon(
                                                  Icons.attachment_outlined,
                                                  size: 20)),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 15),
                                  child: JPText(
                                    text: DateTime.now()
                                        .difference(DateTime.parse(
                                        email.updatedAt!))
                                        .abs()
                                        .inDays ==
                                        1
                                        ? DateTimeHelper.formatDate(
                                        email.updatedAt.toString(),
                                        DateFormatConstants.dateOnlyFormat)
                                        : DateTimeHelper.formatDate(
                                        email.updatedAt.toString(),
                                        'am_time_ago'),
                                    textSize: JPTextSize.heading5,
                                    fontWeight: !email.isRead!
                                        ? JPFontWeight.medium
                                        : JPFontWeight.regular,
                                    textColor: !email.isRead!
                                        ? JPAppTheme.themeColors.primary
                                        : JPAppTheme.themeColors.secondaryText,
                                  ),
                                )
                              ],
                            ),
                          ),
                          if (email.subject!.isNotEmpty)
                            Padding(
                              padding:
                              const EdgeInsets.only(bottom: 5, right: 22),
                              child: JPText(
                                textAlign: TextAlign.left,
                                text: email.subject!,
                                overflow: TextOverflow.ellipsis,
                                maxLine: 1,
                                textColor: JPAppTheme.themeColors.tertiary,
                                textSize: JPTextSize.heading5,
                                fontWeight: !email.isRead!
                                    ? JPFontWeight.medium
                                    : JPFontWeight.regular,
                              ),
                            ),
                          if (email.htmlContent!.isNotEmpty)
                            Padding(
                              padding:
                              const EdgeInsets.only(bottom: 5, right: 21),
                              child: JPText(
                                  text: email.parseHtmlContent!,
                                  overflow: TextOverflow.ellipsis,
                                  maxLine: 1,
                                  textAlign: TextAlign.left,
                                  textColor: JPAppTheme.themeColors.tertiary,
                                  textSize: JPTextSize.heading5),
                            ),
                          if (email.customer != null && email.jobs!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(right: 21),
                              child: JobNameWithCompanySetting(
                                job: email.jobs![0],
                                textColor: JPAppTheme.themeColors.tertiary,
                                textSize: JPTextSize.heading5,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),


            if(!isLast)
              Divider(
                thickness: 1,
                height: 1,
                color: JPAppTheme.themeColors.dimGray,
                indent: 73,
              ),
          ],
        ),
      ),
    );
  }

  BorderRadius getBorderRadius() {
    switch (JPScreen.type) {

      case DeviceType.mobile:
      case DeviceType.tablet:
       return BorderRadius.only(
         topLeft:
         isFirst ? const Radius.circular(18) : const Radius.circular(0),
         topRight:
         isFirst ? const Radius.circular(18) : const Radius.circular(0),
         bottomLeft:
         isLast ? const Radius.circular(18) : const Radius.circular(0),
         bottomRight:
         isLast ? const Radius.circular(18) : const Radius.circular(0),
       );

      case DeviceType.desktop:
        return BorderRadius.zero;
    }
  }

}
