import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:requests/requests.dart';

import 'package:dio/dio.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> storeDataHive(String username, String password) async {
  // var box = await Hive.openBox("M3Portal");
  // box.clear();
  // box.put(username, password);
  final prefs = await SharedPreferences.getInstance();
  prefs.clear();
  prefs.setString(username, password);
}

Future<List<String>> getDataHive() async {
  final prefs = await SharedPreferences.getInstance();
  // var box = await Hive.openBox("M3Portal");
  // if (box.isEmpty) {
  //   return [];
  // } else {
  //   return [box.keys.first, box.values.first];
  // }
  if (prefs.getKeys().isEmpty) {
      return [];
    } else {
      return [prefs.getKeys().first, prefs.getString(prefs.getKeys().first) ?? ""];
    }
}

Future<bool> login(mail, password) async {
  var payload = {"user": mail, "pass": password};

  try {
    var dio = Dio();
    var b = await dio.post("https://bunnyportal.ts.r.appspot.com/login",
        data: payload);
    // print(b.headers);
    // print(b.data);
  } catch (e) {
    return false;
  }
  return true;
}

void fromJson(Map<String, dynamic> data) {}

Future<Map> MFA(mail, password, code) async {
  var payload = {"user": mail, "pass": password, "code": code};

  // try {
  //   var dio = Dio();
  //   var b = await dio.post("https://bunnyportal.ts.r.appspot.com/mfa", data: payload);
  //   print(b.data);
  //   //return json.decode(json.encode(b.data.toString()));
  //   Map<String, Map<String, String>> a = b.data;
  //   return a;
  // } catch (e) {
  //   return {"Something wrong" : {}};
  // }
  // print(b.headers);
  // print(b.data);

  try {
    var client = http.Client();
    var response = await client.post(
        Uri.parse("https://bunnyportal.ts.r.appspot.com/mfa"),
        body: jsonEncode(payload),
        headers: {'Content-Type': 'application/json'});
    //print(response.body);
    if (!response.success) {
      return {'error': 'error parsing'};
    }

    // var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    //
    // //print(decodedResponse["August"]);
    // Map<String, Map<String, String>> newMap = {};
    // Map<String, String> innerMap = {};
    // decodedResponse.forEach((key, value) {
    //   (jsonDecode(value) as Map).forEach((key, value) {
    //     innerMap[key.toString()] = value.toString();
    //   });
    //
    //
    //   newMap[key] = innerMap;
    // });
    // print(newMap);

    //     var a = {"August 2022":[{"day":1,"status":"NOT ROSTERED"},{"day":2,"status":"NOT ROSTERED"},{"day":3,"status":"NOT ROSTERED"},{"day":4,"status":"NOT ROSTERED"},{"day":5,"status":"NOT ROSTERED"},{"day":6,"status":"WEST IPSWICH WAREHOUSESPECIAL ORDERS 07:00 - 17:30"},{"day":7,"status":"WEST IPSWICH WAREHOUSESPECIAL ORDERS 07:00 - 17:30"},{"day":8,"status":"NOT ROSTERED"},{"day":9,"status":"NOT ROSTERED"},{"day":10,"status":"NOT ROSTERED"},{"day":11,"status":"NOT ROSTERED"},{"day":12,"status":"NOT ROSTERED"},{"day":13,"status":"WEST IPSWICH WAREHOUSESPECIAL ORDERS 08:00 - 18:30"},{"day":14,"status":"WEST IPSWICH WAREHOUSESPECIAL ORDERS 07:00 - 17:30"},{"day":15,"status":"NOT ROSTERED"},{"day":16,"status":"NOT ROSTERED"},{"day":17,"status":"NOT ROSTERED"},{"day":18,"status":"NOT ROSTERED"},{"day":19,"status":"NOT ROSTERED"},{"day":20,"status":"WEST IPSWICH WAREHOUSESPECIAL ORDERS 08:00 - 18:30"},{"day":21,"status":"WEST IPSWICH WAREHOUSESPECIAL ORDERS 08:00 - 18:30"},{"day":22,"status":"NOT ROSTERED"},{"day":23,"status":"NOT ROSTERED"},{"day":24,"status":"WEST IPSWICH WAREHOUSEPAINT 06:00 - 16:30"},{"day":25,"status":"NOT ROSTERED"},{"day":26,"status":"NOT ROSTERED"},{"day":27,"status":"WEST IPSWICH WAREHOUSEPAINT 07:00 - 17:30"},{"day":28,"status":"NOT ROSTERED"},{"day":29,"status":"NOT ROSTERED"},{"day":30,"status":"NOT ROSTERED"},{"day":31,"status":"NOT ROSTERED"}]};
    //
    // print(a);
    // print(jsonDecode(response.body)["August 2022"]);
    // print((jsonDecode(response.body)["August 2022"]).toList());
    // (jsonDecode(response.body)["August 2022"]).toList().forEach((date)
    //   {
    //     print(date["day"]);
    //     print(date["status"]);
    //   }
    // );

    return jsonDecode(response.body) as Map;
  } catch (e) {
    return {'error': 'error parsing'};
  }
}

Map getData3() {
  var jsonss =
      '{August: {"1": "NOT ROSTERED", "2": "NOT ROSTERED", "3": "NOT ROSTERED", "4": "NOT ROSTERED", "5": "NOT ROSTERED", "6": "WEST IPSWICH WAREHOUSESPECIAL ORDERS 07:00 - 17:30", "7": "WEST IPSWICH WAREHOUSESPECIAL ORDERS 07:00 - 17:30", "8": "NOT ROSTERED", "9": "NOT ROSTERED", "10": "NOT ROSTERED", "11": "NOT ROSTERED", "12": "NOT ROSTERED", "13": "WEST IPSWICH WAREHOUSESPECIAL ORDERS 08:00 - 18:30", "14": "WEST IPSWICH WAREHOUSESPECIAL ORDERS 07:00 - 17:30", "15": "NOT ROSTERED", "16": "NOT ROSTERED", "17": "NOT ROSTERED", "18": "NOT ROSTERED", "19": "NOT ROSTERED", "20": "WEST IPSWICH WAREHOUSESPECIAL ORDERS 08:00 - 18:30", "21": "WEST IPSWICH WAREHOUSESPECIAL ORDERS 08:00 - 18:30", "22": "NOT ROSTERED", "23": "NOT ROSTERED", "24": "WEST IPSWICH WAREHOUSEPAINT 06:00 - 16:30", "25": "NOT ROSTERED", "26": "NOT ROSTERED", "27": "WEST IPSWICH WAREHOUSEPAINT 07:00 - 17:30", "28": "NOT ROSTERED", "29": "NOT ROSTERED", "30": "NOT ROSTERED", "31": "NOT ROSTERED"}, September: {"1": "NOT ROSTERED", "2": "NOT ROSTERED", "3": "WEST IPSWICH WAREHOUSEPAINT 07:00 - 17:30", "4": "WEST IPSWICH WAREHOUSEPAINT 07:00 - 17:30", "5": "NOT ROSTERED", "6": "NOT ROSTERED", "7": "NOT ROSTERED", "8": "NOT ROSTERED", "9": "NOT ROSTERED", "10": "NOT ROSTERED", "11": "NOT ROSTERED", "12": "NOT ROSTERED", "13": "NOT ROSTERED", "14": "NOT ROSTERED", "15": "NOT ROSTERED", "16": "NOT ROSTERED", "17": "NOT ROSTERED", "18": "NOT ROSTERED", "19": "NOT ROSTERED", "20": "NOT ROSTERED", "21": "NOT ROSTERED", "22": "NOT ROSTERED", "23": "NOT ROSTERED", "24": "NOT ROSTERED", "25": "NOT ROSTERED", "26": "NOT ROSTERED", "27": "NOT ROSTERED", "28": "NOT ROSTERED", "29": "NOT ROSTERED", "30": "NOT ROSTERED"}, year: 2022}';
  var jss =
      '{"August 2022":[{"day":1,"status":"NOT ROSTERED"},{"day":2,"status":"NOT ROSTERED"},{"day":3,"status":"NOT ROSTERED"},{"day":4,"status":"NOT ROSTERED"},{"day":5,"status":"NOT ROSTERED"},{"day":6,"status":"WEST IPSWICH WAREHOUSESPECIAL ORDERS 07:00 - 17:30"},{"day":7,"status":"WEST IPSWICH WAREHOUSESPECIAL ORDERS 07:00 - 17:30"},{"day":8,"status":"NOT ROSTERED"},{"day":9,"status":"NOT ROSTERED"},{"day":10,"status":"NOT ROSTERED"},{"day":11,"status":"NOT ROSTERED"},{"day":12,"status":"NOT ROSTERED"},{"day":13,"status":"WEST IPSWICH WAREHOUSESPECIAL ORDERS 08:00 - 18:30"},{"day":14,"status":"WEST IPSWICH WAREHOUSESPECIAL ORDERS 07:00 - 17:30"},{"day":15,"status":"NOT ROSTERED"},{"day":16,"status":"NOT ROSTERED"},{"day":17,"status":"NOT ROSTERED"},{"day":18,"status":"NOT ROSTERED"},{"day":19,"status":"NOT ROSTERED"},{"day":20,"status":"WEST IPSWICH WAREHOUSESPECIAL ORDERS 08:00 - 18:30"},{"day":21,"status":"WEST IPSWICH WAREHOUSESPECIAL ORDERS 08:00 - 18:30"},{"day":22,"status":"NOT ROSTERED"},{"day":23,"status":"NOT ROSTERED"},{"day":24,"status":"WEST IPSWICH WAREHOUSEPAINT 06:00 - 16:30"},{"day":25,"status":"NOT ROSTERED"},{"day":26,"status":"NOT ROSTERED"},{"day":27,"status":"WEST IPSWICH WAREHOUSEPAINT 07:00 - 17:30"},{"day":28,"status":"NOT ROSTERED"},{"day":29,"status":"NOT ROSTERED"},{"day":30,"status":"NOT ROSTERED"},{"day":31,"status":"NOT ROSTERED"}],"September 2022":[{"day":1,"status":"NOT ROSTERED"},{"day":2,"status":"NOT ROSTERED"},{"day":3,"status":"WEST IPSWICH WAREHOUSEPAINT 07:00 - 17:30"},{"day":4,"status":"WEST IPSWICH WAREHOUSEPAINT 07:00 - 17:30"},{"day":5,"status":"NOT ROSTERED"},{"day":6,"status":"NOT ROSTERED"},{"day":7,"status":"NOT ROSTERED"},{"day":8,"status":"NOT ROSTERED"},{"day":9,"status":"NOT ROSTERED"},{"day":10,"status":"NOT ROSTERED"},{"day":11,"status":"NOT ROSTERED"},{"day":12,"status":"NOT ROSTERED"},{"day":13,"status":"NOT ROSTERED"},{"day":14,"status":"NOT ROSTERED"},{"day":15,"status":"NOT ROSTERED"},{"day":16,"status":"NOT ROSTERED"},{"day":17,"status":"NOT ROSTERED"},{"day":18,"status":"NOT ROSTERED"},{"day":19,"status":"NOT ROSTERED"},{"day":20,"status":"NOT ROSTERED"},{"day":21,"status":"NOT ROSTERED"},{"day":22,"status":"NOT ROSTERED"},{"day":23,"status":"NOT ROSTERED"},{"day":24,"status":"NOT ROSTERED"},{"day":25,"status":"NOT ROSTERED"},{"day":26,"status":"NOT ROSTERED"},{"day":27,"status":"NOT ROSTERED"},{"day":28,"status":"NOT ROSTERED"},{"day":29,"status":"NOT ROSTERED"},{"day":30,"status":"NOT ROSTERED"}]}';

  return jsonDecode(jss) as Map;
}

void getData2() {
  var jsonn = {
    '8/2022': {
      "1": "NOT ROSTERED",
      "2": "NOT ROSTERED",
      "3": "NOT ROSTERED",
      "4": "NOT ROSTERED",
      "5": "NOT ROSTERED",
      "6": "WEST IPSWICH WAREHOUSESPECIAL ORDERS 07:00 - 17:30",
      "7": "WEST IPSWICH WAREHOUSESPECIAL ORDERS 07:00 - 17:30",
      "8": "NOT ROSTERED",
      "9": "NOT ROSTERED",
      "10": "NOT ROSTERED",
      "11": "NOT ROSTERED",
      "12": "NOT ROSTERED",
      "13": "WEST IPSWICH WAREHOUSESPECIAL ORDERS 07:00 - 17:30",
      "14": "WEST IPSWICH WAREHOUSESPECIAL ORDERS 07:00 - 17:30",
      "15": "NOT ROSTERED",
      "16": "NOT ROSTERED",
      "17": "NOT ROSTERED",
      "18": "NOT ROSTERED",
      "19": "NOT ROSTERED",
      "20": "WEST IPSWICH WAREHOUSESPECIAL ORDERS 08:00 - 18:30",
      "21": "WEST IPSWICH WAREHOUSESPECIAL ORDERS 08:00 - 18:30",
      "22": "NOT ROSTERED",
      "23": "NOT ROSTERED",
      "24": "WEST IPSWICH WAREHOUSEPAINT 06:00 - 16:30",
      "25": "NOT ROSTERED",
      "26": "NOT ROSTERED",
      "27": "WEST IPSWICH WAREHOUSEPAINT 07:00 - 17:30",
      "28": "NOT ROSTERED",
      "29": "NOT ROSTERED",
      "30": "NOT ROSTERED",
      "31": "NOT ROSTERED"
    },
    '9/2022': {
      "1": "NOT ROSTERED",
      "2": "NOT ROSTERED",
      "3": "WEST IPSWICH WAREHOUSEPAINT 07:00 - 17:30",
      "4": "WEST IPSWICH WAREHOUSEPAINT 07:00 - 17:30",
      "5": "NOT ROSTERED",
      "6": "NOT ROSTERED",
      "7": "NOT ROSTERED",
      "8": "NOT ROSTERED",
      "9": "NOT ROSTERED",
      "10": "NOT ROSTERED",
      "11": "NOT ROSTERED",
      "12": "NOT ROSTERED",
      "13": "NOT ROSTERED",
      "14": "NOT ROSTERED",
      "15": "NOT ROSTERED",
      "16": "NOT ROSTERED",
      "17": "NOT ROSTERED",
      "18": "NOT ROSTERED",
      "19": "NOT ROSTERED",
      "20": "NOT ROSTERED",
      "21": "NOT ROSTERED",
      "22": "NOT ROSTERED",
      "23": "NOT ROSTERED",
      "24": "NOT ROSTERED",
      "25": "NOT ROSTERED",
      "26": "NOT ROSTERED",
      "27": "NOT ROSTERED",
      "28": "NOT ROSTERED",
      "29": "NOT ROSTERED",
      "30": "NOT ROSTERED"
    }
  };
  //json.decode(jsonn.toString());
  print(json.encode(jsonn));
}

Map<String, Map<String, String>> getData() {
  var jsonn = {
    '08/2022': {
      "1": "NOT ROSTERED",
      "2": "NOT ROSTERED",
      "3": "NOT ROSTERED",
      "4": "NOT ROSTERED",
      "5": "NOT ROSTERED",
      "6": "WEST IPSWICH WAREHOUSESPECIAL ORDERS 07:00 - 17:30",
      "7": "WEST IPSWICH WAREHOUSESPECIAL ORDERS 07:00 - 17:30",
      "8": "NOT ROSTERED",
      "9": "NOT ROSTERED",
      "10": "NOT ROSTERED",
      "11": "NOT ROSTERED",
      "12": "NOT ROSTERED",
      "13": "WEST IPSWICH WAREHOUSESPECIAL ORDERS 07:00 - 17:30",
      "14": "WEST IPSWICH WAREHOUSESPECIAL ORDERS 07:00 - 17:30",
      "15": "NOT ROSTERED",
      "16": "NOT ROSTERED",
      "17": "NOT ROSTERED",
      "18": "NOT ROSTERED",
      "19": "NOT ROSTERED",
      "20": "WEST IPSWICH WAREHOUSESPECIAL ORDERS 08:00 - 18:30",
      "21": "WEST IPSWICH WAREHOUSESPECIAL ORDERS 08:00 - 18:30",
      "22": "NOT ROSTERED",
      "23": "NOT ROSTERED",
      "24": "WEST IPSWICH WAREHOUSEPAINT 06:00 - 16:30",
      "25": "NOT ROSTERED",
      "26": "NOT ROSTERED",
      "27": "WEST IPSWICH WAREHOUSEPAINT 07:00 - 17:30",
      "28": "NOT ROSTERED",
      "29": "NOT ROSTERED",
      "30": "NOT ROSTERED",
      "31": "NOT ROSTERED"
    },
    '09/2022': {
      "1": "NOT ROSTERED",
      "2": "NOT ROSTERED",
      "3": "WEST IPSWICH WAREHOUSEPAINT 07:00 - 17:30",
      "4": "WEST IPSWICH WAREHOUSEPAINT 07:00 - 17:30",
      "5": "NOT ROSTERED",
      "6": "NOT ROSTERED",
      "7": "NOT ROSTERED",
      "8": "NOT ROSTERED",
      "9": "NOT ROSTERED",
      "10": "NOT ROSTERED",
      "11": "NOT ROSTERED",
      "12": "NOT ROSTERED",
      "13": "NOT ROSTERED",
      "14": "NOT ROSTERED",
      "15": "NOT ROSTERED",
      "16": "NOT ROSTERED",
      "17": "NOT ROSTERED",
      "18": "NOT ROSTERED",
      "19": "NOT ROSTERED",
      "20": "NOT ROSTERED",
      "21": "NOT ROSTERED",
      "22": "NOT ROSTERED",
      "23": "NOT ROSTERED",
      "24": "NOT ROSTERED",
      "25": "NOT ROSTERED",
      "26": "NOT ROSTERED",
      "27": "NOT ROSTERED",
      "28": "NOT ROSTERED",
      "29": "NOT ROSTERED",
      "30": "NOT ROSTERED"
    }
  };
  return jsonn;
}

// This is where the app starts executing.
Future<void> main() async {
  // await login(mail, pass);
  // print("Enter your code?");
  // String? code = stdin.readLineSync();
  // var MFA_session = MFA(mail, pass, code);

  var data = 'August 2022'.split(' ');
  print(data[0]);
  print(data[1]);

  // getData2();

  // print(getData3());
  // String a = json.encode(getData3());
  // print(json.decode(a));

  // File('lib/424376.html').readAsString().then((String value) {
  //   //print(value);
  //
  //   var document = parse(
  //     value
  //   );
  //   print(document.outerHtml);
  // });
}
