import 'package:flutter/material.dart';
import 'SignInTeacher.dart';
import 'RegisterTeacher.dart';


class AuthenticateTeacher extends StatefulWidget {
  const AuthenticateTeacher({Key? key}) : super(key: key);

  @override
  State<AuthenticateTeacher> createState() => _AuthenticateStudentState();
}

class _AuthenticateStudentState extends State<AuthenticateTeacher> {

  bool showSignIn = true;
  void toggleView(){
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn){
      return Container(
        child: SignInTeacher(),
      );
    }
    else{
      return Container(
        child: RegisterTeacher(),
      );
    }
  }
}
