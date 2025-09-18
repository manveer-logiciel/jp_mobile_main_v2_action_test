import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/constants/date_formats.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/global_widgets/file_image/file_image.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class ClockInClockOutForm extends StatelessWidget {
  const ClockInClockOutForm(
      {super.key,
      required this.title,
      this.address = '-',
      this.image,
      required this.noteController,
      required this.dateTime,
      this.onTapSelectImage,
      this.onTapTextField,
      });

  /// title used to give title to form
  final String title;

  /// image ued to display image
  final String? image;

  /// address used to display address, default value will be '-'
  final String? address;

  /// noteController used to add note
  final TextEditingController noteController;

  /// dateTime used to display date on form
  final DateTime dateTime;

  /// onTapSelectImage used to handle take image tap
  final VoidCallback? onTapSelectImage;

  /// onTapSelectImage used to handle tap on note field
  final VoidCallback? onTapTextField;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          JPText(
            text: title,
            fontWeight: JPFontWeight.medium,
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            children: [
              GestureDetector(
                onTap: onTapSelectImage,
                child: Column(
                  children: [
                    /// image
                    JPFileImage(
                      path: image ?? "",
                      height: 72,
                      width: 72,
                      borderRadius: 36,
                      boxFit: BoxFit.cover,
                      placeHolder:
                          Image.asset("assets/images/profile-placeholder.png"),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    JPTextButton(
                      text: image == null ? 'take_photo'.tr : 'retake_photo'.tr,
                      textSize: JPTextSize.heading5,
                      color: JPAppTheme.themeColors.primary,
                      padding: 2,
                    )
                  ],
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        /// time
                        JPText(
                          text: "${'today'.tr.capitalizeFirst!} ${DateTimeHelper.formatDate(dateTime.toString(),
                                  DateFormatConstants.timeOnlyFormat)}",
                          textColor: JPAppTheme.themeColors.primary,
                          fontWeight: JPFontWeight.medium,
                          textSize: JPTextSize.heading2,
                        ),
                        const SizedBox(
                          width: 5,
                        ),

                        /// date
                        JPText(
                          text: '($formattedDate)',
                          textColor: JPAppTheme.themeColors.secondaryText,
                          textSize: JPTextSize.heading4,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),

                    /// address
                    JPText(
                      text: address ?? '-',
                      textColor: JPAppTheme.themeColors.tertiary,
                      textSize: JPTextSize.heading4,
                      textAlign: TextAlign.start,
                      height: 1.2,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),

          /// note field
          JPInputBox(
            controller: noteController,
            type: JPInputBoxType.withLabel,
            label: 'note'.tr,
            maxLines: 4,
            onPressed: onTapTextField,
            fillColor: JPAppTheme.themeColors.base,
            maxLength: 500,
          ),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }

  String get formattedDate => DateTimeHelper.convertHyphenIntoSlash(
        DateTimeHelper.formatDate(
            dateTime.toString(), DateFormatConstants.dateServerFormat),
      );

}
