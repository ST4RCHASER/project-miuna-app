import 'package:flutter/material.dart';
import 'package:project_miuna/components/text_field_container.dart';
import 'package:project_miuna/constants.dart';

class SquarePasswordField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final TextEditingController controller;
  final String hintText;
  final dynamic validator;
  const SquarePasswordField({
    Key key,
    this.onChanged,
    this.hintText = "Password",
    this.controller,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        obscureText: true,
        onChanged: onChanged,
        cursorColor: kPrimaryColor,
        controller: controller,
        validator: validator,
        decoration: InputDecoration(
          hintText: hintText,
          icon: Icon(
            Icons.lock,
            color: kPrimaryColor,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
