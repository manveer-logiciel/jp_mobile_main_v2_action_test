import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobprogress/global_widgets/feature_flag/controller.dart';

class HasFeatureAllowed extends StatelessWidget {
  
  final Widget child;
  final List<String> feature;

  const HasFeatureAllowed({
    required this.child,
    required this.feature,
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    if(!Get.isRegistered<FeatureFlagController>()) {
      Get.put(FeatureFlagController());
    }

    final hasFeatureFlagController = Get.find<FeatureFlagController>();
    return GetBuilder<FeatureFlagController>(
      builder: (_){
        if(hasFeatureFlagController.hasFeatureAllowed(feature)){
          return child;
        }
        else{
          return const SizedBox.shrink();
        }
      },
    );
  }
}