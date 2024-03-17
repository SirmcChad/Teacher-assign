import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teacher_assign/services/database_services_courses.dart';
import 'package:teacher_assign/services/database_services_student.dart';

import '../models/TeacherModel.dart';

class DatabaseServicesTeacher {
  final CollectionReference teacherCollection = FirebaseFirestore.instance.collection('teachers');

  Future addCourseToTeacher(String uid, String courseUid) async{

    await teacherCollection.doc(uid).update({'courses': FieldValue.arrayUnion([courseUid] )});
  }
  Future removeCourse(String teacherUid, String courseUid) async{
    final studentServicesInstance = DatabaseServicesStudent();
    final courseServicesInstance = DatabaseServicesCourses();
    List<String> studentUids = await courseServicesInstance.getStudentUids(courseUid);
    for (int i=0; i<studentUids.length;i++){
      studentServicesInstance.removeCourseFromStudent(studentUids[i], courseUid);
    }
    await teacherCollection.doc(teacherUid).update({'courses': FieldValue.arrayRemove([courseUid] )});
    courseServicesInstance.removeCourse(courseUid);

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