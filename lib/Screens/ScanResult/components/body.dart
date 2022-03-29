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
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:async';

final KVStorage = new FlutterSecureStorage();

class Body extends StatelessWidget {
  dynamic scanData;
  QRViewController controller;
  String code = "";
  dynamic data;
  bool force = false;
  Body(scanData, controller, data, force) {
    this.scanData = scanData;
    this.controller = controller;
    this.data = data;
    this.force = force;
    code = data["id"];
  }
  @override
  Widget build(BuildContext context) {
    var mcontext = context;
    return Background(
      child: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          TextHeader(
            child: Text(
              "Event infomation",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
            ),
          ),
          NikuText('Event ID: ' + code),
          //Get event id from QR code and get event info from server
          FutureBuilder(
            future: rest.getEventInfo(code, false),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (!force && (snapshot.data.content["qrType"] == 2 ||
                    snapshot.data.content["qrType"] == "2")) {
                  if (data['hash'] != snapshot.data.content["oneTimeHash"]) {
                    Timer setTimeout(callback, [int duration = 1]) {
                      return Timer(Duration(milliseconds: duration), callback);
                    }
                    Timer t;
                    t = setTimeout(() => {
                          showDialog(
                            context: mcontext,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Used QR code"),
                                content: Text(
                                    "This QR code is already used and cannot be use to join."),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text("Close"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      Navigator.pop(mcontext);
                                    },
                                  )
                                ],
                              );
                            },
                          ),
                          t.cancel(),
                        });
                    return Container();
                  } else {
                    rest.getEventInfo(code, true);
                  }
                }
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      NikuText("Name: " + snapshot.data.content['name']),
                      NikuText("Start: " +
                          snapshot.data.content['time']['readable_start']),
                      NikuText("End: " +
                          snapshot.data.content['time']['readable_end']),
                      NikuText("Description: " +
                                  snapshot.data.content['description'] ==
                              null
                          ? snapshot.data.content['description']
                          : ''),
                      snapshot.data.content['is_joining']
                          ? MenuButton(
                              text: 'LEAVE',
                              color: Colors.red,
                              textColor: Colors.white,
                              press: () {
                                rest.leaveEvent(code).then((value) => {
                                      if (value.success)
                                        {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    HomeScreen()),
                                          )
                                        }
                                      else
                                        {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                      title: Text(value.success
                                                          ? "Success"
                                                          : "Failed"),
                                                      content:
                                                          Text(value.message),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () => {
                                                            if (value.success)
                                                              {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              HomeScreen()),
                                                                )
                                                              }
                                                            else
                                                              {
                                                                Navigator.pop(
                                                                    context),
                                                              }
                                                          },
                                                          child:
                                                              const Text('OK'),
                                                        ),
                                                      ]))
                                        }
                                    });
                              },
                            )
                          : MenuButton(
                              text: 'JOIN',
                              color: Colors.green,
                              textColor: Colors.white,
                              press: () {
                                rest.joinEvent(code).then((value) => {
                                      if (value.success)
                                        {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    HomeScreen()),
                                          )
                                        }
                                      else
                                        {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                      title: Text(value.success
                                                          ? "Success"
                                                          : "Failed"),
                                                      content:
                                                          Text(value.message),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () => {
                                                            if (value.success)
                                                              {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              HomeScreen()),
                                                                )
                                                              }
                                                            else
                                                              {
                                                                Navigator.pop(
                                                                    context),
                                                              }
                                                          },
                                                          child:
                                                              const Text('OK'),
                                                        ),
                                                      ]))
                                        }
                                    });
                              },
                            ),
                    ],
                  ),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          MenuButton(
            text: 'DISMISS',
            color: Colors.blue,
            textColor: Colors.white,
            press: () {
              Navigator.pop(context);
            },
          ),
        ],
      )),
    );
  }
}
