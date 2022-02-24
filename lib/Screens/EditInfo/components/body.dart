import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:project_miuna/Screens/Home/components/background.dart';
import 'package:project_miuna/Screens/Home/components/event_card.dart';
import 'package:project_miuna/Screens/Home/components/menu_button.dart';
import 'package:project_miuna/Screens/Home/home_screen.dart';
import 'package:project_miuna/Screens/QRScan/qrscan_screen.dart';
import 'package:project_miuna/Screens/Welcome/welcome_screen.dart';
import 'package:project_miuna/components/drop_list_model.dart';
import 'package:project_miuna/components/head_text.dart';
import 'package:project_miuna/components/select_drop_list.dart';
import 'package:project_miuna/components/square_input_field.dart';
import 'package:project_miuna/components/text_field_container.dart';
import 'package:project_miuna/components/thematic_text.dart';
import 'package:project_miuna/constants.dart';
import 'package:project_miuna/utils/rest.dart' as rest;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:project_miuna/components/square_button.dart';
import 'package:niku/niku.dart';

final KVStorage = new FlutterSecureStorage();

class BodyStateing extends StatefulWidget {
  @override
  Body createState() => Body();
}

class Body extends State<BodyStateing> {
  TextEditingController nameController = new TextEditingController();
  TextEditingController secController = new TextEditingController();
  TextEditingController studentIDController = new TextEditingController();
  bool isSet = false;
  DropListModel dropListModel = new DropListModel([
    OptionItem(id: "1", title: 'เทคโนโลยีมัลติมีเดีย'),
    OptionItem(id: "2", title: 'เทคโนโลยีสารสนเทศ'),
    OptionItem(id: "3", title: 'นวัตกรรมวัสดุเพื่ออุตสาหกรรม'),
    OptionItem(id: "4", title: 'วิทยาการการจัดการข้อมูล'),
    OptionItem(id: "5", title: 'วิทยาการคอมพิวเตอร์'),
    OptionItem(id: "6", title: 'เทคโนโลยีดิจิทัลมีเดีย'),
  ]);
  OptionItem optionItemSelected =
      new OptionItem(id: "6", title: 'เทคโนโลยีดิจิทัลมีเดีย');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Set old data from KVStorage
    BuildContext _context = context;
    return FutureBuilder<String>(
      future: Future.wait([
        KVStorage.read(key: 'name'),
        KVStorage.read(key: 'student_id'),
        KVStorage.read(key: 'sec'),
        KVStorage.read(key: 'major'),
      ]).then((value) {
        if (!isSet) {
          print('=======================');
          print(value);
          nameController.text = value[0];
          studentIDController.text = value[1];
          secController.text = value[2];
          optionItemSelected = dropListModel.listOptionItems.firstWhere(
              (element) => element.title == value[3],
              orElse: () => dropListModel.listOptionItems.first);
        }
        isSet = true;
        return '';
      }),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Background(
            child: SingleChildScrollView(
              child: NikuColumn([
                NikuRow([
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
                    }),
                  NikuColumn([
                    Padding(
                        child: NikuText("Edit infomation")
                            .color(Colors.black)
                            .fontSize(32)
                            .fontWeight(FontWeight.bold),
                        padding: EdgeInsets.only(top: 10, bottom: 20)),
                  ]),
                ]),
                NikuColumn([
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
                        this.optionItemSelected = optionItem;
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
                    text: "Save",
                    press: () {
                      print('==============Save==============');
                      print(this.optionItemSelected.title);
                      rest
                          .updateInfomation(
                            name: nameController.text,
                            sec: secController.text,
                            student_id: studentIDController.text,
                            major: this.optionItemSelected.title,
                          )
                          .then((result) => {
                                if (result.success)
                                  {
                                    KVStorage.write(
                                        key: "name",
                                        value: nameController.text),
                                    KVStorage.write(
                                        key: "sec", value: secController.text),
                                    KVStorage.write(
                                        key: "student_id",
                                        value: studentIDController.text),
                                    KVStorage.write(
                                        key: "major",
                                        value: this.optionItemSelected.title),
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("Success"),
                                          content: Text("Infomation updated"),
                                          actions: <Widget>[
                                            FlatButton(
                                              child: Text("Close"),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                Navigator.of(_context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    )
                                  }
                                else
                                  {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("Error"),
                                          content: Text(result.message),
                                          actions: <Widget>[
                                            FlatButton(
                                              child: Text("Close"),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    )
                                  }
                              });
                    },
                  ),
                ]),
              ]),
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
