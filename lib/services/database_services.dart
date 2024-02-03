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
    DocumentSnapshot courseSnapshot = await courseCollection.doc(courseUid).get();
    CourseModel course = _courseModelFromSnapshot(courseSnapshot);
    await studentCollection.doc(uid).update({'courses': FieldValue.arrayUnion([course])});
  }


  Future addCourseToTeacher(String uid, String courseUid) async{
    DocumentSnapshot courseSnapshot = await courseCollection.doc(courseUid).get();
    CourseModel course = _courseModelFromSnapshot(courseSnapshot);
    await teacherCollection.doc(uid).update({'courses': FieldValue.arrayUnion([course])});
  }

  Future addStudentToCourse(String uid, String studentUid) async{
    DocumentSnapshot studentSnapshot = await courseCollection.doc(studentUid).get();
    StudentModel student = _studentModelFromSnapshot(studentSnapshot);
    await courseCollection.doc(uid).update({'students': FieldValue.arrayUnion([student])});
  }

  Future newStudent(String uid, String name)async{
    return await studentCollection.doc(uid).set(
        {
          'name': name,
          'courses': [],
        }
    );
  }

  Future newTeacher(String uid, String name)async{
    return await teacherCollection.doc(uid).set(
        {
      'name': name,
      'courses': [],
    }
    );
  }
  Future newCourse(String uid, String name)async{
    return await courseCollection.doc(uid).set(
        {
          'name': name,
          'students': [],
          'tasks': 1,
        }
    );
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
      courses: snapshot.get('courses')
    );
  }

  Stream<StudentModel> getStudentData (String uid) {
    return studentCollection.doc(uid).snapshots().map(_studentModelFromSnapshot);
  }



  CourseModel _courseModelFromSnapshot(DocumentSnapshot snapshot){
    return CourseModel(
        uid: snapshot.id,
        students: snapshot.get('students'),
        courseSubject: snapshot.get('name'),
        numberOfTasks: snapshot.get('tasks')
    );
  }
  TeacherModel _teacherModelFromSnapshot(DocumentSnapshot snapshot){
    return TeacherModel(
        uid: snapshot.id,
        name: snapshot.get('name'),
        courses: snapshot.get('courses')
    );
  }

  Stream<CourseModel> getCourseData (String uid) {
    return courseCollection.doc(uid).snapshots().map(_courseModelFromSnapshot);
  }
  Stream<TeacherModel> getTeacherData(String uid){
    return teacherCollection.doc(uid).snapshots().map(_teacherModelFromSnapshot);
  }
}