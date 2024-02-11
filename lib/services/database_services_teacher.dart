import 'package:teacher_assign/models/CourseModel.dart';
import 'package:teacher_assign/models/StudentModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/TeacherModel.dart';

class DatabaseServicesTeacher {
  final CollectionReference teacherCollection = FirebaseFirestore.instance.collection('teachers');

  Future addCourseToTeacher(String uid, String courseUid) async{
    // DocumentSnapshot courseSnapshot = await courseCollection.doc(courseUid).get();
    // CourseModel course = _courseModelFromSnapshot(courseSnapshot);
    // final json = course.toJSON();
    await teacherCollection.doc(uid).update({'courses': FieldValue.arrayUnion([courseUid] )});
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
  TeacherModel _teacherModelFromSnapshot(DocumentSnapshot snapshot){
    return TeacherModel(
        uid: snapshot.id,
        name: snapshot.get('name'),
        courses: snapshot.get('courses').cast<String>()
    );
  }
  Stream<TeacherModel> getTeacherData(String uid){
    return teacherCollection.doc(uid).snapshots().map(_teacherModelFromSnapshot);
  }
}