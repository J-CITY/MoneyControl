import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:money_controller/logic/reduxState.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GoogleSignIn _googleSignIn = new GoogleSignIn();

middleware(Store<ReduxState> store, action, NextDispatcher next) {
  print(action.runtimeType);

}




Future _setUnit(String unit) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('unit', unit);
}

Future<String> _loadUnit() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('unit') ?? 'kg';
}
