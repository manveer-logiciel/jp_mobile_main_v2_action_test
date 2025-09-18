import 'package:get/get.dart';
import 'package:jobprogress/common/services/free_trial_user_data/index.dart';
import 'package:jobprogress/core/constants/urls.dart';
import 'package:jobprogress/core/utils/helpers.dart';

class JPDayCountDownController extends GetxController {
  
  // calculate days left in 30 days trial
  String calculateDaysLeft(int ? remaining) {
    String trialMessage = 'left_in_trial'.tr;
    String days;
    
    if(!Helper.isValueNullOrEmpty(remaining)) {
      days = remaining == 1 || remaining == 0 ? 'day' : 'days';
      return '$remaining $days $trialMessage';
    }
    return '';
  }

  // check if widget should be visible
  bool shouldWidgetBeVisible(int? remainingDays, bool visibility) {
    return !Helper.isValueNullOrEmpty(remainingDays) && visibility ;
  }

  // launch upgrade url with billing code
  void upgradePlan() async {
    String billingCode =  FreeTrialUserDataService.billingCode ?? '';
    if(billingCode != "") {
     Helper.launchUrl(Urls.upgradeUrl(billingCode)); 
    }
  }
}
