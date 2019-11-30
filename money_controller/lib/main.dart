import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:numberpicker/generated/i18n.dart';
import 'package:redux/redux.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

import 'logic/actions.dart';
import 'logic/constants.dart';
import 'logic/middleware.dart';
import 'logic/reduxState.dart';
import 'logic/theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final FirebaseAnalytics analytics = new FirebaseAnalytics();

  final Store<ReduxState> store = new Store<ReduxState>(reduce,
      initialState: new ReduxState(
          entries: [],
          unit: 'kg',
          removedEntryState: new RemovedEntryState(hasEntryBeenRemoved: false),
          firebaseState: new FirebaseState(),
          mainPageState: new MainPageReduxState(hasEntryBeenAdded: false),
          itemEntryDialogState: new ItemEntryDialogReduxState()),
      middleware: [middleware].toList());

  @override
  Widget build(BuildContext context) {
    store.dispatch(new InitAction());
    return new StoreProvider(
      store: store,
      child: new MaterialApp(
        title: titleStr,
        theme: ThemeData(
          brightness: lightBrightness,
          primarySwatch: lightPrimarySwatch,
        ),
        darkTheme: ThemeData(
            brightness: darkBrightness,
            primarySwatch: darkPrimarySwatch
        ),
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: analytics),
        ],

        localeResolutionCallback: S.delegate.resolution(fallback: Locale('en')),
        localizationsDelegates: [S.delegate],
        supportedLocales: S.delegate.supportedLocales,

        //home: new MainPage(title: titleStr, analytics: analytics),
      ),
    );
  }
}

