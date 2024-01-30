

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseServices{
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  final CollectionReference courseCollection = FirebaseFirestore.instance.collection('cources');



  Future updateUserData(String uid, bool isTeacher,String name)async{
    return await userCollection.doc(uid).set(
      {
        'name': name,
        'isTeacher': isTeacher,
      }
    );
  }
}