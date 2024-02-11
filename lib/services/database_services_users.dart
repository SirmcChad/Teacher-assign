import 'package:teacher_assign/models/CourseModel.dart';
import 'package:teacher_assign/models/StudentModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/TeacherModel.dart';
class DatabaseServicesUsers{
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  Future updateUserData(String uid, bool isTeacher,String name)async{
    return await userCollection.doc(uid).set(
        {
          'name': name,
          'isTeacher': isTeacher,
        }
    );
  }


}