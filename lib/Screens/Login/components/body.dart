import 'package:flutter/material.dart';
import 'package:project_miuna/Screens/Login/components/background.dart';
import 'package:project_miuna/Screens/Home/home_screen.dart';
import 'package:project_miuna/Screens/Signup/signup_screen.dart';
import 'package:project_miuna/components/already_have_an_account_acheck.dart';
import 'package:project_miuna/components/square_button.dart';
import 'package:project_miuna/components/square_input_field.dart';
import 'package:project_miuna/components/square_password_field.dart';
import 'package:flutter_svg/svg.dart';
import 'package:project_miuna/utils/rest.dart' as rest;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final KVStorage = new FlutterSecureStorage();

class Body extends StatelessWidget {
  // const Body({
  //   Key key,
  // }) : super(key: key);
  GlobalKey<FormState> _formLoginKey = new GlobalKey<FormState>();
  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
          child: Form(
              key: _formLoginKey,
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
                      controller: usernameController,
                      hintText: "Email or Username",
                      onChanged: (value) {},
                      validator: (String value) {
                        if (usernameController.text == null ||
                            usernameController.text.length < 1)
                          return 'Please enter your username or email address';
                        if (usernameController.text.length < 5)
                          return 'Username or Email must be at least 5 characters';
                        return null;
                      }),
                  SquarePasswordField(
                      controller: passwordController,
                      onChanged: (value) {},
                      validator: (String value) {
                        if (passwordController.text == null ||
                            passwordController.text.length < 1)
                          return 'Please enter your password';
                        if (passwordController.text.length < 6)
                          return 'Password must be at least 6 characters';
                        return null;
                      }),
                  SquareButton(
                    text: "Sign",
                    press: () {
                      if (_formLoginKey.currentState.validate()) {
                        rest
                            .authenticateAccount(usernameController.text,
                                passwordController.text)
                            .then((result) => {
                                  if (result.success)
                                    {
                                      KVStorage.write(
                                          key: 'token', value: result.content),
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return HomeScreen();
                                          },
                                        ),
                                      )
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
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context, 'OK'),
                                                      child: const Text('OK'),
                                                    ),
                                                  ]))
                                    }
                                });
                      }
                    },
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
              ))),
    );
  }
}
