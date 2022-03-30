import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart' as http;
import 'package:project_miuna/utils/config.dart' as config;
import 'dart:convert' as convert;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final KVStorage = new FlutterSecureStorage();

Future<void> updateInfomationToKVStorage() async {
  final client = new http.IOClient();
  final url = Uri.parse(config.miunaURL + "account/info");
  final response = await client.get(url, headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ' + await KVStorage.read(key: 'token')
  });
  final responseJson = convert.jsonDecode(response.body);
  var body = UserInfoREST.fromJson(responseJson);
  print('Pulling data to KV...');
  if (body.success) {
    KVStorage.write(key: 'id', value: body.content.id);
    KVStorage.write(key: 'email', value: body.content.email);
    KVStorage.write(key: 'username', value: body.content.username);
    KVStorage.write(key: 'lowerUsername', value: body.content.lowerUsername);
    KVStorage.write(key: 'name', value: body.content.name);
    KVStorage.write(key: 'sec', value: body.content.sec);
    KVStorage.write(key: 'student_id', value: body.content.studentId);
    KVStorage.write(key: 'class', value: body.content.class_.toString());
    KVStorage.write(key: 'major', value: body.content.major);
    KVStorage.write(key: 'created', value: body.content.created);
  }
}

Future<RESTResp> updateInfomation(
    {username: '',
    email: '',
    password: '',
    name: '',
    sec: '',
    student_id: '',
    major: ''}) async {
  final client = new http.IOClient();
  final url = Uri.parse(config.miunaURL + "account/info");
  final resp = await client.post(url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + await KVStorage.read(key: 'token')
      },
      body: convert.jsonEncode(<String, dynamic>{
        "username": username,
        "email": email,
        "password": password,
        "name": name,
        "sec": sec,
        "student_id": student_id,
        "major": major
      }));
  print(resp.body);
  var decoded = convert.jsonDecode(resp.body);
  var body = RESTResp(decoded);
  return body;
}

Future<EventListRESTResp> getJoinedEventList() async {
  try {
    var token = await KVStorage.read(key: "token");
    print('Current Auth Token:');
    print(token);
    if (token == null) token = '';
    http.Response resp = await http.get(
        Uri.parse(config.miunaURL + "event/joined"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ' + token
        });
    print(resp.body);
    var decoded = convert.jsonDecode(resp.body);
    var body = EventListRESTResp.fromJson(decoded);
    return body;
  } on SocketException {
    return EventListRESTResp.fromJson(convert.jsonDecode(
        '{ "success": false, "message": "Failed to connect to server, please check your internet connection", "statusCode": -1}'));
  } catch (e) {
    print(e);
    return EventListRESTResp.fromJson(convert.jsonDecode(
        '{"success": false, "message": "Unknown error: " + e, "statusCode": -1}'));
  }
}

Future<RESTResp> joinEvent(String eventID) async {
  try {
    var token = await KVStorage.read(key: "token");
    print('Current Auth Token:');
    print(token);
    if (token == null) token = '';
    http.Response resp =
        await http.post(Uri.parse(config.miunaURL + "event/join"),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer ' + token
            },
            body: convert.jsonEncode(<String, dynamic>{
              "id": eventID,
            }));
    print(resp.body);
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
        {'success': false, 'message': 'Unknown error: ' + e, 'statusCode': -1});
  }
}

Future<RESTResp> leaveEvent(String eventID) async {
  try {
    var token = await KVStorage.read(key: "token");
    print('Current Auth Token:');
    print(token);
    if (token == null) token = '';
    http.Response resp =
        await http.post(Uri.parse(config.miunaURL + "event/leave"),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer ' + token
            },
            body: convert.jsonEncode(<String, dynamic>{
              "id": eventID,
            }));
    print(resp.body);
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
        {'success': false, 'message': 'Unknown error: ' + e, 'statusCode': -1});
  }
}

Future<RESTResp> authenticateAccount(String email, String password) async {
  try {
    var token = await KVStorage.read(key: "token");
    print('Current Auth Token:');
    print(token);
    if (token == null) token = '';
    http.Response resp = await http.post(
        Uri.parse(config.miunaURL + "account/auth"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ' + token
        },
        body: convert.jsonEncode(<String, dynamic>{
          "email": email,
          "username": email,
          "password": password
        }));
    print(resp.body);
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
        {'success': false, 'message': 'Unknown error: ' + e, 'statusCode': -1});
  }
}

Future<RESTResp> getEventInfo(String id, bool change) async {
  try {
    var token = await KVStorage.read(key: "token");
    print('Current Auth Token:');
    print(token);
    if (token == null) token = '';
    http.Response resp = await http.get(
        Uri.parse(config.miunaURL +
            "event/info/" +
            id +
            '?change=' +
            change.toString()),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ' + token
        });
    print(resp.body);
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
        {'success': false, 'message': 'Unknown error: ' + e, 'statusCode': -1});
  }
}

Future<RESTResp> registerNewAccount(
    String email,
    String username,
    String password,
    String name,
    String sec,
    String student_id,
    String major) async {
  try {
    http.Response resp =
        await http.post(Uri.parse(config.miunaURL + "account/reg"),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: convert.jsonEncode(<String, String>{
              "email": email,
              "username": username,
              "password": password,
              "name": name,
              "sec": sec,
              "student_id": student_id,
              "major": major
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

class UserInfoREST {
  bool success;
  int statusCode;
  String message;
  UserInfoContent content;

  UserInfoREST({this.success, this.statusCode, this.message, this.content});

  UserInfoREST.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['statusCode'];
    message = json['message'];
    content = json['content'] != null
        ? new UserInfoContent.fromJson(json['content'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.content != null) {
      data['content'] = this.content.toJson();
    }
    return data;
  }
}

class UserInfoContent {
  String id;
  String username;
  String lowerUsername;
  String email;
  String created;
  int class_;
  String major;
  String name;
  String sec;
  String studentId;

  UserInfoContent(
      {this.id,
      this.username,
      this.lowerUsername,
      this.email,
      this.created,
      this.class_,
      this.major,
      this.name,
      this.sec,
      this.studentId});

  UserInfoContent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    lowerUsername = json['lowerUsername'];
    email = json['email'];
    created = json['created'];
    class_ = json['class'];
    major = json['major'];
    name = json['name'];
    sec = json['sec'];
    studentId = json['student_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['lowerUsername'] = this.lowerUsername;
    data['email'] = this.email;
    data['created'] = this.created;
    data['class'] = this.class_;
    data['major'] = this.major;
    data['name'] = this.name;
    data['sec'] = this.sec;
    data['student_id'] = this.studentId;
    return data;
  }
}

class EventListRESTResp {
  bool success;
  int statusCode;
  String message;
  List<Content> content;

  EventListRESTResp(
      {this.success, this.statusCode, this.message, this.content});

  EventListRESTResp.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['content'] != null) {
      content = <Content>[];
      json['content'].forEach((v) {
        content.add(new Content.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    if (this.content != null) {
      data['content'] = this.content.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Content {
  Record record;
  Event event;
  EventOwner eventOwner;

  Content({this.record, this.event, this.eventOwner});

  Content.fromJson(Map<String, dynamic> json) {
    record =
        json['record'] != null ? new Record.fromJson(json['record']) : null;
    event = json['event'] != null ? new Event.fromJson(json['event']) : null;
    eventOwner = json['eventOwner'] != null
        ? new EventOwner.fromJson(json['eventOwner'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.record != null) {
      data['record'] = this.record.toJson();
    }
    if (this.event != null) {
      data['event'] = this.event.toJson();
    }
    if (this.eventOwner != null) {
      data['eventOwner'] = this.eventOwner.toJson();
    }
    return data;
  }
}

class Record {
  String sId;
  String ownerID;
  String eventID;
  String timeJoin;
  String timeLeave;
  String created;
  int iV;

  Record(
      {this.sId,
      this.ownerID,
      this.eventID,
      this.timeJoin,
      this.timeLeave,
      this.created,
      this.iV});

  Record.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    ownerID = json['ownerID'];
    eventID = json['eventID'];
    timeJoin = json['timeJoin'];
    timeLeave = json['timeLeave'];
    created = json['created'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['ownerID'] = this.ownerID;
    data['eventID'] = this.eventID;
    data['timeJoin'] = this.timeJoin;
    data['timeLeave'] = this.timeLeave;
    data['created'] = this.created;
    data['__v'] = this.iV;
    return data;
  }
}

class Event {
  String sId;
  String name;
  String ownerID;
  Time time;
  int state;
  int qrType;
  double loc_lat;
  double loc_lng;
  bool loc_check;
  String hash;
  String description;
  int iV;

  Event(
      {this.sId,
      this.name,
      this.ownerID,
      this.time,
      this.state,
      this.qrType,
      this.hash,
      this.loc_lat,
      this.loc_lng,
      this.loc_check,
      this.description,
      this.iV});

  Event.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    ownerID = json['ownerID'];
    time = json['time'] != null ? new Time.fromJson(json['time']) : null;
    state = json['state'];
    qrType = json['qrType'];
    hash = json['hash'];
    loc_lat = json['loc_lat'];
    loc_lng = json['loc_lng'];
    loc_check = json['loc_check'];
    description = json['description'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['ownerID'] = this.ownerID;
    if (this.time != null) {
      data['time'] = this.time.toJson();
    }
    data['loc_lat'] = this.loc_lat;
    data['loc_lng'] = this.loc_lng;
    data['loc_check'] = this.loc_check;
    data['state'] = this.state;
    data['qrType'] = this.qrType;
    data['hash'] = this.hash;
    data['description'] = this.description;
    data['__v'] = this.iV;
    return data;
  }
}

class Time {
  String created;
  String start;
  int end;

  Time({this.created, this.start, this.end});

  Time.fromJson(Map<String, dynamic> json) {
    created = json['created'];
    start = json['start'];
    end = json['end'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created'] = this.created;
    data['start'] = this.start;
    data['end'] = this.end;
    return data;
  }
}

class EventOwner {
  String sId;
  String email;
  String username;
  String lowerUsername;
  String password;
  String name;
  String sec;
  String studentId;
  int class_;
  String created;
  int iV;
  String major;

  EventOwner(
      {this.sId,
      this.email,
      this.username,
      this.lowerUsername,
      this.password,
      this.name,
      this.sec,
      this.studentId,
      this.class_,
      this.created,
      this.iV,
      this.major});

  EventOwner.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    email = json['email'];
    username = json['username'];
    lowerUsername = json['lowerUsername'];
    password = json['password'];
    name = json['name'];
    sec = json['sec'];
    studentId = json['student_id'];
    class_ = json['class'];
    created = json['created'];
    iV = json['__v'];
    major = json['major'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['email'] = this.email;
    data['username'] = this.username;
    data['lowerUsername'] = this.lowerUsername;
    data['password'] = this.password;
    data['name'] = this.name;
    data['sec'] = this.sec;
    data['student_id'] = this.studentId;
    data['class'] = this.class_;
    data['created'] = this.created;
    data['__v'] = this.iV;
    data['major'] = this.major;
    return data;
  }
}

getLocation() async {
  try {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied, Please allow them to join the event');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, Please allow them from settings before joining');
    }
    return Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  } catch (e) {
    print(e);
  }
}
