import 'package:teacher_assign/models/StudentModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseServicesStudent{
  final CollectionReference studentCollection = FirebaseFirestore.instance.collection('students');

  Future addCourseToStudent(String uid, String courseUid) async{
    await studentCollection.doc(uid).update({'courses': FieldValue.arrayUnion([courseUid]) });
  }

  Future removeCourseFromStudent(String studentUid, String courseUid) async{
    await studentCollection.doc(studentUid).update({'courses': FieldValue.arrayRemove([courseUid]) });
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