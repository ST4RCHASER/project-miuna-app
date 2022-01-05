import 'package:flutter/material.dart';
import 'package:project_miuna/Screens/ScanResult/components/body.dart';

class ScanResult extends StatelessWidget {
  dynamic scanData;
  ScanResult(scanData){
    this.scanData = scanData;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(this.scanData),
    );
  }
}
