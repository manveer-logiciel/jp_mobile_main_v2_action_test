import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:jobprogress/core/constants/launchdarkly/flag_keys.dart';
import 'package:jobprogress/global_widgets/from_launch_darkly/index.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

import '../../../global_widgets/custom_material_card/index.dart';
import '../../../global_widgets/loader/index.dart';
import '../controller.dart';
import 'language_settings.dart';

class DeviceSettings extends StatelessWidget {
  const DeviceSettings({super.key, required this.controller});

  final SettingController controller;

  @override
  Widget build(BuildContext context) {
    return CustomMaterialCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///   device_name
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  runSpacing: 5,
                  children: [
                    const SizedBox(width: double.infinity), 
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        
                        JPText(
                          text: "device_name".tr,
                          textSize: JPTextSize.heading4,
                          fontWeight: JPFontWeight.medium,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: JPText(
                            text: controller.deviceInfo?.deviceModel ?? "",
                            textSize: JPTextSize.heading5,
                            textColor: JPAppTheme.themeColors.tertiary,
                          ),
                        ),
                      ],
                    ),
                    controller.isPrimaryDeviceUpdating
                      ? showLoader()
                      : JPTextButton(
                          text: controller.isPrimaryDevice
                            ? "primary_device".tr.toUpperCase()
                            : "set_as_primary_device".tr.toUpperCase(),
                          isExpanded: false,
                          textSize: JPTextSize.heading5,
                          fontWeight: JPFontWeight.medium,
                          icon: controller.isPrimaryDevice ? Icons.check : null,
                          iconPosition: JPPosition.start,
                          color: controller.isPrimaryDevice ? JPAppTheme.themeColors.text : JPAppTheme.themeColors.primary,
                          padding: 4,
                          onPressed: controller.isPrimaryDevice ? null : () => controller.setAsPrimaryDevice(),
                        ),
                  ],
                ),
                
              ],
            ),
          ),
          divider(true),
          ///   location_permission
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    JPText(
                      text: "location_permission".tr,
                      textSize: JPTextSize.heading4,
                      fontWeight: JPFontWeight.medium,
                    ),
                    controller.isLocationUpdating
                      ? showLoader()
                      : JPTextButton(
                      text: controller.permission == LocationPermission.always
                          ? "allowed".tr.toUpperCase()
                          : "denied".tr.toUpperCase(),
                      isExpanded: false,
                      textSize: JPTextSize.heading5,
                      fontWeight: JPFontWeight.medium,
                      color: JPAppTheme.themeColors.primary,
                      padding: 4,
                      onPressed: () => controller.updateLocationPermission(controller.permission == LocationPermission.always),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: JPText(
                    text: 'location_permission_description'.tr,
                    textSize: JPTextSize.heading5,
                    textColor: JPAppTheme.themeColors.tertiary,
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
          ),
          divider(true),
          ///  timezone
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.start,
              runSpacing: 2,
              children: [
                const SizedBox(width: double.infinity),
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: JPText(
                    text: "timezone".tr,
                    textSize: JPTextSize.heading4,
                    fontWeight: JPFontWeight.medium,
                  ),
                ),
                controller.isTimezoneUpdating
                    ? showLoader()
                    : JPTextButton(
                  text: controller.selectedTimeZone?.label ?? "",
                  isExpanded: false,
                  textSize: JPTextSize.heading5,
                  fontWeight: JPFontWeight.medium,
                  color: JPAppTheme.themeColors.primary,
                  padding: 4,
                  icon: Icons.keyboard_arrow_down,
                  // iconSize: 18,
                  onPressed: () => controller.showTimezonePicker(),
                )
              ],
            ),
          ),

          FromLaunchDarkly(
              flagKey: LDFlagKeyConstants.allowMultipleLanguages,
              child: (_) => Column(
                children: [
                  divider(true),
                  /// Language Settings
                  LanguageSettings(controller: controller)
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
      width: 70,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: JPAppTheme.themeColors.dimGray,
        borderRadius: BorderRadius.circular(20),
      ),
      child: showJPConfirmationLoader(show: true) ?? const SizedBox.shrink());
}
