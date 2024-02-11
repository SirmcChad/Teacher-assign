import 'package:teacher_assign/models/CourseModel.dart';
import 'package:teacher_assign/models/StudentModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/TeacherModel.dart';

class DatabaseServicesStudent{
  final CollectionReference studentCollection = FirebaseFirestore.instance.collection('students');

  Future addCourseToStudent(String uid, String courseUid) async{
    // DocumentSnapshot courseSnapshot = await courseCollection.doc(courseUid).get();
    // CourseModel course = _courseModelFromSnapshot(courseSnapshot);
    // final json = course.toJSON();
    await studentCollection.doc(uid).update({'courses': FieldValue.arrayUnion([courseUid]) });
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

  StudentModel _studentModelFromSnapshot(DocumentSnapshot snapshot){
    print(snapshot);
    print(snapshot.get('name'));
    print(snapshot.get('courses'));
    return StudentModel(
        uid: snapshot.id,
        name: snapshot.get('name'),
        courses: snapshot.get('courses').cast<String>()
    );
  }

  Stream<StudentModel> getStudentData (String uid) {
    return studentCollection.doc(uid).snapshots().map(_studentModelFromSnapshot);
  }

}