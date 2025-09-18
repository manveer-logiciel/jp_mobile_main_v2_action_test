import 'package:flutter/material.dart';
import 'package:jobprogress/common/models/files_listing/files_listing_model.dart';
import 'package:jobprogress/global_widgets/network_image/index.dart';
import 'package:jobprogress/global_widgets/profile_image_widget/index.dart';
import 'package:jobprogress/modules/files_listing/controller.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class CompanyCamListingTile extends StatelessWidget {

  CompanyCamListingTile({
    required this.data,
    this.onTap,
    super.key,
  });

  final FilesListingModel data;
  final VoidCallback? onTap;
  final controller = FilesListingController();

  @override
  Widget build(BuildContext context) {
    return Container(
     decoration: BoxDecoration(
        color: (data.isSelected ?? false)
        ? JPAppTheme.themeColors.lightBlue
        : null,
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            const SizedBox(
              height: 14,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 16,
                ),
                JPAvatar(
                  size: JPAvatarSize.large,
                  child: JPNetworkImage(
                    src: (data.featureImage != null &&
                            data.featureImage!.isNotEmpty)
                        ? data.featureImage![2].url
                        : '',
                    boxFit: BoxFit.fill,
                    placeHolder:
                        Image.asset('assets/images/companycam-dummy.png'),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  JPText(
                                    text: data.name ?? '',
                                    fontWeight: JPFontWeight.medium,
                                    textSize: JPTextSize.heading4,
                                    textAlign: TextAlign.start,
                                    maxLine: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (data.addressString != null &&
                                      data.addressString!.isNotEmpty)
                                    Column(
                                      children: [
                                        const SizedBox(
                                          height: 7,
                                        ),
                                        JPText(
                                          text: data.addressString!,
                                          textSize: JPTextSize.heading5,
                                          textAlign: TextAlign.start,
                                          textColor:
                                              JPAppTheme.themeColors.tertiary,
                                          overflow: TextOverflow.clip,
                                        ),
                                      ],
                                    ),
                                  Column(
                                    children: [
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          JPProfileImage(
                                            initial:
                                                data.creatorName![0].toString(),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          JPText(
                                            text: data.creatorName ?? '',
                                            overflow: TextOverflow.ellipsis,
                                            textSize: JPTextSize.heading5,
                                            textColor:
                                                JPAppTheme.themeColors.tertiary,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: JPAppTheme.themeColors.dimGray,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
