import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:project_miuna/Screens/Welcome/welcome_screen.dart';
import 'package:project_miuna/Screens/Home/home_screen.dart';
import 'package:project_miuna/constants.dart';
import 'package:project_miuna/constants.dart';
import 'package:flutter/services.dart';
final KVStorage = new FlutterSecureStorage();
var token = null;
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
     SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      statusBarBrightness: Brightness.light,
    ));
    var future = new FutureBuilder(
      future: KVStorage.read(key: 'token'),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        Widget widget;
      if(snapshot.connectionState == ConnectionState.done) {
        print(snapshot.data);
        widget = MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Miuna Check-in',
        theme: ThemeData(
          primaryColor: kPrimaryColor,
          scaffoldBackgroundColor: Colors.white,
        ),
        home: snapshot.data == null ? WelcomeScreen() : HomeScreen(),
      );
      }else {
        widget = Container(
         color: kPrimaryLightColor,
         child: Center(
           child: CircularProgressIndicator(
             color: kPrimaryColor
           ),
           ),
        );
      }
      return widget;
    });
    return future;
  }
}
