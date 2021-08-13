import 'package:flutter/material.dart';
import 'package:project_miuna/Screens/Login/components/background.dart';
import 'package:project_miuna/Screens/Signup/signup_screen.dart';
import 'package:project_miuna/components/already_have_an_account_acheck.dart';
import 'package:project_miuna/components/square_button.dart';
import 'package:project_miuna/components/square_input_field.dart';
import 'package:project_miuna/components/square_password_field.dart';
import 'package:flutter_svg/svg.dart';

class Body extends StatelessWidget {
  const Body({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Sign to exist account",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/login.svg",
              height: size.height * 0.35,
            ),
            SizedBox(height: size.height * 0.03),
            SquareInputField(
              hintText: "Email or Username",
              onChanged: (value) {},
            ),
            SquarePasswordField(
              onChanged: (value) {},
            ),
            SquareButton(
              text: "Sign",
              press: () {},
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
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
