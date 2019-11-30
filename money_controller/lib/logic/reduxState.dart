import 'package:meta/meta.dart';
import 'package:money_controller/model/itemEntry.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

@immutable
class ReduxState {
  final List<ItemEntry> entries;
  final String unit;
  final RemovedEntryState removedEntryState;
  final ItemEntryDialogReduxState itemEntryDialogState;
  final FirebaseState firebaseState;
  final MainPageReduxState mainPageState;
  final DateTime progressChartStartDate;
  final double weightFromNotes;

  const ReduxState({
    this.firebaseState = const FirebaseState(),
    this.entries = const [],
    this.mainPageState = const MainPageReduxState(),
    this.unit = 'kg',
    this.removedEntryState = const RemovedEntryState(),
    this.itemEntryDialogState = const ItemEntryDialogReduxState(),
    this.progressChartStartDate,
    this.weightFromNotes,
  });

  ReduxState copyWith({
    FirebaseState firebaseState,
    List<ItemEntry> entries,
    bool hasEntryBeenAdded,
    String unit,
    RemovedEntryState removedEntryState,
    ItemEntryDialogReduxState weightEntryDialogState,
    DateTime progressChartStartDate,
  }) {
    return new ReduxState(
        firebaseState: firebaseState ?? this.firebaseState,
        entries: entries ?? this.entries,
        mainPageState: mainPageState ?? this.mainPageState,
        unit: unit ?? this.unit,
        itemEntryDialogState:
        itemEntryDialogState ?? this.itemEntryDialogState,
        removedEntryState: removedEntryState ?? this.removedEntryState,
        progressChartStartDate: progressChartStartDate ?? this.progressChartStartDate);
  }
}


@immutable
class RemovedEntryState {
  final ItemEntry lastRemovedEntry;
  final bool hasEntryBeenRemoved; //in other words: should show snackbar?

  const RemovedEntryState(
      {this.lastRemovedEntry, this.hasEntryBeenRemoved = false});

  RemovedEntryState copyWith({
    ItemEntry lastRemovedEntry,
    bool hasEntryBeenRemoved,
  }) {
    return new RemovedEntryState(
        lastRemovedEntry: lastRemovedEntry ?? this.lastRemovedEntry,
        hasEntryBeenRemoved: hasEntryBeenRemoved ?? this.hasEntryBeenRemoved);
  }
}

@immutable
class ItemEntryDialogReduxState {
  final bool isEditMode;
  final ItemEntry activeEntry; //entry to show in detail dialog

  const ItemEntryDialogReduxState({this.isEditMode, this.activeEntry});

  ItemEntryDialogReduxState copyWith({
    bool isEditMode,
    ItemEntry activeEntry,
  }) {
    return new ItemEntryDialogReduxState(
        isEditMode: isEditMode ?? this.isEditMode,
        activeEntry: activeEntry ?? this.activeEntry);
  }
}

@immutable
class FirebaseState {
  final FirebaseUser firebaseUser;
  final DatabaseReference mainReference;

  const FirebaseState({this.firebaseUser, this.mainReference});

  FirebaseState copyWith({
    FirebaseUser firebaseUser,
    DatabaseReference mainReference,
  }) {
    return new FirebaseState(
        firebaseUser: firebaseUser ?? this.firebaseUser,
        mainReference: mainReference ?? this.mainReference);
  }
}

@immutable
class MainPageReduxState {
  final bool hasEntryBeenAdded; //in other words: should scroll to top?

  const MainPageReduxState({this.hasEntryBeenAdded = false});

  MainPageReduxState copyWith({bool hasEntryBeenAdded}) {
    return new MainPageReduxState(
        hasEntryBeenAdded: hasEntryBeenAdded ?? this.hasEntryBeenAdded);
  }
}
