import 'package:flutter/material.dart';
import 'package:project_miuna/Screens/Home/components/background.dart';
import 'package:project_miuna/Screens/Home/components/event_card.dart';
import 'package:project_miuna/Screens/Home/components/menu_button.dart';
import 'package:project_miuna/Screens/Home/home_screen.dart';
import 'package:project_miuna/Screens/QRScan/qrscan_screen.dart';
import 'package:project_miuna/Screens/Welcome/welcome_screen.dart';
import 'package:project_miuna/components/head_text.dart';
import 'package:project_miuna/components/thematic_text.dart';
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
          child: Column(
        children: <Widget>[
          TextHeader(
            child: Text(
              "Home",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
            ),
          ),
          ThematicText(text: 'Join or leave event', top: 0),
          MenuButton(text: 'SCAN NOW', color: Colors.green,textColor: Colors.white, press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return QRScanScreen();
                    },
                  ),
                );
              },),
          ThematicText(text: 'Event management (Remove soon)'),
          MenuButton(text: 'CREATE NEW', press: () {}),
          MenuButton(text: 'MY EVENTS', press: () {}),
          ThematicText(text: 'Current entry event'),
          EventCard(startTime: DateTime.now().millisecondsSinceEpoch),
          ThematicText(text: 'Dev zone'),
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
