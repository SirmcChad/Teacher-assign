import 'package:flutter/material.dart';

class Utility {
  int numberOfStudentsPerGroup;
  int numberOfTasks;
  int totalStudents;

  Utility({ required this.numberOfStudentsPerGroup,required this.numberOfTasks,required this.totalStudents});





  Color colouring(int index){
    if (numberOfTasks == 1 && numberOfStudentsPerGroup == 1) {
      return Colors.blue.shade100 ;
    }
    else if (numberOfTasks == 1) {
      return _randomColor(index~/numberOfStudentsPerGroup);
    }
    else{

      /*
      case:
      totalStudent = 13
      numberOfTasks = 4

      base = 3
      remainder = 1
       */
      int base = totalStudents ~/ numberOfTasks;
      int remainder = totalStudents % numberOfTasks;
      if (index < (base + 1) * remainder){
        return _randomColor(index ~/ (base + 1));
      }
      else {
        return _randomColor((index - (base + 1) * remainder) ~/ base + remainder);
      }



    }
  }


  Color _randomColor(int index){
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

  int getGroupNumber(int index){
    if (numberOfTasks == 1 && numberOfStudentsPerGroup == 1) {
      return 1;
    }

    else if (numberOfTasks == 1) {
      return index~/numberOfStudentsPerGroup;
    }

    else{
      int base = totalStudents ~/ numberOfTasks;
      int remainder = totalStudents % numberOfTasks;
      if (index < (base + 1) * remainder){
        return index ~/ (base + 1);
      }
      else {
        return (index - (base + 1) * remainder) ~/ base + remainder;
      }
    }
  }


  // int getNumberOfDivisions(){
  //   if (numberOfTasks == 1 && numberOfStudentsPerGroup == 1) {
  //     return totalStudents;
  //   }
  //   else if (numberOfTasks == 1) {
  //     return totalStudents~/numberOfStudentsPerGroup;
  //   }
  //   else{
  //     return numberOfTasks;
  //   }
  // }

  List<int> getRanges(){
    List<int> result = [0];

    if (numberOfTasks == 1) {
      for (int i=numberOfStudentsPerGroup; i<=totalStudents; i+=numberOfStudentsPerGroup){
        result.add(i);
      }
      if (totalStudents % numberOfStudentsPerGroup !=0){
        result.add(totalStudents% numberOfStudentsPerGroup + result[result.length -1]);
      }

      /*
      TODO consider my implementation of the getRanges method
      List<int> result = [];

  for (int i=0;i<=totalStudents; i+=numberOfStudentsPerGroup){
    result.add(i);
  }
  if (totalStudents % numberOfStudentsPerGroup !=0){
    result.add(totalStudents% numberOfStudentsPerGroup + result[result.length -1]);
  }


  return result;
       */
    }

    else{
      int confirmedStudents = totalStudents~/numberOfTasks;
      int remainder = totalStudents%numberOfTasks;

      for(int i = 1; i <= numberOfTasks; i++){
        if(remainder > 0){
          result.add(result[i-1] + confirmedStudents + 1);
          remainder--;
        }

        else{
          result.add(result[i-1] + confirmedStudents);
        }
      }
    }

    return result;
  }


}