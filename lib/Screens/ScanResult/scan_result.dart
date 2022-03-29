import 'package:flutter/material.dart';
import 'package:project_miuna/Screens/ScanResult/components/body.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanResult extends StatelessWidget {
  dynamic scanData;
  QRViewController controller;
  dynamic data;
  bool force;
  ScanResult(scanData, controller, data, force){
    this.scanData = scanData;
    this.controller = controller;
    this.data = data;
    this.force = force;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(this.scanData, this.controller, this.data, this.force),
    );
  }
}
