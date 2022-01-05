import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_miuna/Screens/Home/components/background.dart';
import 'package:project_miuna/Screens/Home/components/event_card.dart';
import 'package:project_miuna/Screens/Home/components/menu_button.dart';
import 'package:project_miuna/Screens/ScanResult/scan_result.dart';
import 'package:project_miuna/Screens/Welcome/welcome_screen.dart';
import 'package:project_miuna/components/head_text.dart';
import 'package:project_miuna/components/thematic_text.dart';
import 'package:project_miuna/utils/rest.dart' as rest;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:project_miuna/components/square_button.dart';
import 'package:niku/niku.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:io' show Platform;
import 'dart:io' as IO;

final KVStorage = new FlutterSecureStorage();

class Body extends StatefulWidget {
  const Body({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<Body> {
  Barcode result;
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (IO.Platform.isAndroid) {
      controller.pauseCamera();
    }
    controller.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NikuColumn([
      NikuRow([
        NikuColumn([
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
            })
        ]),
        NikuColumn([
          Padding(
              child: NikuText("Scan and check in")
                ..color(Colors.black).fontSize(24),
              padding: EdgeInsets.only(top: 20, bottom: 20)),
        ])
      ]),
      Expanded(flex: 1, child: _buildQrView(context))
    ]).niku()
          ..pt(30));
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
        // var scanArea = (MediaQuery.of(context).size.width < 400 ||
        //     MediaQuery.of(context).size.height < 400)
        // ? 150.0
        // : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.white,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      controller.pauseCamera();
      if(scanData.code.length != 24) {
        //Show invalid QR code dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Invalid QR Code"),
              content: Text("Please scan a valid QR code"),
              actions: <Widget>[
                FlatButton(
                  child: Text("Close"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    controller.resumeCamera();
                  },
                )
              ],
            );
          },
        );
      }else {
        //Open ScanResult page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScanResult(
              scanData,
            ),
          ),
        );
      }
      // showDialog(
      //     context: context,
      //     builder: (BuildContext context) {
      //       return AlertDialog(
      //         title: Text("Scan Result"),
      //         content: Text(scanData.code),
      //         actions: <Widget>[
      //           FlatButton(
      //             child: Text("Close"),
      //             onPressed: () {
      //               controller.resumeCamera();
      //               Navigator.of(context).pop();
      //             },
      //           )
      //         ],
      //       );
      //     });
      setState(() {
        result = scanData;
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    //log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Camera permission denied')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
