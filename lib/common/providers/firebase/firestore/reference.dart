
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jobprogress/core/constants/firebase/firestore_keys.dart';

class ReferenceProvider {

  static CollectionReference groupsMessageRef = FirebaseFirestore.instance.collection(FirestoreKeys.groupMessages);
  static CollectionReference groupsRef = FirebaseFirestore.instance.collection(FirestoreKeys.groups);
  static CollectionReference usersRef = FirebaseFirestore.instance.collection(FirestoreKeys.users);
  static CollectionReference jobsRef = FirebaseFirestore.instance.collection(FirestoreKeys.jobs);
  static CollectionReference groupParticipantsRef = FirebaseFirestore.instance.collection(FirestoreKeys.groupParticipant);

}