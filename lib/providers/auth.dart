import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/http_exceotion.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;

  String? get userId {
    return _userId;
  }

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> clearLoginData() async {
    final prefs = await SharedPreferences.getInstance();
    // final userData = json.encode({
    //   'token': null,
    //   'userId': null,
    //   'expiryDate': null,
    // });
    // prefs.setString('userData', userData);
    prefs.remove('userData');
    // prefs.clear(); clear all prefs
  }

  void logOut() {
    _token = null;
    _expiryDate = null;
    _userId = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    _authTimer = null;
    clearLoginData();

    notifyListeners();
  }

  void autoLogOut() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final _expiryTime = _expiryDate?.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: _expiryTime!), () {
      logOut();
    });
  }

  Future<void> _authenticate(
      String email, String password, String customUrl) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$customUrl?key=AIzaSyA9pDDL-q31DuuCVVb8TL6hM1dcfNsEvh8');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );
      autoLogOut();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate!.toIso8601String()
      });
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedData =
        json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
    final expiryDate = DateTime.parse(extractedData['expiryDate'].toString());
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedData['token'].toString();
    _userId = extractedData['userId'].toString();
    _expiryDate = expiryDate;
    notifyListeners();
    autoLogOut();
    return true;
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> signin(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }
}
