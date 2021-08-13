import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/io_client.dart' as http;
import 'package:project_miuna/utils/config.dart' as config;
import 'dart:convert' as convert;

authenticateAccount(String email, String password) async {
  try {
    final http.Response response = await http.post(Uri.parse(config.miunaURL + 'auth'),
        headers: {
          'Accept': 'application/json',
          'authorization': 'pass your key(optional)'
        },
        body: {
          "email": email,
          "password": password
        });
    if (response.statusCode != 200) {
      var obj = convert.jsonDecode(response.body);
      return new restResponse(
          success: false, message: obj.message, response: response);
    } else {
      return new restResponse(
          success: true, message: 'Request success', response: response);
    }
  } on SocketException {
    return new restResponse(
          success: false, message: 'Failed to connect to server, please check your internet connection', response: null);
  }catch (e) {
    return new restResponse(
        success: false, message: 'Unknown error!', response: e);
  }
}

registerNewAccount(String email, String username, String password) {
  return http.post(Uri.parse(config.miunaURL + 'register'), headers: {
    'Accept': 'application/json',
  }, body: {
    "email": email,
    "username": username,
    "password": password
  });
}

class restResponse {
  final bool success;
  final String message;
  final dynamic response;
  restResponse({bool success, String message, dynamic response})
      : this.success = success,
        this.message = message,
        this.response = response;
}
