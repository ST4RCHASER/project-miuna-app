import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:niku/niku.dart';
import 'package:project_miuna/constants.dart';

class EventCard extends StatelessWidget {
  final String text;
  final Function press;
  final Color color, textColor;
  const EventCard({
    Key key,
    this.text,
    this.press,
    this.color = kSecondaryColor,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(bottom: 0),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 22.0, vertical: 10.0),
          height: 150,
          child: Card(
            color: kPrimaryLightColor,
            //             shape: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(12.0),
            //   borderSide: BorderSide(color: Colors.black, width: 1)
            // ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            elevation: 8,
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Container(
                child: NikuRow([
                  NikuRow([
                    NikuColumn([Text('EVENT_NAME')])
                  ]),
                  NikuRow([]),
                ]),
              ),
            ),
          ),
        ));
  }
}
