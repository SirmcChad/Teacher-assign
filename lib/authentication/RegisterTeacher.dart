import 'package:flutter/material.dart';
import 'package:teacher_assign/shared/custom_password_field.dart';
import 'package:teacher_assign/shared/custom_text_field.dart';
import 'package:teacher_assign/shared/custom_loading.dart';
import 'package:teacher_assign/shared/snackbar_messager.dart';

import '../services/auth_services.dart';

class RegisterTeacher extends StatefulWidget {
  Function toggleView;
  RegisterTeacher({Key? key,required this.toggleView}) : super(key: key);

  @override
  State<RegisterTeacher> createState() => _RegisterTeacherState();
}

class _RegisterTeacherState extends State<RegisterTeacher> {
  final _formKey = GlobalKey<FormState>();
  final _auth = AuthServices();
  String name ='';
  String email = "";
  String password = "";
  String error ='';

  bool isLoading = false;
  

  @override
  Widget build(BuildContext context) {
    Message message = Message(context: context);
    if (isLoading){
      return Loading();
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
            color: Colors.black
        ),
        backgroundColor: Colors.grey.shade100,
        title: Text('Sign Up Teacher', style: TextStyle(color: Colors.black),),
        actions: [
          TextButton.icon(
            onPressed: () {
              widget.toggleView();
            },
            icon: Icon(Icons.person,color: Colors.black,),
            label: Text('Sign In',style: TextStyle(color: Colors.black),),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(title: "Name", initialValue: email, onChange: (value) {name = value;}, moreChars: false,),
              SizedBox(height: 30,),
              CustomTextField(title: "Email", initialValue: email, onChange: (value) {email = value;}, moreChars: true,),
              SizedBox(height: 30,),
              CustomPasswordField(title: "Password", initialPassword: password, visiblePassword: true, onChange: (value) {password = value;},),
              SizedBox(height: 20,),
              ElevatedButton(
                onPressed: () async{
                  if (_formKey.currentState!.validate()) {

                    setState(() {isLoading = true;});
                    dynamic result = await _auth.signUpWithEmailAndPasswordTeacher(email, password, name);


                    if (result !=null){
                      Navigator.pop(context);
                      message.firstTime();
                    }
                    else{
                      setState(() {
                        error = 'some error occured, check your credintials';
                      });
                    }
                    setState(() {isLoading = false;});
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent[100],
                ),
                child: Text('Sign up',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white
                  ),
                ),
              ),
              Text(error, style: TextStyle(fontSize: 18,color: Colors.red, fontWeight: FontWeight.bold),)

            ],
          ),
        ),
      ),
    );

  }
}
