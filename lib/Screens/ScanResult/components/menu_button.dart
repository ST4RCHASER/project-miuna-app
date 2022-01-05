import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:niku/niku.dart';
import 'package:project_miuna/constants.dart';

class MenuButton extends StatelessWidget {
  final String text;
  final Function press;
  final Color color, textColor;
  const MenuButton({
    Key key,
    this.text,
    this.press,
    this.color = kSecondaryColor,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Container(
          width: size.width * 0.85,
          child: ClipRRect(
            child: FlatButton(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                color: color,
                onPressed: press,
                child: Container(
                  // decoration: BoxDecoration(
                  //   image: DecorationImage(
                  //       image: AssetImage('assets/icons/scan.png'),
                  //       fit: BoxFit.cover),
                  // ),
                  child: Align(
                      child: NikuText(text).fontSize(30).color(textColor),
                      alignment: Alignment.topLeft),
                )),
          ),
        ));
  }
}
