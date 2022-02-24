import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:project_miuna/Screens/Home/components/background.dart';
import 'package:project_miuna/Screens/Home/components/event_card.dart';
import 'package:project_miuna/Screens/Home/components/menu_button.dart';
import 'package:project_miuna/Screens/Home/home_screen.dart';
import 'package:project_miuna/Screens/QRScan/qrscan_screen.dart';
import 'package:project_miuna/Screens/Settings/settings_screen.dart';
import 'package:project_miuna/Screens/Welcome/welcome_screen.dart';
import 'package:project_miuna/components/head_text.dart';
import 'package:project_miuna/components/square_password_field.dart';
import 'package:project_miuna/components/thematic_text.dart';
import 'package:project_miuna/constants.dart';
import 'package:project_miuna/utils/rest.dart' as rest;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:project_miuna/components/square_button.dart';
import 'package:niku/niku.dart';

final KVStorage = new FlutterSecureStorage();

class Body extends StatelessWidget {
  TextEditingController oldPasswordController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController cfmPasswordController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    BuildContext mastercontext = context;
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
                  child: NikuText("Change Password")
                      .color(Colors.black)
                      .fontSize(32)
                      .fontWeight(FontWeight.bold),
                  padding: EdgeInsets.only(top: 10, bottom: 20)),
            ]),
          ]),
          NikuColumn([
            SquarePasswordField(
                hintText: "Old password",
                onChanged: (value) {},
                controller: oldPasswordController,
                validator: (String value) {
                  if (oldPasswordController.text == null ||
                      oldPasswordController.text.length < 1)
                    return 'Please enter your current password';
                  if (oldPasswordController.text.length < 6)
                    return 'Password must be at least 6 characters';
                  return null;
                }),
            SquarePasswordField(
                hintText: "New password",
                onChanged: (value) {},
                controller: passwordController,
                validator: (String value) {
                  if (passwordController.text == null ||
                      passwordController.text.length < 1)
                    return 'Please enter your new password';
                  if (passwordController.text.length < 6)
                    return 'Password must be at least 6 characters';
                  return null;
                }),
            SquarePasswordField(
                hintText: "Confirm new password",
                controller: cfmPasswordController,
                onChanged: (value) {},
                validator: (String value) {
                  if (cfmPasswordController.text == null ||
                      cfmPasswordController.text.length < 1)
                    return 'Please enter your confirm new password';
                  if (cfmPasswordController.text != passwordController.text)
                    return 'Confirm Password is not matching your password';
                  return null;
                }),
            SquareButton(
              text: "Submit",
              press: () async {
                //Try login using old password if ok change password
                var username = await KVStorage.read(key: "username");
                rest
                    .authenticateAccount(username, oldPasswordController.text)
                    .then((result) => {
                          if (result.success)
                            {
                              rest
                                  .updateInfomation(
                                      password: passwordController.text)
                                  .then((result) => {
                                        if (result.success)
                                          {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text("Success"),
                                                  content: Text("Password has been changed"),
                                                  actions: <Widget>[
                                                    FlatButton(
                                                      child: Text("Close"),
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                        Navigator.of(mastercontext).pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            )
                                          }
                                        else
                                          {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text("Error"),
                                                  content: Text(result.message),
                                                  actions: <Widget>[
                                                    FlatButton(
                                                      child: Text("Close"),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            )
                                          }
                                      })
                            }
                          else
                            {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Error"),
                                      content: Text(result.message.replaceAll('Username/Email or Password', 'Old Password')),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text("Close"),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        )
                                      ],
                                    );
                                  })
                            }
                        });
              },
            ),
          ]),
        ]),
      ),
    );
  }
}
