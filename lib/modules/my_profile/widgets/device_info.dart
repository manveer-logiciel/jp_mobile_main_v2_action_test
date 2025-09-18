import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/device_info.dart';
import 'package:jobprogress/core/constants/widget_keys.dart';
import 'package:jobprogress/global_widgets/custom_material_card/index.dart';
import 'package:jobprogress/global_widgets/job_contact_person/contact_tile.dart';
import 'package:jobprogress/modules/customer/detail_screen_body/detail_tile.dart';
import 'package:jp_mobile_flutter_ui/Button/index.dart';
import 'package:jp_mobile_flutter_ui/Button/size.dart';
import 'package:jp_mobile_flutter_ui/CommonFiles/font_weight.dart';
import 'package:jp_mobile_flutter_ui/Text/index.dart';
import 'package:jp_mobile_flutter_ui/Theme/index.dart';

class MyProfileDeviceInfo extends StatelessWidget {
  const MyProfileDeviceInfo({
    required this.deviceInfo,
    this.onTapVersion,
    this.onTapDevConsole,
    this.isDevConsoleVisible = false,
    super.key,
  });

  final DeviceInfo deviceInfo;
  final VoidCallback? onTapVersion;
  final VoidCallback? onTapDevConsole;
  final bool isDevConsoleVisible;

  @override
  Widget build(BuildContext context) {
    return  CustomMaterialCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 20),
            child: JPText(
              key: const ValueKey(WidgetKeys.appAndDeviceInfo),
              text: "app_and_device_info".tr.toUpperCase(),
              textColor: JPAppTheme.themeColors.darkGray,
              fontWeight: JPFontWeight.medium
            ),
          ),
          InkWell(
            onTap: !isDevConsoleVisible ? onTapVersion : null,
            child: CustomerDetailTile(
              visibility: deviceInfo.appVersion?.isNotEmpty ?? false,
              label: "app_version".tr.capitalize,
              description: deviceInfo.appVersion ?? "",
              trailing: isDevConsoleVisible ? JPButton(
                text: 'dev_console'.tr.toUpperCase(),
                size: JPButtonSize.extraSmall,
                onPressed: onTapDevConsole,
              ) : null,
            ),
          ),

          divider(deviceInfo.deviceModel?.isNotEmpty ?? false),
          CustomerDetailTile(
            visibility: deviceInfo.deviceModel?.isNotEmpty ?? false,
            label: 'model'.tr.capitalize,
            description: '${deviceInfo.deviceModel} (${deviceInfo.deviceVersion})',
          ),

          divider(deviceInfo.manufacturer?.isNotEmpty ?? false),
          CustomerDetailTile(
            visibility: deviceInfo.manufacturer?.isNotEmpty ?? false,
            label: "manufacturer".tr.capitalize,
            description: deviceInfo.manufacturer ?? "",
          ),
        ],
      ),
    );
  }
}