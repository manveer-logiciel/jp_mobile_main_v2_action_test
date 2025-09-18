import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../global_widgets/custom_material_card/index.dart';
import '../../../global_widgets/loader/index.dart';
import '../controller.dart';

class PhotoGallerySettings extends StatelessWidget {
  const PhotoGallerySettings({super.key, required this.controller});

  final SettingController controller;

  @override
  Widget build(BuildContext context) {
    return CustomMaterialCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        JPText(
                          text: "save_photos_to_gallery".tr,
                          textSize: JPTextSize.heading4,
                          fontWeight: JPFontWeight.medium,
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.only(top: 5),
                          child: JPText(
                            text: "save_photos_to_gallery_description".tr,
                            textSize: JPTextSize.heading5,
                            textColor: JPAppTheme.themeColors.tertiary,
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                controller.savePhotosToggle == null
                  ? showLoader()
                  : JPToggle(
                    value: controller.savePhotosToggle!,
                    onToggle: (val) =>
                        controller.updateSavePhotosToggle(val))
              ],
            ),
          ),
          divider(true),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            JPText(
                              text: "nereby_jobs_access".tr,
                              textSize: JPTextSize.heading4,
                              fontWeight: JPFontWeight.medium,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: JPText(
                                text: "nereby_jobs_access_description".tr,
                                textSize: JPTextSize.heading5,
                                textColor: JPAppTheme.themeColors.tertiary,
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    controller.nearByJobToggle == null
                      ? showLoader()
                      : JPToggle(
                        value: controller.nearByJobToggle!,
                        onToggle: (val) => controller.updateNearByJobToggle(val))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: JPText(
                    text: "nereby_jobs_access_note".tr,
                    textSize: JPTextSize.heading5,
                    textColor: JPAppTheme.themeColors.tertiary,
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget divider(bool dividerVisibility) => Visibility(
      visible: dividerVisibility,
      child: Divider(
        height: 1,
        color: JPAppTheme.themeColors.dimGray,
      ));

  Widget showLoader() => Container(
      height: 22,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: JPAppTheme.themeColors.dimGray,
        borderRadius: BorderRadius.circular(20),
      ),
      child: showJPConfirmationLoader(show: true) ?? const SizedBox.shrink());
}
