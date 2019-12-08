import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:money_controller/logic/reduxState.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'actions.dart';

final GoogleSignIn _googleSignIn = new GoogleSignIn();

middleware(Store<ReduxState> store, action, NextDispatcher next) {
  print("ACTION:" + action.runtimeType.toString());

  if (action is InitAction) {
    _handleInitAction(store);
  } else if (action is AddEntryAction) {
    _handleAddEntryAction(store, action);
  } else if (action is EditEntryAction) {
    _handleEditEntryAction(store, action);
  } else if (action is RemoveEntryAction) {
  //  _handleRemoveEntryAction(store, action);
  } else if (action is UndoRemovalAction) {
  //  _handleUndoRemovalAction(store);
  } else if (action is SetUnitAction) {
  //  _handleSetUnitAction(action, store);
  } else if (action is GetSavedWeightNote) {
  //  _handleGetSavedWeightNote(store);
  } else if (action is AddItemFromNotes) {
  //  _handleAddWeightFromNotes(store, action);
  } else if (action is LoginWithGoogle) {
  //  _handleLoginWithGoogle(store, action);
  } else if (action is LogoutAction) {
  //  _handleLogoutAction(store, action);
  }
  next(action);
  if (action is UserLoadedAction) {
  //  _handleUserLoadedAction(store, action);
  } else if (action is AddDatabaseReferenceAction) {
  //  _handleAddedDatabaseReference(store, action);
  }
}




Future _setUnit(String unit) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('unit', unit);
}

Future<String> _loadUnit() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('unit') ?? 'kg';
}

_handleInitAction(Store<ReduxState> store) {
  //_loadUnit().then((unit) => store.dispatch(new OnUnitChangedAction(unit)));
  /*if (store.state.firebaseState.firebaseUser == null) {
    FirebaseAuth.instance.currentUser().then((user) {
      if (user != null) {
        store.dispatch(new UserLoadedAction(user));
      } else {
        FirebaseAuth.instance
            .signInAnonymously()
            .then((user) => store.dispatch(new UserLoadedAction(user)));
      }
    });
  }*/
}

_handleEditEntryAction(Store<ReduxState> store, EditEntryAction action) {
  store.state.firebaseState.mainReference
      .child(action.itemEntry.key)
      .set(action.itemEntry.toJson());
}

_handleAddEntryAction(Store<ReduxState> store, AddEntryAction action) {
  store.state.firebaseState.mainReference
      .push()
      .set(action.itemEntry.toJson());
}
