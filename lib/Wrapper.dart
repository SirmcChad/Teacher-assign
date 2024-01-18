import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teacher_assign/authentication/SignInTeacher.dart';
import 'package:teacher_assign/authentication/choose.dart';
import 'package:teacher_assign/authentication/signInStudent.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User?>(context);

    // return either home or AuthenticationChoice depending on authentication status
    if (user == null) {
      return Choose();
    }
      else{
        return Choose();
    }

  }
}
