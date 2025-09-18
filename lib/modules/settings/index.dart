import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/background_location/index.dart';
import 'package:jobprogress/global_widgets/custom_material_card/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../global_widgets/scaffold/index.dart';
import 'controller.dart';
import 'widgets/device_settings.dart';
import 'widgets/photo_gallery_settings.dart';

class SettingView extends StatelessWidget {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingController>(
      global: false,
      init: SettingController(),
      dispose: (state) => state.controller?.onDispose(),
      builder: (SettingController controller) => JPScaffold(
        backgroundColor: JPAppTheme.themeColors.inverse,
        appBar: JPHeader(
          title: 'settings'.tr,
          onBackPressed: () => Get.back(result: controller.isSettingUpdated),
        ),
        scaffoldKey: controller.scaffoldKey,
        body: SingleChildScrollView(
          child: Column(children: [
            const SizedBox(height: 8,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: DeviceSettings(controller: controller),
            ),
            ///   save_photos_to_gallery
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: PhotoGallerySettings(controller: controller),
            ),
            ///   enable_dark_theme
            ///   TODO: As of now Dark mode not needed
            /*Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: AppsSettings(controller: controller),
            ),*/
            JPBackgroundLocationListener(
                setUpAddress: true,
                child: (locationController) {
                  if (locationController.doShowLastTracking) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical:8),
                      child: CustomMaterialCard(
                        child: Padding(
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
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          JPText(
                                            text: "user_tracking".tr,
                                            textSize: JPTextSize.heading4,
                                            fontWeight: JPFontWeight.medium,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 5),
                                            child: JPText(
                                              text: "Last location captured on ${locationController.formattedLastTrackedTime}",
                                              textSize: JPTextSize.heading5,
                                              textColor: JPAppTheme.themeColors.tertiary,
                                              textAlign: TextAlign.start,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: JPText(
                                  text: locationController.lastTrackedAddress,
                                  textSize: JPTextSize.heading5,
                                  textColor: JPAppTheme.themeColors.tertiary,
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
            ),
          ]),
        ),
      ));
  }
}
