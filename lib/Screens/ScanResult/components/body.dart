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
  dynamic scanData;
  String code = "";
  Body(scanData){
    this.scanData = scanData;
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
                      NikuText("Name: "+snapshot.data.content['name']),
                      NikuText("Start: "+snapshot.data.content['time']['start']),
                      NikuText("End: "+snapshot.data.content['time']['end']),
                      NikuText("Description: "+snapshot.data.content['description']),
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
          MenuButton(text: 'JOIN', color: Colors.green,textColor: Colors.white, press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return QRScanScreen();
                    },
                  ),
                );
              },),
              MenuButton(text: 'DISMISS', color: Colors.red,textColor: Colors.white, press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return QRScanScreen();
                    },
                  ),
                );
              },),
        ],
      )),
    );
  }
}
