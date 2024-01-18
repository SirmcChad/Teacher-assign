import 'package:flutter/material.dart';
import 'signInStudent.dart';
import 'RegisterStudent.dart';



class AuthenticateStudent extends StatefulWidget {
  const AuthenticateStudent({Key? key}) : super(key: key);

  @override
  State<AuthenticateStudent> createState() => _AuthenticateStudentState();
}

class _AuthenticateStudentState extends State<AuthenticateStudent> {

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
        child: SignInStudent(),
      );
    }
    else{
      return Container(
        child: RegisterStudent(),
      );
    }
  }
}
