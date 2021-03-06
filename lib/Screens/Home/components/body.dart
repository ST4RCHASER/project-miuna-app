import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project_miuna/Screens/Home/components/background.dart';
import 'package:project_miuna/Screens/Home/components/event_card.dart';
import 'package:project_miuna/Screens/Home/components/menu_button.dart';
import 'package:project_miuna/Screens/Home/home_screen.dart';
import 'package:project_miuna/Screens/QRScan/qrscan_screen.dart';
import 'package:project_miuna/Screens/Settings/settings_screen.dart';
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
    rest.updateInfomationToKVStorage();
    return Background(
      child: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          NikuColumn(
            [
              NikuRow([
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, top: 10.0),
                      child: Text(
                        "Home",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 35),
                      )),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.55,
                ),
                Align(
                    alignment: Alignment.centerRight,
                    child: NikuIconButton(Icon(Icons.menu, size: 40))
                        .onPressed(() {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SettingsScreen()));
                    }))
              ])
            ],
          ),
          ThematicText(text: 'Join or leave event', top: 16),
          MenuButton(
            text: 'SCAN NOW',
            color: Colors.green,
            textColor: Colors.white,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return QRScanScreen();
                  },
                ),
              );
            },
          ),
          // ThematicText(text: 'Event management (Remove soon)'),
          // MenuButton(text: 'CREATE NEW', press: () {}),
          // MenuButton(text: 'MY EVENTS', press: () {}),
          ThematicText(text: 'Current entry event'),
          FutureBuilder(
              future: rest.getJoinedEventList(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(children: [
                    for (var i in snapshot.data.content)
                      EventCard(
                        startTime: DateTime.parse(i.record.timeJoin)
                            .millisecondsSinceEpoch,
                        name: i.event.name,
                        creator: i.eventOwner.username,
                        eventID: i.event.sId,
                        recordID: i.record.sId,
                      ),
                  ]);
                }
                return Container();
              }),
          // ThematicText(text: 'Dev zone'),
          // SquareButton(
          //   text: "Logout",
          //   press: () {
          //     KVStorage.delete(key: 'token').then((result) => {
          //           Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //               builder: (context) {
          //                 return WelcomeScreen();
          //               },
          //             ),
          //           )
          //         });
          //   },
          // ),
        ],
      )),
    );
  }
}
