import 'package:flutter/material.dart';
import 'package:project_miuna/constants.dart';
import 'package:niku/niku.dart';

class ThematicText extends StatelessWidget {
  final String text;
  const ThematicText({
    Key key,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal:  26.0),
      child: Align(
        alignment: Alignment.topLeft,
        child: NikuColumn([
          Align(alignment: Alignment.topLeft, child: Text(text)),
          Container(
              height: 1.0,
              color: Colors.black,
              margin: EdgeInsets.symmetric(vertical: 5.0)),
        ]),
      ),
    );
  }
}
