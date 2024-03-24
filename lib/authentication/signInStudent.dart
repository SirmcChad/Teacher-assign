import 'package:flutter/material.dart';
import 'package:teacher_assign/services/auth_services.dart';
import 'package:teacher_assign/shared/custom_loading.dart';
import 'package:teacher_assign/shared/custom_password_field.dart';
import 'package:teacher_assign/shared/custom_text_field.dart';
import 'package:teacher_assign/shared/snackbar_messager.dart';



class SignInStudent extends StatefulWidget {
  Function toggleView;
   SignInStudent({super.key,required this.toggleView});

  @override
  State<SignInStudent> createState() => _SignInStudentState();
}

class _SignInStudentState extends State<SignInStudent> {

  AuthServices _auth = AuthServices();

  final _formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String error = '';

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
        title: Text('Sign In Student', style: TextStyle(color: Colors.black),),
        actions: [
          TextButton.icon(
            onPressed: () {
              widget.toggleView();
            },
            icon: Icon(Icons.person,color: Colors.black,),
            label: Text('Sign Up',style: TextStyle(color: Colors.black),),
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
              CustomTextField(title: "Email", initialValue: email, onChange: (value) {email = value;}, moreChars: true,),
              SizedBox(height: 30,),
              CustomPasswordField(title: "Password", initialPassword: password, visiblePassword: true, onChange: (value) {password = value;},),
              SizedBox(height: 20,),
              ElevatedButton(
                onPressed: () async{
                  if (_formKey.currentState!.validate()) {
                    setState(() {isLoading = true;});
                    dynamic result = await _auth.signInWithEmailAndPassword(email, password);


                    if (result !=null){
                      Navigator.pop(context);
                      message.welcoming();
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Adjust the value as needed
                  ),
                ),
                child: Text('Sign In',
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