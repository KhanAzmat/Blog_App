import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class NetworkHandler {
  String baseUrl = "http://192.168.29.163:5000";
  var log = Logger();
  FlutterSecureStorage storage = FlutterSecureStorage();

  Future get(String url) async {
    // /user/register
    String token = await storage.read(key: "token");
    url = formatter(url);
    log.i("$token");
    var response = await http.get(url, headers: {"Authorization": "$token"});
    if (response.statusCode == 200 || response.statusCode == 201) {
      log.i(response.body);
      return json.decode(response.body);
    }
    log.i(response.body);
    log.i(response.statusCode);
  }

  Future<http.Response> post(String url, Map<String, String> body) async {
    String token = await storage.read(key: "token");
    log.i(token);
    url = formatter(url);
    log.d(body);
    log.d(json.encode(body));
    var response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "$token"
        },
        body: json.encode(body));

    return response;
  }

  Future<http.Response> patch(String url, Map<String, String> body) async {
    String token = await storage.read(key: "token");
    log.i(token);
    url = formatter(url);
    log.d(body);
    log.d(json.encode(body));
    var response = await http.patch(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "$token"
        },
        body: json.encode(body));

    return response;
  }

  Future<http.Response> post1(String url, var body) async {
    String token = await storage.read(key: "token");
    log.i(token);
    url = formatter(url);
    log.d(body);
    log.d(json.encode(body));
    var response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "$token"
        },
        body: json.encode(body));

    return response;
  }

  Future<http.StreamedResponse> patchImage(String url, String filePath) async {
    url = formatter(url);
    String token = await storage.read(key: "token");
    var request = http.MultipartRequest('PATCH', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath("img", filePath));
    request.headers.addAll({
      "Content-Type": "multipart/form-data",
      "Authorization": "$token",
    });
    var response = request.send();
    return response;
  }

  String formatter(String url) {
    return baseUrl + url;
  }

  NetworkImage getImage(String imgName) {
    String url = formatter("/uploads/$imgName.jpg");
    return NetworkImage(url);
  }
}
