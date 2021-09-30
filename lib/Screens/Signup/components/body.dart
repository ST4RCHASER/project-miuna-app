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
import 'package:project_miuna/main.dart' as app;

class Body extends StatelessWidget {
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController cfmPasswordController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView(
          child: Form(
        key: _formKey,
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
                validator: (String value) {
                  if (usernameController.text == null ||
                      usernameController.text.length < 1)
                    return 'Please enter your username';
                    if (usernameController.text.length < 5)return 'Username must be at least 5 characters';
                  return null;
                }),
            SquareInputField(
                hintText: "Email",
                onChanged: (value) {},
                controller: emailController,
                icon: Icons.email,
                validator: (String value) {
                  if (emailController.text == null ||
                      emailController.text.length < 1)
                    return 'Please enter your email address';
                  if (!RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(emailController.text))
                    return 'Please enter a valid email';
                  return null;
                }),
            SquarePasswordField(
                onChanged: (value) {},
                controller: passwordController,
                validator: (String value) {
                  if (passwordController.text == null ||
                      passwordController.text.length < 1)
                    return 'Please enter your password';
                  if (passwordController.text.length < 6)return 'Password must be at least 6 characters';
                  return null;
                }),
            SquarePasswordField(
                hintText: "Confirm password",
                controller: cfmPasswordController,
                onChanged: (value) {},
                validator: (String value) {
                  if (cfmPasswordController.text == null ||
                      cfmPasswordController.text.length < 1)
                    return 'Please enter your confirm password';
                  if (cfmPasswordController.text != passwordController.text)
                    return 'Confirm Password is not matching your password';
                  return null;
                }),
            SquareButton(
              text: "Register Now",
              press: () {
                if (_formKey.currentState.validate()) {
                  rest
                      .registerNewAccount(emailController.text,
                          usernameController.text, passwordController.text)
                      .then((result) => {
                            if (result.success)
                              {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                            title: const Text('Success'),
                                            content: Text(
                                                'Your account has been created successfully, click at OK button to go to login page'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () => {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) {
                                                        return LoginScreen();
                                                      },
                                                    ),
                                                  )
                                                },
                                                child: const Text('OK'),
                                              ),
                                            ]))
                              }
                            else
                              {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                            title: const Text('Error'),
                                            content: Text(result.message),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    context, 'OK'),
                                                child: const Text('OK'),
                                              ),
                                            ]))
                              }
                          });
                }
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
      )),
    );
  }
}
