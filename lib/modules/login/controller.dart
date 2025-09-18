import 'dart:async';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/libraries/global.dart' as globals;
import 'package:jobprogress/common/models/active_login_session_model.dart';
import 'package:jobprogress/common/models/login.dart';
import 'package:jobprogress/common/models/login/demo_user.dart';
import 'package:jobprogress/common/models/sql/user/user.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/mixpanel/index.dart';
import 'package:jobprogress/core/constants/mix_panel/event/login_events.dart';
import 'package:jobprogress/core/constants/platform_constants.dart';
import 'package:jobprogress/core/utils/date_time_helpers.dart';
import 'package:jobprogress/core/utils/helpers.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/controller.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/company_switch_dialog_box/controller.dart';
import 'package:jobprogress/common/repositories/login.dart';
import 'package:jobprogress/global_widgets/loader/index.dart';
import 'package:jobprogress/global_widgets/updgrde_plan_dialog/index.dart';
import 'package:jobprogress/routes/pages.dart';
import 'package:jp_mobile_flutter_ui/ConfirmationDialog/index.dart';
import 'package:jp_mobile_flutter_ui/MultiSelect/modal.dart';
import 'package:jp_mobile_flutter_ui/jp_mobile_flutter_ui.dart';
import '../../common/services/api_gateway/index.dart';
import '../../global_widgets/active_login_session_dialog/index.dart';

class LoginController extends GetxController {
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final CompanySwitchController companySwitchController = Get.put(CompanySwitchController());

  late TextEditingController emailController, passwordController;

  bool isPasswordVisbilityButtonEnable = false;
  bool isPasswordVisbile = false;
  bool isLoading = false;
  bool isValidate = false;
  bool isDoingQuickLogin = false;

  late UserModel loggedInUser;

  Future<dynamic> getLoggedInData() async {
    loggedInUser = await AuthService.getLoggedInUser();
  }

  LoginModel loginData = LoginModel(
    username: '',
    password: '',
    uuid: "",
    appVersion: globals.appVersion,
    platform: "",
    manufacturer: "",
    osVersion: "",
    model: "",
  );

  GlobalKey signInButtonKey = GlobalKey();
  late ScrollController scrollController;

  Map<String, dynamic> deviceInfo = <String, dynamic>{};

  late ApiGatewayService apiGatewayService;

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      fetchDeviceInfo();
      apiGatewayService = Get.find();
      await apiGatewayService.init();
    });
  }

  @override
  void onClose() {
    scrollController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  enableVisibilityIcon(String value) {
    if (value.length > 1) {
      isPasswordVisbilityButtonEnable = true;
      update();
    } else {
      isPasswordVisbilityButtonEnable = false;
      update();
    }
  }

  void togglePasswordVisibilty() {
    isPasswordVisbile = !isPasswordVisbile;
    update();
  }

  void toggleIsLoading() {
    isLoading = !isLoading;
    update();
  }

  toggleisValidate() {
    isValidate = !isValidate;

    update();
  }

  String? validateEmail(String value) {
    if (value.isEmpty) {
      return "please_enter_email".tr;
    }

    if (!GetUtils.isEmail(value)) {
      return "please_enter_valid_email".tr;
    }

    return '';
  }

  String? validatePassword(String value) {
    if (value.isEmpty) {
      return "please_enter_password".tr;
    }

    return '';
  }

  bool validateLoginForm(GlobalKey<FormState> formKey) {
    return formKey.currentState!.validate();
  }

  void loginUser() async {
    try {
      if(!isDoingQuickLogin) {
        toggleIsLoading();
      }
      await LoginRepository().loginUser(loginData);
      await getLoggedInData();
      if (loggedInUser.allCompanies != null && loggedInUser.allCompanies!.length > 1) {
        await companySwitchController.openCompanySwitchBox(true);
      } else {
        Helper.showToastMessage('user_logged_in'.tr);
        MixPanelService.trackEvent(event: isDoingQuickLogin ? MixPanelLoginEvent.demoLoginSuccess : MixPanelLoginEvent.loginSuccess);
        Get.offNamedUntil(Routes.home, (route) => false);
      }
    } catch (e) {
      fetchActiveSessions(e);
      fetchBillingCodeFromError(e);
      MixPanelService.trackEvent(event: isDoingQuickLogin ? MixPanelLoginEvent.demoLoginFailed : MixPanelLoginEvent.loginFailed);
      // rethrow;
    } 
    
     finally {
      if(!isDoingQuickLogin) {
        toggleIsLoading();
      }else{
        Get.back();
      }

      isDoingQuickLogin = false;
      update();
    }
  }

  void fetchBillingCodeFromError(dynamic error) {
    if (error is DioException && error.response?.data['error']['message'] is Map) {
      String? billingCode = error.response?.data['error']['message']['billing_code'].toString();
      if (!Helper.isValueNullOrEmpty(billingCode)) {
        showUpgradePlanDialog(billingCode!);
      }
    }
  }

  void showUpgradePlanDialog(String billingCode) {
    showJPBottomSheet(
      child: (JPBottomSheetController controller) {
        return UpgradePlanDialog(
          billingCode: billingCode,
          controller: controller,
          title: 'upgrade_plan'.tr,
          subTitle: 'upgrade_plan_confirmation'.tr,
        );
      }
    );
  }

  //This function check and move sign in button above keyboard
  void scrollSignInButtonAboveKeyboard() async{

    await Future<void>.delayed(const Duration(milliseconds: 500));

    // Getting position of sign in button
    RenderBox? box = getRenderObject(signInButtonKey);
    if(box == null) return;
    Offset position = box.localToGlobal(Offset.zero);

    // Getting area that will be visible on keyboard
    double viewPortHeight = scrollController.position.viewportDimension;
    double difference = position.dy - viewPortHeight + box.size.height;

    // Condition confirms whether button is behind
    if (difference > 0) {
      double scrollPosition = difference + scrollController.offset + 45; // 45 is difference between keyboard and sign in button
      scrollController.animateTo(scrollPosition, duration: const Duration(milliseconds: 150), curve: Curves.easeIn);
    }
  }

  RenderBox? getRenderObject(GlobalKey key) {
    if(key.currentContext == null) return null;
    return key.currentContext!.findRenderObject() as RenderBox?;
  }

  tryQuickDemo() async {
    isDoingQuickLogin = true;
    update();

    try {
      DemoUserModel demoUser = await LoginRepository().getDemoUser();

      loginData.username = demoUser.username;
      loginData.password = demoUser.password;
      loginUser();
    } catch (e) {
      isDoingQuickLogin = false;
      update();
    }
  }

  loginInWithEmailPass(){
    isDoingQuickLogin = false;
    toggleisValidate();
    if (!validateLoginForm(loginFormKey)) {
      return;
    }
    loginFormKey.currentState!.save();
    loginUser();
  }

  showQuickDemoDialog() {
    showJPBottomSheet(
      child: (_) => GetBuilder<LoginController>(
        builder: (context) {
          return JPConfirmationDialog(
                title: "information".tr,
            subTitle: "you_will_be_logged_out_automatically_after_30_min".tr,
            suffixBtnText: 'signin'.tr,
            disableButtons: isDoingQuickLogin,
            icon: Icons.info_outline,
            suffixBtnIcon: showJPConfirmationLoader(show: isDoingQuickLogin),
            onTapPrefix: () {
              Get.back();
            },
            onTapSuffix: () {
              tryQuickDemo();
            },
          );
        }
      ),
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true
    );
  }
  
  void fetchDeviceInfo() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

    String udid = await FlutterUdid.udid;

    if(Platform.isAndroid) {
      deviceInfoPlugin.androidInfo.then((value) {
        loginData.uuid = udid;
        loginData.appVersion = globals.appVersion;
        loginData.platform = 'Android';
        loginData.manufacturer = value.manufacturer;
        loginData.osVersion = value.version.release;
        loginData.model = value.model;
        update();
      });
    } else {
      deviceInfoPlugin.iosInfo.then((value) {
        loginData.uuid = udid;
        loginData.appVersion = globals.appVersion;
        loginData.platform = value.systemName;
        loginData.manufacturer = 'Apple';
        loginData.osVersion = value.systemVersion;
        loginData.model = value.name;
        update();
      });
    }
  }

  /// [showLoginActiveSessionDialog] shows a dialog to manage active login sessions.
  void showLoginActiveSessionDialog(List<JPMultiSelectModel> mySessions, VoidCallback onSessionLogout) {
    int selectedItemCount = 0;
    showJPDialog(child: (dialogController) => ActiveLoginSessionDialog(
      sessions: mySessions,
      selectedItemCount: selectedItemCount,
      onTapSelectAndClearAll: () {
        if(selectedItemCount > 0) {
          selectedItemCount = 0;
          setSessionSelection(false, mySessions);
        } else {
          selectedItemCount = mySessions.length;
          setSessionSelection(true, mySessions);
        }
        dialogController.update();
      },
      onTapItem: (id) {
        final JPMultiSelectModel? jpMultiSelectModel = mySessions.firstWhereOrNull((element) => element.id == id);
        if(jpMultiSelectModel != null) {
          jpMultiSelectModel.isSelect = !jpMultiSelectModel.isSelect;
         if(jpMultiSelectModel.isSelect == true) {
           selectedItemCount++;
         } else {
            selectedItemCount--;
         }
        }
        dialogController.update();
      },
      onTapContinue: () {
        logoutSelectedActiveSessions(mySessions.first.additionData, getSessionIds(mySessions), onSessionLogout);
      }
    ));
  }

  /// [getDeviceIcon] returns an icon based on the device type.
  Widget getDeviceIcon(String? type) {
    final IconData? icon;
    switch(type) {
      case PlatformConstants.android:
        icon = Icons.phone_android_outlined;
      case PlatformConstants.ios:
        icon = Icons.phone_iphone_outlined;
      default:
        icon = Icons.computer_outlined;
    }
    return JPIcon(icon, size: 20, color: JPAppTheme.themeColors.primary);
  }

  /// [setSessionSelection] sets the selection state for all sessions.
  void setSessionSelection(bool isSelect, List<JPMultiSelectModel> mySessions) {
    for (final JPMultiSelectModel session in mySessions) {
      session.isSelect = isSelect;
    }
  }

  /// [getSessionIds] returns a list of session IDs from the selected sessions.
  List<int> getSessionIds(List<JPMultiSelectModel> mySessions) {
  return mySessions.where((element) => element.isSelect).map((e) => int.parse(e.id)).toList();
  }

  /// [logoutSelectedActiveSessions] logs out the selected active sessions.
  Future<void> logoutSelectedActiveSessions(String? userId, List<int> sessionIds, VoidCallback onSessionLogout) async {
    try {
      showJPLoader();
      final Map<String, dynamic> params = {
        'session_ids[]': sessionIds,
        'username': loginData.username,
        'password': loginData.password,
        'user_id': userId,
      };
      final bool isSuccess = await LoginRepository().logoutActiveSessions(params);
      Get.back();
      if(isSuccess) {
        onSessionLogout.call();
      }
    } catch(e) {
      Get.back();
      Helper.handleError(e);
    }
  }

  /// [fetchActiveSessions] checks for active sessions and shows a dialog if there are any.
  void fetchActiveSessions(dynamic error) {
    if(error is DioException && error.response?.statusCode == 409) {
      List<ActiveLoginSessionModel> activeSessions = [];
      error.response?.data['error']['active_sessions']?.forEach((dynamic session) {
        activeSessions.add(ActiveLoginSessionModel.fromJson(session));
      });
      if (activeSessions.isNotEmpty) {
        showLoginActiveSessionDialog(getActiveUserSessionList(activeSessions), () {
          loginUser();
        });
      }
    }
  }

  /// [getActiveUserSessionList] converts a list of active login sessions to a list of JPMultiSelectModel.
  List<JPMultiSelectModel> getActiveUserSessionList(List<ActiveLoginSessionModel> activeSessions) {
    List<JPMultiSelectModel> jpMultiSelectModels = [];
    for (var user in activeSessions) {
      jpMultiSelectModels.add(JPMultiSelectModel(
          id: user.id.toString(),
          label: '${user.platform} on ${user.os}',
          child: getDeviceIcon(user.os?.toLowerCase()),
          subLabel: DateTimeHelper.getLastActiveMessage(user.lastActivityAt ?? ''),
          isHighlighted: user.os?.toLowerCase() == PlatformConstants.ios
              || user.os?.toLowerCase() == PlatformConstants.android,
          isSelect: false,
          additionData: user.userId?.toString()
      ));
    }
    return jpMultiSelectModels;
  }

}
