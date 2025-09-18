import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jobprogress/common/enums/firebase.dart';
import 'package:jobprogress/common/services/auth.dart';
import 'package:jobprogress/common/services/firestore/index.dart';

class FirestoreCountsStream {

  StreamSubscription<DocumentSnapshot> get getUnreadMessageCountStream =>
      FirebaseFirestore.instance
          .collection('users')
          .doc('${AuthService.userDetails?.id}')
          .snapshots().listen((event) {
            FirestoreService.updateControllerWithValue(FireStoreKeyType.unreadMessageCount, event.data()?['unread_message_count']);
      });

}
