import 'package:flutter/material.dart';
import 'package:teacher_assign/models/CourseModel.dart';
import 'package:teacher_assign/models/StudentModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/TeacherModel.dart';

class DatabaseServicesCourses{
  final CollectionReference courseCollection = FirebaseFirestore.instance.collection('courses');

  Future addStudentToCourse(String uid, String studentUid) async{
    // DocumentSnapshot studentSnapshot = await studentCollection.doc(studentUid).get();
    // StudentModel student = _studentModelFromSnapshot(studentSnapshot);
    // final json = student.toJSON();
    await courseCollection.doc(uid).update({'students': FieldValue.arrayUnion([studentUid]) });
  }

  Future removeStudentFromCourse(String courseUid, String studentUid) async{
    await courseCollection.doc(courseUid).update({'students': FieldValue.arrayRemove([studentUid])});
  }

  Future removeCourse(String courseUid)async{
    await courseCollection.doc(courseUid).delete();
  }

  Future<List<String>> getStudentUids(String courseUid)async{
    DocumentSnapshot snapshot =  await courseCollection.doc(courseUid).get();
    return snapshot.get('students').cast<String>();
  }

  Future changeStudents(String uid,List<String> studentUids) async {
    await courseCollection.doc(uid).update({'students': studentUids});
  }
  Future changeTask(String uid, int numberOfTasks)async{
    await courseCollection.doc(uid).update({'studentsPerGroup': 1});
    await courseCollection.doc(uid).update({'tasks': numberOfTasks});
  }
  Future changeStudentsPerGroup(String uid, int studentsPerGroup)async{
    await courseCollection.doc(uid).update({'tasks': 1});
    await courseCollection.doc(uid).update({'studentsPerGroup': studentsPerGroup});
  }

  Future newCourse(String name, String teacherName, String password)async{

    final docRef = courseCollection.doc();
    List<String> empty = [];
    await docRef.set(
        {
          'name': name,
          'students': empty,
          'tasks': 1,
          'studentsPerGroup': 1,
          'teacherName' : teacherName,
          'password' : password
        }
    );
    return  docRef.id;
  }

  Future courseExists(String uid) async{
    try{
      DocumentSnapshot snapshot = await courseCollection.doc(uid).get();
      if (snapshot.exists){
        return true;
      }

      else{
        return false;
      }
    } catch(e){
      return null;
    }
  }

  CourseModel _courseModelFromSnapshot(DocumentSnapshot snapshot){
    return CourseModel(
      uid: snapshot.id,
      students: snapshot.get('students').cast<String>(),
      courseSubject: snapshot.get('name'),
      numberOfTasks: snapshot.get('tasks'),
      numberOfStudents: snapshot.get('studentsPerGroup'),
      teacherName: snapshot.get('teacherName'),
      password: snapshot.get('password')
    );
  }

  Future checkPassword(String courseUid, String password) async{
    DocumentSnapshot snapshot = await courseCollection.doc(courseUid).get();
    String actualPassword = snapshot.get('password');

    return actualPassword == password;
  }

  Stream<CourseModel> getCourseData (String uid) {
    return courseCollection.doc(uid).snapshots().map(_courseModelFromSnapshot);
  }

  Future<List<CourseModel>> getAllData() async {
    QuerySnapshot querySnapshot = await courseCollection.get();

    return querySnapshot.docs.map((doc) {
      return _courseModelFromSnapshot(doc);
    }).toList();
  }
}