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

final KVStorage = new FlutterSecureStorage();

class Body extends StatelessWidget {
  dynamic scanData;
  QRViewController controller;
  String code = "";
  Body(scanData, controller) {
    this.scanData = scanData;
    this.controller = controller;
    code = this.scanData.code;
  }
  @override
  Widget build(BuildContext context) {
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
            future: rest.getEventInfo(code),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      NikuText("Name: " + snapshot.data.content['name']),
                      NikuText(
                          "Start: " + snapshot.data.content['time']['readable_start']),
                      NikuText("End: " + snapshot.data.content['time']['readable_end']),
                      NikuText("Description: " +
                          snapshot.data.content['description']),
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
