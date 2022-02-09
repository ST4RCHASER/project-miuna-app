import 'package:flutter/material.dart';
import 'package:project_miuna/Screens/Login/login_screen.dart';
import 'package:project_miuna/Screens/Signup/components/background.dart';
import 'package:project_miuna/components/already_have_an_account_acheck.dart';
import 'package:project_miuna/components/drop_list_model.dart';
import 'package:project_miuna/components/select_drop_list.dart';
import 'package:project_miuna/components/square_button.dart';
import 'package:project_miuna/components/square_input_field.dart';
import 'package:project_miuna/components/square_password_field.dart';
import 'package:project_miuna/components/sub_head_text.dart';
import 'package:project_miuna/components/head_text.dart';
import 'package:project_miuna/components/text_field_container.dart';
import 'package:project_miuna/utils/rest.dart' as rest;
import 'package:project_miuna/main.dart' as app;

class BodyStateing extends StatefulWidget {
  @override
  Body createState() => Body();
}

class Body extends State<BodyStateing> {
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController cfmPasswordController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController secController = new TextEditingController();
  TextEditingController studentIDController = new TextEditingController();
  DropListModel dropListModel = new DropListModel([
    OptionItem(id: "1", title: 'เทคโนโลยีมัลติมีเดีย'),
    OptionItem(id: "2", title: 'เทคโนโลยีสารสนเทศ'),
    OptionItem(id: "3", title: 'นวัตกรรมวัสดุเพื่ออุตสาหกรรม'),
    OptionItem(id: "4", title: 'วิทยาการการจัดการข้อมูล'),
    OptionItem(id: "5", title: 'วิทยาการคอมพิวเตอร์'),
    OptionItem(id: "6", title: 'เทคโนโลยีดิจิทัลมีเดีย'),
  ]);
  OptionItem optionItemSelected =
      new OptionItem(id: "1", title: 'เทคโนโลยีมัลติมีเดีย');
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
                  if (usernameController.text.length < 5)
                    return 'Username must be at least 5 characters';
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
                  if (passwordController.text.length < 6)
                    return 'Password must be at least 6 characters';
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
            SquareInputField(
                hintText: "Name and Surname",
                onChanged: (value) {},
                controller: nameController,
                validator: (String value) {
                  if (nameController.text == null ||
                      nameController.text.length < 1)
                    return 'Please enter your name and sirname';
                  if (nameController.text.length < 10)
                    return 'Name and surname must be at least 10 characters';
                  return null;
                }),
            TextFieldContainer(
              child: SelectDropList(
                this.optionItemSelected,
                this.dropListModel,
                (optionItem) {
                  optionItemSelected = optionItem;
                  this.setState(() {});
                },
              ),
            ),
            SquareInputField(
                hintText: "SEC Group",
                onChanged: (value) {},
                controller: secController,
                validator: (String value) {
                  if (secController.text == null ||
                      secController.text.length < 1)
                    return 'Please enter your SEC Group';
                  if (secController.text.length < 9)
                    return 'SEC Group must be at least 9 characters';
                  return null;
                }),
            SquareInputField(
                hintText: "Student ID",
                onChanged: (value) {},
                controller: studentIDController,
                validator: (String value) {
                  if (studentIDController.text == null ||
                      studentIDController.text.length < 1)
                    return 'Please enter your student id';
                  if (studentIDController.text.length < 12)
                    return 'Student id must be at 12 characters';
                  return null;
                }),
            SquareButton(
              text: "Register Now",
              press: () {
                if (_formKey.currentState.validate()) {
                  rest
                      .registerNewAccount(
                          emailController.text,
                          usernameController.text,
                          passwordController.text,
                          nameController.text,
                          secController.text,
                          studentIDController.text,
                          optionItemSelected.title)
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
