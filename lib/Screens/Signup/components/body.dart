import 'package:flutter/material.dart';
import 'package:project_miuna/Screens/Login/login_screen.dart';
import 'package:project_miuna/Screens/Signup/components/background.dart';
import 'package:project_miuna/components/already_have_an_account_acheck.dart';
import 'package:project_miuna/components/square_button.dart';
import 'package:project_miuna/components/square_input_field.dart';
import 'package:project_miuna/components/square_password_field.dart';
import 'package:project_miuna/components/sub_head_text.dart';
import 'package:project_miuna/components/head_text.dart';
import 'package:project_miuna/utils/rest.dart' as rest;

class Body extends StatelessWidget {
  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController cfmPasswordController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextHeader(
              child: Text(
                "Register new account",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
            ),
            SquareInputField(
              hintText: "Username",
              onChanged: (value) {},
              controller: usernameController,
            ),
            SquareInputField(
              hintText: "Email",
              onChanged: (value) {},
              controller: emailController,
              icon: Icons.email,
            ),
            SquarePasswordField(
              onChanged: (value) {},
              controller: passwordController,
            ),
            SquarePasswordField(
              hintText: "Confirm password",
              controller: cfmPasswordController,
              onChanged: (value) {},
            ),
            SquareButton(
              text: "Register Now",
              press: () {
                rest.authenticateAccount(
                    usernameController.text, passwordController.text).
                    then((result) => {
                      if (!result.success) {
                        print('Failed to connect to server: ' + result.message),
                      }else {
                        print('Success: ' + result.message),
                      }
                    });
              },
            ),
            AlreadyHaveAnAccountCheck(
              login: false,
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
          ],
        ),
      ),
    );
  }
}
