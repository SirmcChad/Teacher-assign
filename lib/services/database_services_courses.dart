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

  Future changeStudents(String uid,List<String> studentUids) async {
    await courseCollection.doc(uid).update({'students': studentUids});
  }
  Future changeTask(String uid, int numberOfTasks)async{
    await courseCollection.doc(uid).update({'tasks': numberOfTasks});
  }

  Future newCourse(String name, String teacherName)async{

    final docRef = courseCollection.doc();
    List<String> empty = [];
    await docRef.set(
        {
          'name': name,
          'students': empty,
          'tasks': 1,
          'teacherName' : teacherName,
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
      teacherName: snapshot.get('teacherName'),
    );
  }

  Stream<CourseModel> getCourseData (String uid) {
    return courseCollection.doc(uid).snapshots().map(_courseModelFromSnapshot);
  }
}