import 'package:flutter/gestures.dart';

class MapGestureRecognizers extends TapAndPanGestureRecognizer {
  Function recognizeGesture;

  MapGestureRecognizers(this.recognizeGesture);

  @override
  void resolve(GestureDisposition disposition) {
    super.resolve(disposition);
    recognizeGesture();
  }

  @override
  String get debugDescription => throw UnimplementedError();
}