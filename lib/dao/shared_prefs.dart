import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs extends ChangeNotifier {
  SharedPreferences? _prefs;
  String? _userId;

  SharedPrefs() {
    initSharedPreferences();
  }

  Future<void> initSharedPreferences() async {
    _prefs ??= await SharedPreferences.getInstance();
    _userId = _prefs!.getString("userId");
    notifyListeners();
  }

  SharedPreferences? get prefs => _prefs;

  String? get userId => _userId;

  Future<void> setUserId(String? id) async {
    String key = "userId";
    if (id == null) {
      prefs?.remove(key);
    } else {
      prefs?.setString(key, id);
    }
    _userId = id;
    notifyListeners();
  }
}
