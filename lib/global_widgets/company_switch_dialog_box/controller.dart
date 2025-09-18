import 'package:get/get.dart';
import 'package:jobprogress/common/models/sql/company/company.dart';
import 'package:jobprogress/common/models/sql/user/user.dart';
import 'package:jobprogress/common/repositories/company_switch.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/clock_in_clock_out.dart';
import 'package:jobprogress/common/services/company_settings.dart';
import 'package:jobprogress/common/services/launch_darkly/index.dart';
import 'package:jobprogress/common/services/location/background_location_service.dart';
import 'package:jobprogress/common/services/mixpanel/index.dart';
import 'package:jobprogress/core/constants/mix_panel/event/switch_events.dart';
import 'package:jobprogress/core/constants/mix_panel/event/view_events.dart';
import 'package:jobprogress/core/utils/consent_helper.dart';
import 'package:jobprogress/global_widgets/bottom_sheet/index.dart';
import 'package:jobprogress/global_widgets/company_switch_dialog_box/index.dart';
import 'package:jobprogress/routes/pages.dart';

class CompanySwitchController extends GetxController {
  late UserModel loggedInUser;
  bool isLoading = false;

  Future<dynamic> getCompanySwitchData() async {
    loggedInUser = await AuthService.getLoggedInUser();
    moveSelectedItemToTop();
  }

  openCompanySwitchBox(bool isLoginPage) async {
    MixPanelService.trackEvent(event: MixPanelViewEvent.companySwitchViewOpen);
    await getCompanySwitchData();
    showJPGeneralDialog(
      child: (_) => JPCompanySwitcherDialogBox(isLoginPage: isLoginPage),
    );
  }

  Future<void> switchCompany(int compId) async {
    if(isLoading) return;

    isLoading = true;
    update();
    try {
      Map<String, dynamic> response =
          await CompanySwitchRepository().switchCompanyData(compId);
      await AuthService.saveUserData(response['data']);
      MixPanelService.trackEvent(event: MixPanelSwitchEvent.companySwitchSuccess);
      Get.back(closeOverlays: true);
      CompanySettingsService.removeSettings();
      await BackgroundLocationService.stopTracking();
      await ClockInClockOutService.dispose();
      await LDService.dispose();
      ConsentHelper.clearLastTextStatus();
      Get.offNamedUntil(Routes.home, ((route) => false));
    } catch (e) {
      MixPanelService.trackEvent(event: MixPanelSwitchEvent.companySwitchFail);
      rethrow;
    } finally {
      isLoading = false;
      update();
    }
  }

// moveElement Function Move Selected Item from thier index to index 0 so selected item show top on the list.
  moveSelectedItemToTop() {
    int selectedCompanyIndex = loggedInUser.allCompanies!
        .indexWhere((element) => element.id == loggedInUser.companyDetails!.id);
    CompanyModel selectedCompany =
        loggedInUser.allCompanies![selectedCompanyIndex];
    loggedInUser.allCompanies!.removeAt(selectedCompanyIndex);
    loggedInUser.allCompanies!.insert(0, selectedCompany);
  }
}
