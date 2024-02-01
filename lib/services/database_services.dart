

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/CourseModel.dart';

class DatabaseServices{
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  final CollectionReference courseCollection = FirebaseFirestore.instance.collection('courses');
  final CollectionReference teacherCollection = FirebaseFirestore.instance.collection('teachers');



  Future updateUserData(String uid, bool isTeacher,String name)async{
    return await userCollection.doc(uid).set(
      {
        'name': name,
        'isTeacher': isTeacher,
      }
    );
  }

  Future updateTeacherData(String uid, String name, List<CourseModel> courses) async {
    return await teacherCollection.doc(uid).set(
      {
        'name': name,
        'courses': courses
      }
    );
  }

  Future teacherAddCourse(String uid,String name, CourseModel course) async{
    DocumentSnapshot snapshot = await teacherCollection.doc(uid).get();

    if (snapshot.exists){
      List<CourseModel> courses = snapshot['courses'];
      courses.add(course);
      return updateTeacherData(uid, name, courses);
    }

    Stream<DocumentSnapshot> getTeacherSnapshot (String uid){
      return teacherCollection.doc(uid).snapshots();
    }


  }
}