import 'package:flutter/material.dart';

class Message{
  BuildContext context;
  Message({required this.context});

  void welcoming(){
    final snackBar = SnackBar(
      content: Text('logging in'),
      duration: Duration(seconds: 5),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showCustomMessage(String message, int seconds){
    final snackBar = SnackBar(
      content: Text(message),
      duration: Duration(seconds: seconds),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showCustomLovely(String message, int seconds){
    final snackBar = SnackBar(
      backgroundColor: Colors.green,
      content: Row(
        children: [
          Icon(Icons.check, color: Colors.white),
          SizedBox(width: 10),
          Text(message, style: TextStyle(color: Colors.white)),
        ],
      ),
      duration: Duration(seconds: seconds),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

  }
}