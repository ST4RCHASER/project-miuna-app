import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/io_client.dart' as http;
import 'package:project_miuna/utils/config.dart' as config;
import 'dart:convert' as convert;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
final KVStorage = new FlutterSecureStorage();
Future<RESTResp> authenticateAccount(String email, String password) async {
  try {
    var token = await KVStorage.read(key: "token");
    print('Current Auth Token:');
    print(token);
    if(token == null) token = '';
    http.Response resp = await http.post(
        Uri.parse(config.miunaURL + "/account/auth"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ' + token
        },
        body: convert.jsonEncode(<String, dynamic>{
          "email": email,
          "username": email,
          "password": password
        }));
    var decoded = convert.jsonDecode(resp.body);
    var body = RESTResp(decoded);
    return body;
  } on SocketException {
    return RESTResp({
      'success': false,
      'message':
          'Failed to connect to server, please check your internet connection',
      'statusCode': -1
    });
  } catch (e) {
    print(e);
    return RESTResp(
        {'success': false, 'message': 'Unknown error!', 'statusCode': -1});
  }
}

Future<RESTResp> registerNewAccount(
    String email, String username, String password) async {
  try {
    http.Response resp = await http.post(
        Uri.parse(config.miunaURL + "/account/reg"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: convert.jsonEncode(<String, String>{
          "email": email,
          "username": username,
          "password": password
        }));
    var decoded = convert.jsonDecode(resp.body);
    var body = RESTResp(decoded);
    return body;
  } on SocketException {
    return RESTResp({
      'success': false,
      'message':
          'Failed to connect to server, please check your internet connection',
      'statusCode': -1
    });
  } catch (e) {
    return RESTResp(
        {'success': false, 'message': 'Unknown error!', 'statusCode': -1});
  }
}

class RESTResp {
  bool success;
  int statusCode;
  String message;
  dynamic content;
  RESTResp(Map<String, dynamic> data) {
    success = data['success'];
    statusCode = data['statusCode'];
    message = data['message'];
    content = data['content'];
  }
}

class restResponse {
  final bool success;
  final String message;
  final http.Response response;
  restResponse({bool success, String message, dynamic response})
      : this.success = success,
        this.message = message,
        this.response = response;
}
