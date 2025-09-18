import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/feature_flag/controller.dart';

class FeatureFlagService{
  static Map<String,dynamic> featureFlagList = {};
  
  //check whether feature is allowed in featureFlagList
  static bool hasFeatureAllowed(List<String> featureKey) {
    if(featureFlagList.isEmpty){
      return true;
    }
    return featureKey.every((key)=>featureFlagList[key] == 1);
  }

  static setFeatureData(Map<String,dynamic> featureData) {
    featureFlagList = featureData;
    if(!Get.isRegistered<FeatureFlagController>()) {
      Get.put(FeatureFlagController());
    }

    final hasFeatureFlagController = Get.find<FeatureFlagController>();
    hasFeatureFlagController.update();
  }
}