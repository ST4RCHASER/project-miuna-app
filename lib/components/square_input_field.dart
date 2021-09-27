import 'package:flutter/material.dart';
import 'package:project_miuna/components/text_field_container.dart';
import 'package:project_miuna/constants.dart';

class SquareInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final TextEditingController controller;
  final dynamic validator;
  const SquareInputField({
    Key key,
    this.hintText,
    this.icon = Icons.person,
    this.onChanged,
    this.controller,
    this.validator
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
        cursorColor: kPrimaryColor,
        validator: validator,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: kPrimaryColor,
          ),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
