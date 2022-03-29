import 'package:flutter/material.dart';
import 'package:project_miuna/Screens/Login/login_screen.dart';
import 'package:project_miuna/Screens/Signup/signup_screen.dart';
import 'package:project_miuna/Screens/Welcome/components/background.dart';
import 'package:project_miuna/components/square_button.dart';
import 'package:project_miuna/constants.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image/image.dart';
class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // This size provide us total height and width of our screen
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Welcome",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.05),
            SvgPicture.asset(
              "assets/icons/chat.svg",
              height: size.height * 0.45,
            ),
            SizedBox(height: size.height * 0.05),
            SquareButton(
              text: "Sign with exist account",
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  ),
                );
              },
            ),
            SquareButton(
              text: "Register new account",
              color: kPrimaryLightColor,
              textColor: Colors.black,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SignUpScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
