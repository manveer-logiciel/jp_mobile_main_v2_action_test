import 'dart:convert';
import 'package:jobprogress/common/providers/http/interceptor.dart';
import 'package:jobprogress/common/services/feature_flag.dart';
import 'package:jobprogress/core/constants/urls.dart';

class FeatureFlagRepository{
  static Future<void> getFeatureFlag() async{
    await dio.get(Urls.featureFlag).then((res){
      final jsonData = json.decode(res.toString());
      Map<String,dynamic> featureFlagData = {};

      //Converting api data to model
      for(dynamic data in jsonData["data"]){
        featureFlagData[data["feature"]] = data["flag"];
      }
      //Setting feature data into service and updating controller
      FeatureFlagService.setFeatureData(featureFlagData);
    });
  }
}