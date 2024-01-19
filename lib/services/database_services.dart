

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseServices{
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  Future updateUserData(String uid, bool isTeacher)async{
    return await userCollection.doc(uid).set(
      {
        'uid':uid,
        'isTeacher': isTeacher,
      }
    );
  }
}