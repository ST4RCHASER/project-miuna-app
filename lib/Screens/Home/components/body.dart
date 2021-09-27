import 'package:flutter/material.dart';
import 'package:project_miuna/Screens/Login/components/background.dart';
import 'package:project_miuna/Screens/Welcome/welcome_screen.dart';
import 'package:project_miuna/components/head_text.dart';
import 'package:project_miuna/utils/rest.dart' as rest;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:project_miuna/components/square_button.dart';

final KVStorage = new FlutterSecureStorage();

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          TextHeader(
            child: Text(
              "Home",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
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
        ],
      )),
    );
  }
}
