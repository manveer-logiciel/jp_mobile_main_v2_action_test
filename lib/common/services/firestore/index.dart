

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:jobprogress/common/enums/firebase.dart';
import 'package:jobprogress/common/services/firestore/auth/index.dart';
import 'package:jobprogress/common/services/firestore/streams/groups/index.dart';
import 'package:jobprogress/core/utils/firebase/firestore.dart';
import 'package:jobprogress/global_widgets/from_firebase/controller.dart';
import 'streams/counts.dart';

class FirestoreService {

  static StreamSubscription<DocumentSnapshot>? unreadMessageCountStream;
  static Stream<DocumentSnapshot>? groupsStream;

  static Future<void> initAllStreams() async {

    if(!FirestoreHelpers.instance.isMessagingEnabled) return;

    if(FirestoreHelpers.instance.isFirebaseLoggedIn) {
      unreadMessageCountStream = FirestoreCountsStream().getUnreadMessageCountStream;
    } else {

      await FirebaseAuthService.login().then((value) {
        initAllStreams();
      });

    }
  }


  static Future<void> disposeAllStreams() async {
    await unreadMessageCountStream?.cancel();
    await GroupsService.closeCachedStreams();
  }

  static void updateControllerWithValue(FireStoreKeyType key, dynamic value) {

    if(value == null) return;

    final controller = Get.find<FromFirebaseController>();
    controller.valuesMapFirestore[key] = value;
    controller.update();
  }

}