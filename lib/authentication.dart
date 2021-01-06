import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

enum auth { login, signin }

class Auth with ChangeNotifier {
  String Token;
  DateTime Expiredate;
  String UserId;
  Timer timer;
  bool isauth;
  Future<void> authenticat(String email, String password, auth authe) async {
    String mode = authe == auth.login ? 'signInWithPassword' : 'signUp';
    String url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$mode?key=AIzaSyDdK7F7YcXuEQlfiBNTfp3g4z1Chx15I-0';

    var reponce = await http.post(url,
        body: jsonEncode(
            {'email': email, 'password': password, 'returnSecureToken': true}));

    var data = jsonDecode(reponce.body);
    Token = data['idToken'];
    UserId = data['localId'];
    Expiredate =
        DateTime.now().add(Duration(seconds: int.parse(data['expiresIn'])));

    var prefs = await SharedPreferences.getInstance();

    await prefs.setString(
        'data',
        jsonEncode({
          'Token': Token,
          'UserId': UserId,
          'Expiredate': Expiredate.toIso8601String()
        }));

    autologout();
    isauth = true;
    notifyListeners();
  }

  Future<void> logout() async {
    Token = null;
    UserId = null;
    Expiredate = null;
    var prefs = await SharedPreferences.getInstance();
    prefs.clear();

    isauth = false;
    notifyListeners();
    timer.cancel();
  }

  Future<void> autologout() async {
    timer = Timer(Expiredate.difference(DateTime.now()), logout);
  }

  Future<bool> autologin() async {
    var prefs = await SharedPreferences.getInstance();

    var data = await prefs.getString('data');
    // print(prefs.getString('data'));
    if (data == null) {
      isauth = false;
      notifyListeners();

      return false;
    }
    var map = jsonDecode(data);
    if (DateTime.parse(map['Expiredate']).isBefore(DateTime.now())) {
      logout();
      notifyListeners();
      isauth = false;
      return false;
    }
    Token = map['Token'];
    UserId = map['UserId'];
    Expiredate = DateTime.parse(map['Expiredate']);

    isauth = true;

    notifyListeners();
    autologout();
    return true;
  }
}
