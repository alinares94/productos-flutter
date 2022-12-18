
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:productos/models/auth_response.dart';

class AuthService extends ChangeNotifier {

  static const String _baseUrl = 'identitytoolkit.googleapis.com';
  static const String _firebaseToken = 'AIzaSyCnVmaKjk1KoU87bgbbaUZoIowRbh7BB1Q';
  static const _storage = FlutterSecureStorage();
  Future<String?> login( String email, String pwd ) async {

    final Map<String, dynamic> data = {
      'email': email,
      'password': pwd,
      'returnSecureToken': true
    };

    final url = Uri.https(_baseUrl, '/v1/accounts:signInWithPassword', {
      'key': _firebaseToken
    });

    final response = await http.post(url, body: json.encode(data));
    final Map<String, dynamic> decodedData = json.decode(response.body);

    if (!decodedData.containsKey('idToken')) {
      return decodedData['error']['message'];
    }

    await _storage.write(key: 'token', value: decodedData['idToken']);

    return null;
  }

  Future<String?> createUser( String email, String pwd ) async {

    final Map<String, dynamic> data = {
      'email': email,
      'password': pwd,
      'returnSecureToken': true
    };

    final url = Uri.https(_baseUrl, '/v1/accounts:signUp', {
      'key': _firebaseToken
    });

    final response = await http.post(url, body: json.encode(data));
    final Map<String, dynamic> decodedData = json.decode(response.body);

    if (!decodedData.containsKey('idToken')) {
      return decodedData['error']['message'];
    }

    final AuthResponse authResp = AuthResponse.fromMap(decodedData);
    await _storage.write(key: 'token', value: authResp.idToken);
    return null;
  }

  Future<String> readToken() async {

    return await _storage.read(key: 'token') ?? '';

  }

  Future logout() async {
    await _storage.delete(key: 'token');
  }
}