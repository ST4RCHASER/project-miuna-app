import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/io_client.dart' as http;
import 'package:project_miuna/utils/config.dart' as config;
import 'dart:convert' as convert;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final KVStorage = new FlutterSecureStorage();

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
    return EventListRESTResp.fromJson(convert.jsonDecode("{ 'success': false, 'message': 'Failed to connect to server, please check your internet connection', 'statusCode': -1}"));
  } catch (e) {
    print(e);
    return EventListRESTResp.fromJson(convert.jsonDecode("{'success': false, 'message': 'Unknown error: ' + e, 'statusCode': -1}"));
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

Future<RESTResp> getEventInfo(String id) async {
  try {
    var token = await KVStorage.read(key: "token");
    print('Current Auth Token:');
    print(token);
    if (token == null) token = '';
    http.Response resp = await http.get(
        Uri.parse(config.miunaURL + "event/info/" + id),
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
    String email, String username, String password) async {
  try {
    http.Response resp = await http.post(
        Uri.parse(config.miunaURL + "account/reg"),
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

class EventListRESTResp {
	bool success;
	int statusCode;
	String message;
	List<Content> content;

	EventListRESTResp({this.success, this.statusCode, this.message, this.content});

	EventListRESTResp.fromJson(Map<String, dynamic> json) {
		success = json['success'];
		statusCode = json['statusCode'];
		message = json['message'];
		if (json['content'] != null) {
			content = <Content>[];
			json['content'].forEach((v) { content.add(new Content.fromJson(v)); });
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
		record = json['record'] != null ? new Record.fromJson(json['record']) : null;
		event = json['event'] != null ? new Event.fromJson(json['event']) : null;
		eventOwner = json['eventOwner'] != null ? new EventOwner.fromJson(json['eventOwner']) : null;
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

	Record({this.sId, this.ownerID, this.eventID, this.timeJoin, this.timeLeave, this.created, this.iV});

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
	String description;
	int iV;

	Event({this.sId, this.name, this.ownerID, this.time, this.state, this.description, this.iV});

	Event.fromJson(Map<String, dynamic> json) {
		sId = json['_id'];
		name = json['name'];
		ownerID = json['ownerID'];
		time = json['time'] != null ? new Time.fromJson(json['time']) : null;
		state = json['state'];
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
		data['state'] = this.state;
		data['description'] = this.description;
		data['__v'] = this.iV;
		return data;
	}
}

class Time {
	int created;
	int start;
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
	int className;
	String created;
	int iV;

	EventOwner({this.sId, this.email, this.username, this.lowerUsername, this.password, this.className, this.created, this.iV});

	EventOwner.fromJson(Map<String, dynamic> json) {
		sId = json['_id'];
		email = json['email'];
		username = json['username'];
		lowerUsername = json['lowerUsername'];
		password = json['password'];
		className = json['class'];
		created = json['created'];
		iV = json['__v'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['_id'] = this.sId;
		data['email'] = this.email;
		data['username'] = this.username;
		data['lowerUsername'] = this.lowerUsername;
		data['password'] = this.password;
		data['class'] = this.className;
		data['created'] = this.created;
		data['__v'] = this.iV;
		return data;
	}
}
