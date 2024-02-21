import 'package:flutter/material.dart';

class Utility{
  late int numberOfTasks;
  late int numberOfStudentsPerGroup;
  late int remainderStudents;
  late int confirmedStudents;

  Utility(int nTasks, int nStudentsPerGroup, int tStudents){
    numberOfTasks = nTasks;
    numberOfStudentsPerGroup = nStudentsPerGroup;
    remainderStudents = tStudents % numberOfTasks;
    confirmedStudents = tStudents ~/ numberOfTasks;
  }

  Color colouring(int index){
    if (numberOfTasks == 1 && numberOfStudentsPerGroup == 1){
      return Colors.blue.shade100;
    }
    else if (numberOfTasks == 1) {
      return randomColor(index~/numberOfStudentsPerGroup) ;
    }
    else {
      if(index < (confirmedStudents+1) * remainderStudents){
        return randomColor(index ~/ (confirmedStudents+1));
      }

      else{
        return randomColor(((index - (confirmedStudents+1) * remainderStudents) ~/ confirmedStudents) + remainderStudents);
      }
    }
  }

  Color randomColor(int index){
    List<Color> colors = [
      Color(0xFF3F51B5), // indigo
      Color(0xFF4CAF50), // green
      Color(0xFF2196F3), // blue
      Color(0xFFE91E63), // pink
      Color(0xFFFFC107), // amber
      Color(0xFFFF5722), // deep orange
      Color(0xFF795548), // brown
      Color(0xFF9C27B0), // purple
    ];

    return colors[index % colors.length];
  }
}
