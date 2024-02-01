import 'package:teacher_assign/Models/CourseModel.dart';
import 'package:teacher_assign/Models/StudentModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseServices{
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  final CollectionReference courseCollection = FirebaseFirestore.instance.collection('courses');
  final CollectionReference studentCollection = FirebaseFirestore.instance.collection('students');
  final CollectionReference teacherCollection = FirebaseFirestore.instance.collection('teacher');



  Future updateUserData(String uid, bool isTeacher,String name)async{
    return await userCollection.doc(uid).set(
      {
        'name': name,
        'isTeacher': isTeacher,
      }
    );
  }

  Future addCourseToStudent(String uid, CourseModel course) async{
    await studentCollection.doc(uid).update({'courses': FieldValue.arrayUnion([course])});
  }

  Future addCourseToTeacher(String uid, CourseModel course) async{
    await teacherCollection.doc(uid).update({'courses': FieldValue.arrayUnion([course])});
  }

  Future addStudentToCourse(String uid, StudentModel student) async{
    await courseCollection.doc(uid).update({'courses': FieldValue.arrayUnion([student])});
  }

  StudentModel _studentModelFromSnapshot(DocumentSnapshot snapshot){
    return StudentModel(
      uid: snapshot.get('uid'),
      name: snapshot.get('name'),
      courses: snapshot.get('courses')
    );
  }

  Stream<StudentModel> getStudentData (String uid) {
    return studentCollection.doc(uid).snapshots().map(_studentModelFromSnapshot);
  }



  CourseModel _courseModelFromSnapshot(DocumentSnapshot snapshot){
    return CourseModel(
        uid: snapshot.get('uid'),
        students: snapshot.get('students'),
        courseSubject: snapshot.get('courseSubject'),
        numberOfTasks: snapshot.get('numberOfTasks')
    );
  }

  Stream<CourseModel> getCourseData (String uid) {
    return courseCollection.doc(uid).snapshots().map(_courseModelFromSnapshot);
  }
}