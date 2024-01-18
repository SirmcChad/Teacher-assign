
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get user {
    return _auth.authStateChanges();
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

  Future signUpWithEmailAndPassword(String email,String password)async{
    try{
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return user;
    }catch(e){
      print(e.toString());
      print('some error occured creating a user with email and password');
      return null;
    }
  }


  Future signOutUser() async{
    try{
      print('signed out successfully');
      return _auth.signOut();
    }catch(e){
      print('some error occured signing out');
      return null;
    }

  }
}