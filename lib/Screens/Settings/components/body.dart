import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:project_miuna/Screens/ChangePassword/changepassword_screen.dart';
import 'package:project_miuna/Screens/EditInfo/editinfo_screen.dart';
import 'package:project_miuna/Screens/Home/components/background.dart';
import 'package:project_miuna/Screens/Home/components/event_card.dart';
import 'package:project_miuna/Screens/Home/components/menu_button.dart';
import 'package:project_miuna/Screens/Home/home_screen.dart';
import 'package:project_miuna/Screens/QRScan/qrscan_screen.dart';
import 'package:project_miuna/Screens/Welcome/welcome_screen.dart';
import 'package:project_miuna/components/head_text.dart';
import 'package:project_miuna/components/thematic_text.dart';
import 'package:project_miuna/constants.dart';
import 'package:project_miuna/utils/rest.dart' as rest;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:project_miuna/components/square_button.dart';
import 'package:niku/niku.dart';

final KVStorage = new FlutterSecureStorage();

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView(
        child: NikuColumn([
          NikuRow([
            NikuIconButton(Icon(Icons.arrow_back_ios_new))
              ..color(Colors.blue)
              ..py(25)
              ..px(30)
              ..onPressed(() {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  SystemNavigator.pop();
                }
              }),
            NikuColumn([
              Padding(
                  child: NikuText("Settings")
                      .color(Colors.black)
                      .fontSize(32)
                      .fontWeight(FontWeight.bold),
                  padding: EdgeInsets.only(top: 10, bottom: 20)),
            ]),
          ]),
          NikuColumn([
            ThematicText(text: 'Account', top: 16),
            SquareButton(
              color: kPrimaryLightColor,
              textColor: Colors.black,
              text: "Edit infomation",
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return EditInfoScreen();
                    },
                  ),
                );
              },
            ),
            SquareButton(
              color: kPrimaryLightColor,
              textColor: Colors.black,
              text: "Change Password",
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return ChangePasswordScreen();
                    },
                  ),
                );
              },
            ),
            SquareButton(
              text: "Logout",
              press: () {
                KVStorage.delete(key: 'token').then((result) => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return WelcomeScreen();
                          },
                        ),
                      )
                    });
              },
            ),
          ]),
        ]),
      ),
    );
  }
}
