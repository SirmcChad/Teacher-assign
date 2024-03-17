class CourseModel {
  String uid;
  List<String> students;
  String courseSubject;
  int numberOfTasks;
  int numberOfStudents;
  String teacherName;
  String password;

  CourseModel({required this.uid, required this.students, required this.courseSubject, required this.numberOfTasks, required this.numberOfStudents, required this.teacherName, required this.password});
}