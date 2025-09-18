import 'dart:io';

import 'package:jobprogress/core/constants/maps.dart';

class GoogleMapsKeyConfig {
  final bool isAndroid = Platform.isAndroid;

  String get dev => isAndroid
      ? MapKeys.devAndroid
      : MapKeys.devIos;

  String get qa => isAndroid
      ? MapKeys.qaAndroid
      : MapKeys.qaIos;

  String get prod => isAndroid
      ? MapKeys.prodAndroid
      : MapKeys.prodIos;
}
