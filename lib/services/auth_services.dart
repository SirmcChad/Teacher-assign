
import 'package:firebase_auth/firebase_auth.dart';
import 'package:teacher_assign/services/database_services_student.dart';
import 'package:teacher_assign/services/database_services_teacher.dart';
import 'package:teacher_assign/services/database_services_users.dart';
import 'package:teacher_assign/shared/custom_user.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get user {
    print('invoked?');
    return _auth.authStateChanges();
  }

  CustomUser? toCustom (User? user) {

    }

  Future signInAnon()async{
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return user;
    } catch(e){
      print(e);
      print('signing in ananomously failed');
    }
  }

  Future signInWithEmailAndPassword(String email,String password)async{
    try{
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return user;
    }catch(e){
      print(e.toString());
      print('some error occured signing in with email and password');
      return null;
    }
  }

  Future signUpWithEmailAndPasswordTeacher(String email,String password, String name)async{
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      DatabaseServicesUsers().updateUserData(user!.uid, true,name);
      DatabaseServicesTeacher().newTeacher(user!.uid, name);
      return user;
    }catch(e){
      print(e.toString());
      print('some error occured creating a user with email and password');
      return null;
    }
  }

  Future signUpWithEmailAndPasswordStudent(String email,String password,String name)async{
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      DatabaseServicesUsers().updateUserData(user!.uid, false,name);
      DatabaseServicesStudent().newStudent(user!.uid, name);
      return user;
    }catch(e){
      print(e.toString());
      print('some error occured creating a user with email and password');
      return null;
    }
  }


  Future signOutUser() async{
    try{
      return _auth.signOut();
    }catch(e){
      return null;
    }

  }
}