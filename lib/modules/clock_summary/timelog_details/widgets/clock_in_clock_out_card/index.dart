
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/network_image/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class ClockInClockOutCard extends StatelessWidget {
  const ClockInClockOutCard({
    super.key,
    required this.title,
    this.image,
    required this.time,
    required this.date,
    this.note,
    this.isPlatformMobile = false,
    this.address,
  });

  final String title;

  final String? image;

  final String time;

  final String date;

  final String? note;

  final bool? isPlatformMobile;

  final String? address;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          /// title and platform icon
          Row(
            children: [
              JPText(
                text: title.toUpperCase(),
                fontWeight: JPFontWeight.medium,
                textSize: JPTextSize.heading4,
              ),
              const Spacer(),
              Container(
                height: 24,
                width: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: JPAppTheme.themeColors.dimGray
                ),
                child: JPIcon(
                  !isPlatformMobile!
                      ? Icons.personal_video_outlined
                      : Icons.stay_current_portrait_outlined,
                  size: 14,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          /// check in / check out image
          Row(
            children: [
              JPAvatar(
                size: JPAvatarSize.size_72x72,
                child: JPNetworkImage(
                  src: image ?? "",
                  boxFit: BoxFit.cover,
                  placeHolder: Image.asset(
                    'assets/images/profile-placeholder.png'
                  ),
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
                        JPText(
                          text: time,
                          fontWeight: JPFontWeight.medium,
                          textSize: JPTextSize.heading2,
                          textColor: JPAppTheme.themeColors.primary,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        JPText(
                          text: '($date)',
                          textSize: JPTextSize.heading4,
                          textColor: JPAppTheme.themeColors.darkGray,
                        ),
                      ],
                    ),
                    if(address != null)...{
                      const SizedBox(height: 6,),
                      JPText(
                        text: address ?? "",
                        textColor: JPAppTheme.themeColors.tertiary,
                        textAlign: TextAlign.start,
                        height: 1.2,
                      ),
                    }
                  ],
                ),
              ),
            ],
          ),
          /// note
          if(note != null)...{
            const SizedBox(
              height: 16,
            ),
            JPText(
              text: 'note'.tr,
              fontWeight: JPFontWeight.medium,
              textSize: JPTextSize.heading4,
            ),
            const SizedBox(
              height: 6,
            ),
            JPReadMoreText(
                note ?? "",
              textAlign: TextAlign.start,
              textColor: JPAppTheme.themeColors.tertiary,
              textSize: JPTextSize.heading4,
              trimLines: 5,
              dialogTitle: 'note'.tr.toUpperCase(),
            ),
          },

          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
