import 'package:get/get.dart';
import 'package:jobprogress/common/services/feature_flag.dart';

class FeatureFlagController extends GetxController {

  bool hasFeatureAllowed(List<String> featureKey){
    return FeatureFlagService.hasFeatureAllowed(featureKey);
  }

}