import 'package:jobprogress/common/enums/firebase.dart';

class FirebaseRealtimeStreamModel {
  FirebaseRealtimeStreamModel(
    this.path,
    this.keyType, {
    this.onValueChanged,
    this.onData,
    this.doListenInitialRead = true
  });

  String path;

  RealTimeKeyType keyType;

  Function()? onValueChanged;

  Function(dynamic)? onData;

  bool doListenInitialRead;

}
