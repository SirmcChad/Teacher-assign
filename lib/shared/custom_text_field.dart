import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  String title;
  String initialValue;
  Function onChange;

  CustomTextField({required this.title, required this.initialValue, required this.onChange});

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {



  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: widget.initialValue,
      decoration: InputDecoration(
          labelText: widget.title,
          hintText: 'Enter ${widget.title}',
          border: OutlineInputBorder()
      ),
      validator: (value) {
        if (value!.length < 6) {
          return '${widget.title} must be more than 6 characters';
        }
        return null;
      },
      onChanged: (value){
        widget.onChange(value);
      },
    );
  }
}