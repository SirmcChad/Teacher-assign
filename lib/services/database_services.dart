import 'package:teacher_assign/models/CourseModel.dart';
import 'package:teacher_assign/models/StudentModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/TeacherModel.dart';

class DatabaseServices{
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  final CollectionReference courseCollection = FirebaseFirestore.instance.collection('courses');
  final CollectionReference studentCollection = FirebaseFirestore.instance.collection('students');
  final CollectionReference teacherCollection = FirebaseFirestore.instance.collection('teachers');



  Future updateUserData(String uid, bool isTeacher,String name)async{
    return await userCollection.doc(uid).set(
      {
        'name': name,
        'isTeacher': isTeacher,
      }
    );
  }



  Future addCourseToStudent(String uid, String courseUid) async{
    await studentCollection.doc(uid).update({'courses': FieldValue.arrayUnion([courseUid]) });
  }


  Future addCourseToTeacher(String uid, String courseUid) async{
    await teacherCollection.doc(uid).update({'courses': FieldValue.arrayUnion([courseUid] )});
  }
  // Firestore can't store non-primative lists

  Future addStudentToCourse(String uid, String studentUid) async{
    await courseCollection.doc(uid).update({'students': FieldValue.arrayUnion([studentUid]) });
  }

  Future newStudent(String uid, String name)async{
    List<String> empty = [];
    return await studentCollection.doc(uid).set(
        {
          'name': name,
          'courses': empty,
        }
    );
  }

  Future newTeacher(String uid, String name)async{
    List<String> empty = [];
    return await teacherCollection.doc(uid).set(
        {
      'name': name,
      'courses': empty,
    }
    );
  }
  Future newCourse(String name, String teacherName, String password)async{

    final docRef = courseCollection.doc();
    List<String> empty = [];
     await docRef.set(
        {
          'name': name,
          'students': empty,
          'tasks': 1,
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

  StudentModel _studentModelFromSnapshot(DocumentSnapshot snapshot){
    return StudentModel(
      uid: snapshot.id,
      name: snapshot.get('name'),
      courses: snapshot.get('courses').cast<String>()
    );
  }

  Stream<StudentModel> getStudentData (String uid) {
    return studentCollection.doc(uid).snapshots().map(_studentModelFromSnapshot);
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
  TeacherModel _teacherModelFromSnapshot(DocumentSnapshot snapshot){
    return TeacherModel(
        uid: snapshot.id,
        name: snapshot.get('name'),
        courses: snapshot.get('courses').cast<String>()
    );
  }

  Stream<CourseModel> getCourseData (String uid) {
    return courseCollection.doc(uid).snapshots().map(_courseModelFromSnapshot);
  }
  Stream<TeacherModel> getTeacherData(String uid){
    return teacherCollection.doc(uid).snapshots().map(_teacherModelFromSnapshot);
  }
}