import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/models/device_info.dart';
import 'package:jobprogress/common/models/sql/user/user.dart';
import 'package:jobprogress/common/repositories/user.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/mixpanel/index.dart';
import 'package:jobprogress/common/services/shared_pref.dart';
import 'package:jobprogress/core/constants/mix_panel/event/view_events.dart';
import 'package:jobprogress/core/constants/shared_pref_constants.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/add_signature_dialog/index.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/routes/pages.dart';

class MyProfileController extends GetxController {

  late GlobalKey<ScaffoldState> scaffoldKey;

  UserModel? userDetails;
  DeviceInfo? deviceInfo;

  Uint8List? signatureBytes;

  int versionTaps = 0;

  bool isDevConsoleVisible = false;

  MyProfileController() {
    setUpController();
  }

  Future<void> setUpController() async {
    scaffoldKey = GlobalKey<ScaffoldState>();
    userDetails = AuthService.userDetails;
    isDevConsoleVisible = Helper.isTrue(await SharedPrefService().read(PrefConstants.devConsole));
    Helper.getDeviceInfo().then((deviceInfo) {
      this.deviceInfo = deviceInfo;
      update();
    });
  }

  Future<void> fetchSignatures() async {
    try {
      showJPLoader();

      Map<String, dynamic> params = {
        'user_ids[]' : AuthService.userDetails?.id
      };

      signatureBytes = await UserRepository.viewSignature<Uint8List>(params);
    } catch(e) {
      rethrow;
    } finally {
      Get.back();
    }
  }

  Future<void> showAddViewSignatureDialog({bool viewOnly = false}) async {

    if(viewOnly) {
      // loading signature before displaying
      await fetchSignatures();
      if(signatureBytes == null) {
        Helper.showToastMessage('no_signatures_added'.tr);
        return;
      }
      MixPanelService.trackEvent(event: MixPanelViewEvent.profileSignatureView);
    }

    showJPGeneralDialog(
        child: (_) => AddViewSignatureDialog(
          viewOnly: viewOnly,
          signatureImage: signatureBytes,
        ),
    );
  }

  void openDevConsole() {
    Get.toNamed(Routes.devConsole);
  }

  void onTapVersion() {
    if (versionTaps == 0) {
      Future.delayed(const Duration(seconds: 1), () {
        versionTaps = 0;
      });
    }
    versionTaps++;
    if (versionTaps >= 3) {
      SharedPrefService().save(PrefConstants.devConsole, true);
      isDevConsoleVisible = true;
      update();
      Helper.showToastMessage('you_are_now_a_developer'.tr);
    }
  }
}