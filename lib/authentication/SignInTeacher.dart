import 'package:flutter/material.dart';
import 'package:teacher_assign/shared/custom_password_field.dart';
import 'package:teacher_assign/shared/custom_text_field.dart';
import 'package:teacher_assign/shared/custom_loading.dart';
import '../services/auth_services.dart';

class SignInTeacher extends StatefulWidget {
  Function toggleView;
  SignInTeacher({super.key,required this.toggleView});

  @override
  State<SignInTeacher> createState() => _SignInTeacherState();
}

class _SignInTeacherState extends State<SignInTeacher> {

  final _formKey = GlobalKey<FormState>();
  final _auth = AuthServices();
  String email = "";
  String password = "";

  bool isLoading = false;


  @override
  Widget build(BuildContext context) {
    if (isLoading){
      return Loading();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In Teacher'),
        actions: [
          Row(
            children: [
              IconButton(
                  icon: Icon(Icons.person),
                  onPressed: () {widget.toggleView();}
              ),
              Text("Sign Up")
            ],
          )
        ],
      ),
        //
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.person),
        //     onPressed: () {widget.toggleView();}
        //   )
        // ]
        //TODO alternate between register/sign in button top right of the screen

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(title: "Email", initialValue: email, onChange: (value) {email = value;}),
              SizedBox(height: 30,),
              CustomPasswordField(title: "Password", initialPassword: password, visiblePassword: false, onChange: (value) {password = value;},),
              SizedBox(height: 20,),
              ElevatedButton(
                onPressed: () async{
                  if (_formKey.currentState!.validate()) {
                    setState(() {isLoading = true;});

                    dynamic result = await _auth.signInWithEmailAndPassword(email, password);

                    if (result !=null){
                      Navigator.pop(context);
                    }
                    else{
                      //TODO handle displaying the error message
                    }
                    setState(() {isLoading = false;});
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent[100],
                ),
                child: Text('Sign In',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(onPressed: (){
      //   widget.toggleView();
      // },),
    );
  }
}