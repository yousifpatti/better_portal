import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:requests/requests.dart';

import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';


void login(mail, password) async {
  // var s = http.Client();
  // var res = await s.get(Uri.parse("https://teamportal.bunnings.com.au/"));
  // //print(res.body);

  // HttpClient s = new HttpClient();
  // HttpClientRequest request = await s.getUrl(Uri.parse("https://teamportal.bunnings.com.au/"));
  // HttpClientResponse response = await request.close();
  // var s = http.Client();
  // final headers = {HttpHeaders.contentTypeHeader: 'text/plain'};
  // final response = await s.get(Uri.parse("https://teamportal.bunnings.com.au/"), headers: headers);
  // //print(response.body);
  // return s;

  var payload = {
    "username": mail,
    "password": password,
    "vhost": 'standard'
  };

  String payload2 = "username=&password=&vhost=standard";

  var dio =  Dio();
  var cookieJar=CookieJar();
  dio.interceptors.add(CookieManager(cookieJar));


  var s = await dio.get("https://teamportal.bunnings.com.au/");
  print(s.headers);

  var b = await dio.post("https://teamportal.bunnings.com.au/my.policy", data: FormData.fromMap(payload), options: Options(
      followRedirects: false,
      validateStatus: (status) { return status! < 500; }
  ),);
  print(b.headers);

  // var b = await dio.request("https://teamportal.bunnings.com.au/my.policy?username=&password=&vhost=standard", options: Options(contentType: ContentType.parse("text/plain").toString()));
  // print(b);


  // var s = Session();
  // var res = await s.get("https://teamportal.bunnings.com.au/");
  // print(res.headers);
  //
  // var res2 = await s.post("https://teamportal.bunnings.com.au/my.policy", payload2);
  // print(res2.headers);
  // print(res2.body);
  // exit(0);


  // var s = await Requests.get("https://teamportal.bunnings.com.au/");
  // print(s.body);
  // print(s.headers);
  //
  // Requests.setStoredCookies("https://teamportal.bunnings.com.au/my.policy", Requests.extractResponseCookies(s.headers));
  //
  // var b = await Requests.post("https://teamportal.bunnings.com.au/my.policy", queryParameters: payload, headers: {'cookie': s.headers['set-cookie'] ?? ''});
  // print(s.body);
  // print(s.headers);




  // var s = await Requests.get("https://teamportal.bunnings.com.au/");
  //String payload = "username=&password=&vhost=standard";

  // print(Requests.extractResponseCookies(s.headers));
  // Requests.setStoredCookies(mail, Requests.extractResponseCookies(s.headers));

  
  // var b = await Requests.post('https://teamportal.bunnings.com.au/my.policy', headers: <String, String> {'Content-Type' : 'text/plain', 'cookie' : Requests.getStoredCookies(mail).toString()}, body: json.encode(payload), bodyEncoding: RequestBodyEncoding.PlainText);
  // print(b.body);

}


// Future<http.Client> login(String mail, String password) async {
//   // http.Client s = await open_session();
//   //HttpClient httpClient = await open_session();
//   // var payload = {
//   //   "username": mail, "password": password, "vhost": "standard"
//   // };
//
//   var payload = "username: $mail, password: $password, vhost: standard";
//
//   // var res = await s.post(Uri.parse("https://teamportal.bunnings.com.au/my.policy"),
//   // headers: <String, String> {'Content-Type' : 'text/plain; charset=utf-8',},
//   // body: utf8.encode(payload)
//   // );
//   //print(res.body);
//
//
//
//   // HttpClientRequest request = await httpClient.postUrl(Uri.parse("https://teamportal.bunnings.com.au/my.policy"));
//   // request.headers.set('Content-type', 'text/plain');
//   // request.add(utf8.encode(payload));
//   // HttpClientResponse response = await request.close();
//   // String reply = await response.transform(utf8.decoder).join();
//   // print(reply);
//   //
//   // httpClient.close();
//
//   var client = await open_session();
//   final headers = {HttpHeaders.contentTypeHeader: 'text/plain'};
//   // var payload = {
//   //   "username": mail, "password": password, "vhost": "standard"
//   // };
//   final response = await client.post(Uri.parse("https://teamportal.bunnings.com.au/my.policy"), headers: headers, body: payload);
//   print(response.body);
//
//
//   return client;
// }


// Future<http.Client> MFA(Future<http.Client> s) async {
//   http.Client s = await open_session();
//   print("Enter MFA key: ");
//   String? mfaKey = stdin.readLineSync() ?? "";
//   var payload = "_F5_challenge: $mfaKey, vhost: standard";
//
//   var res = await s.post(Uri.parse("https://teamportal.bunnings.com.au/my.policy"),
//       headers: <String, String> {'Content-Type' : 'text/plain; charset=utf-8',},
//       body: utf8.encode(payload));
//   print(res.body);
//   return s;
// }






// This is where the app starts executing.
void main() {
  login("", "");
  //var MFA_session = MFA(session);

}

class Session {
  Map<String, String> headers = {};

  Future<http.Response> get(String url) async {
    http.Response response = await http.get(Uri.parse(url), headers: headers);
    updateCookie(response);
    return response;
  }

  Future<http.Response> post(String url, dynamic data) async {
    http.Response response = await http.post(Uri.parse(url), body: data, headers: headers);
    updateCookie(response);
    return response;
  }

  void updateCookie(http.Response response) {
    headers['Content-Type'] = 'text/html';
    String? rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      headers['cookie'] =
      (index == -1) ? rawCookie : rawCookie.substring(0, index);
    }
  }
}