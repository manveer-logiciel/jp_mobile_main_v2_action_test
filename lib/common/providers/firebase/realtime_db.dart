import 'dart:async';
import 'dart:ui';

import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/firebase.dart';
import 'package:jobprogress/common/models/firebase/firebase_realtime.dart';
import 'package:jobprogress/global_widgets/from_firebase/controller.dart';
import 'package:jobprogress/common/services/shared_pref.dart';
import '../../../core/utils/helpers.dart';

SharedPrefService prefService = SharedPrefService();

class RealtimeDBProvider {

  static final firebaseInstance = FirebaseDatabase.instance;
  static Map<RealTimeKeyType, StreamSubscription<DatabaseEvent>> streamsMap = {};
  static StreamController<String> localStreamController = StreamController.broadcast();

  static createOneStream({required FirebaseRealtimeStreamModel streamData}) {

    if(streamsMap.containsKey(streamData.keyType)) return;

    final controller = Get.find<FromFirebaseController>();

    StreamSubscription<DatabaseEvent> streamSubscription = firebaseInstance.ref(streamData.path).onValue.listen((event) async {

      try {
        String? value = event.snapshot.value?.toString();

        if(streamData.doListenInitialRead)  await streamData.onData?.call(value);
        streamData.doListenInitialRead = true;

        controller.valuesMap[streamData.keyType] = value;

        if (streamData.keyType == RealTimeKeyType.emailUnread) {
          await Helper.setApplicationBadgeCount(value);
        }
        controller.update();

        if (await prefService.read(streamData.keyType.toString()) == value) return;

        await streamData.onValueChanged?.call();

        await prefService.save(streamData.keyType.toString(), value);

        putDataOnLocalStream(streamData.keyType.toString());
      } catch(e){
        rethrow;
      }

    });

    streamsMap.putIfAbsent(streamData.keyType, () => streamSubscription);
  }

  static createLocalStream({required String path, Function? onValueUpdate, Function(dynamic)? onData}) {

    return firebaseInstance.ref(path).onValue.listen((event) async {

      try {
        String? value = event.snapshot.value?.toString();

        if(onData != null) await onData(value);
        if (onValueUpdate != null) await onValueUpdate();

      } catch(e){
        rethrow;
      }

    });

  }

  static Future<void> removeOneStream({required RealTimeKeyType keyType}) async {
    await streamsMap[keyType]?.cancel();
    streamsMap.remove(keyType);
  }

  static void putDataOnLocalStream(String key) {
    localStreamController.add(key);
  }

  static StreamSubscription<String> listenToLocalStream(RealTimeKeyType key, {VoidCallback? onData}) {
    StreamSubscription<String> subscription = localStreamController.stream.listen((event) {
      if (event == key.toString()) {
        onData?.call();
      }
    });
    return subscription;
  }

}
