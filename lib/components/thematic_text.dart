import 'package:flutter/material.dart';
import 'package:project_miuna/constants.dart';
import 'package:niku/niku.dart';

class ThematicText extends StatelessWidget {
  final String text;
  final double top;
  const ThematicText({
    Key key,
    this.top = 15,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 26.0, right: 26.0,top: top),
      child: Align(
        alignment: Alignment.topLeft,
        child: NikuColumn([
          Align(
              alignment: Alignment.topLeft, child: NikuText(text).fontSize(18)),
          Container(
              height: 1.0,
              color: Colors.black,
              margin: EdgeInsets.symmetric(vertical: 5.0)),
        ]),
      ),
    );
  }
}
