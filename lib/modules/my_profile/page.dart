import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/device_info.dart';
import 'package:jobprogress/global_widgets/main_drawer/index.dart';
import 'package:jobprogress/global_widgets/safearea/safearea.dart';
import 'package:jobprogress/global_widgets/scaffold/index.dart';
import 'package:jobprogress/modules/company_contacts/detail/page.dart';
import 'package:jobprogress/modules/my_profile/controller.dart';
import 'package:jobprogress/modules/my_profile/widgets/company_details.dart';
import 'package:jobprogress/modules/my_profile/widgets/device_info.dart';
import 'package:jobprogress/modules/my_profile/widgets/header.dart';
import 'package:jobprogress/modules/my_profile/widgets/signature_buttons.dart';
import 'package:jobprogress/modules/my_profile/widgets/user_phone_email.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';

class MyProfileView extends StatelessWidget {
  const MyProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyProfileController>(
      global: false,
      init: MyProfileController(),
      builder: (controller) {
      return JPScaffold(
        backgroundColor: JPAppTheme.themeColors.inverse,
        endDrawer: JPMainDrawer(
          selectedRoute: 'my_profile',
        ),
        scaffoldKey: controller.scaffoldKey,
        body: JPSafeArea(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverPersistentHeader(
                pinned: true,
                floating: true,
                delegate: MyProfileHeader(controller: controller)
              ),
              SliverPersistentHeader(
                pinned: true,
                floating: false,
                delegate: Delegate(),
              ),
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.only(bottom: 40),
                  color: JPAppTheme.themeColors.inverse,
                  child: Column(
                    children: [
                      MyProfileEmailPhone(userDetails: controller.userDetails!),
                      const SizedBox(height: 20),
                      MyProfileCompanyDetails(userDetails: controller.userDetails!),
                      const SizedBox(height: 20),
                      MyProfileDeviceInfo(
                        deviceInfo: controller.deviceInfo ?? DeviceInfo(),
                        onTapDevConsole: controller.openDevConsole,
                        onTapVersion: controller.onTapVersion,
                        isDevConsoleVisible: controller.isDevConsoleVisible,
                      ),
                      MyProfileSignatureButtons(
                        onTapAddSignature: controller.showAddViewSignatureDialog,
                        onTapViewSignature: () => controller.showAddViewSignatureDialog(viewOnly: true),
                      ),
                    ],
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