import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  String title;
  String initialValue;
  Function onChange;
  bool moreChars;

  CustomTextField({required this.title, required this.initialValue, required this.onChange, required this.moreChars});

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
        if (value!.length < 1) {
          return '${widget.title} must be at least 1 character';
        }
        else if(value.length > 254){
          return '${widget.title} must be less than 255 characters';
        }

        else if(!widget.moreChars && value.length > 35){
          return '${widget.title} must be less than 35 characters';
        }
        return null;
      },
      onChanged: (value){
        widget.onChange(value);
      },
    );
  }
}