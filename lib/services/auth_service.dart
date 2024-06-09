import 'dart:convert' show json;

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {
  final String _baseUrl = 'identitytoolkit.googleapis.com';
  final String _firebaseToken = 'AIzaSyBlGEaILRtPJrwZUKXPuLCLaMiSnuJNhBU';

  final storage = FlutterSecureStorage();

  //Si devolmenos algo, es un error, si no, toco correcto
  Future<String?> createUser(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
    };

    final url =
        Uri.https(_baseUrl, '/v1/accounts:signUp', {'key': _firebaseToken});

    final resp = await http.post(url, body: json.encode(authData));

    final Map<String, dynamic> decodedResp = json.decode(resp.body);

    if (decodedResp.containsKey('idToken')) {
      //return decodedResp['idToken'];
      return null;
    } else {
      return decodedResp['error']['message'];
    }
  }

  Future<String?> login(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
    };

    final url = Uri.https(
        _baseUrl, '/v1/accounts:signInWithPassword', {'key': _firebaseToken});

    final resp = await http.post(url, body: json.encode(authData));

    final Map<String, dynamic> decodedResp = json.decode(resp.body);

    //print(resp.toString());

    if (decodedResp.containsKey('idToken')) {
      final idToken = decodedResp['idToken'];
      // Store the ID token
      await storage.write(key: 'idToken', value: idToken);

      //return decodedResp['idToken'];
      return null;
    } else {
      return decodedResp['error']['message'];
    }
  }

  Future<String?> getUserRole() async {
    final idToken = await storage.read(key: 'idToken');
    final url = Uri.parse(_baseUrl + '/v1/accounts:lookup');
    // ignore: unused_local_variable
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $idToken',
    });
    return null;
  }

  Future<void> sendPasswordResetEmail(String email) async {
    final Map<String, dynamic> authData = {
      'requestType': 'PASSWORD_RESET',
      'email': email,
    };

    final url = Uri.https(
        _baseUrl, '/v1/accounts:sendOobCode', {'key': _firebaseToken});

    final resp = await http.post(url, body: json.encode(authData));

    final Map<String, dynamic> decodedResp = json.decode(resp.body);

    if (decodedResp.containsKey('email')) {
      print('Email sent to ${decodedResp['email']}');
    } else {
      print(decodedResp['error']['message']);
    }
  }
}
