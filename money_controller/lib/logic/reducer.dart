import 'package:firebase_database/firebase_database.dart';
import 'package:money_controller/logic/reduxState.dart';
import 'package:money_controller/model/itemEntry.dart';

ReduxState reduce(ReduxState state, action) {
  List<ItemEntry> entries = _reduceEntries(state, action);
  String unit = _reduceUnit(state, action);
  RemovedEntryState removedEntryState = _reduceRemovedEntryState(state, action);
  ItemEntryDialogReduxState weightEntryDialogState =
  _reduceWeightEntryDialogState(state, action);
  FirebaseState firebaseState = _reduceFirebaseState(state, action);
  MainPageReduxState mainPageState = _reduceMainPageState(state, action);
  DateTime progressChartStartDate =
  _reduceProgressChartStartDate(state, action);
  double weightFromNotes = _reduceWeightFromNotes(state, action);

  return new ReduxState(
    entries: entries,
    unit: unit,
    removedEntryState: removedEntryState,
    itemEntryDialogState: weightEntryDialogState,
    firebaseState: firebaseState,
    mainPageState: mainPageState,
    progressChartStartDate: progressChartStartDate,
    weightFromNotes: weightFromNotes,
  );
}

double _reduceWeightFromNotes(ReduxState state, action) {
  double weight = state.weightFromNotes;
  if (action is AddItemFromNotes) {
    weight = action.weight;
  } else if (action is ConsumeItemFromNotes) {
    weight = null;
  }
  return weight;
}

String _reduceUnit(ReduxState reduxState, action) {
  String unit = reduxState.unit;
  if (action is OnUnitChangedAction) {
    unit = action.unit;
  }
  return unit;
}

MainPageReduxState _reduceMainPageState(ReduxState reduxState, action) {
  MainPageReduxState newMainPageState = reduxState.mainPageState;
  if (action is AcceptEntryAddedAction) {
    newMainPageState = newMainPageState.copyWith(hasEntryBeenAdded: false);
  } else if (action is OnAddedAction) {
    newMainPageState = newMainPageState.copyWith(hasEntryBeenAdded: true);
  }
  return newMainPageState;
}

FirebaseState _reduceFirebaseState(ReduxState reduxState, action) {
  FirebaseState newState = reduxState.firebaseState;
  if (action is InitAction) {
    FirebaseDatabase.instance.setPersistenceEnabled(true);
  } else if (action is UserLoadedAction) {
    newState = newState.copyWith(firebaseUser: action.firebaseUser);
  } else if (action is AddDatabaseReferenceAction) {
    newState = newState.copyWith(mainReference: action.databaseReference);
  }
  return newState;
}

RemovedEntryState _reduceRemovedEntryState(ReduxState reduxState, action) {
  RemovedEntryState newState = reduxState.removedEntryState;
  if (action is AcceptEntryRemovalAction) {
    newState = newState.copyWith(hasEntryBeenRemoved: false);
  } else if (action is OnRemovedAction) {
    newState = newState.copyWith(
        hasEntryBeenRemoved: true,
        lastRemovedEntry: new ItemEntry.fromSnapshot(action.event.snapshot));
  }
  return newState;
}

ItemEntryDialogReduxState _reduceWeightEntryDialogState(
    ReduxState reduxState, action) {
  ItemEntryDialogReduxState newState = reduxState.itemEntryDialogState;
  if (action is UpdateActiveItemEntry) {
    newState = newState.copyWith(
        activeEntry: new ItemEntry.copy(action.weightEntry));
  } else if (action is OpenAddEntryDialog) {
    newState = newState.copyWith(
        activeEntry: new ItemEntry(
            new DateTime.now(),
            reduxState.entries.isEmpty ? 70.0 : reduxState.entries.first.price,
            null),
        isEditMode: false);
  } else if (action is OpenEditEntryDialog) {
    newState =
        newState.copyWith(activeEntry: action.weightEntry, isEditMode: true);
  }
  return newState;
}

List<ItemEntry> _reduceEntries(ReduxState state, action) {
  List<ItemEntry> entries = new List.from(state.entries);
  if (action is OnAddedAction) {
    entries
      ..add(new ItemEntry.fromSnapshot(action.event.snapshot))
      ..sort((we1, we2) => we2.dateTime.compareTo(we1.dateTime));
  } else if (action is OnChangedAction) {
    ItemEntry newValue = new ItemEntry.fromSnapshot(action.event.snapshot);
    ItemEntry oldValue =
    entries.singleWhere((entry) => entry.key == newValue.key);
    entries
      ..[entries.indexOf(oldValue)] = newValue
      ..sort((we1, we2) => we2.dateTime.compareTo(we1.dateTime));
  } else if (action is OnRemovedAction) {
    ItemEntry removedEntry = state.entries
        .singleWhere((entry) => entry.key == action.event.snapshot.key);
    entries
      ..remove(removedEntry)
      ..sort((we1, we2) => we2.dateTime.compareTo(we1.dateTime));
  } else if (action is UserLoadedAction) {
    entries = [];
  }
  return entries;
}

DateTime _reduceProgressChartStartDate(ReduxState state, action) {
  DateTime date = state.progressChartStartDate;
  if (action is ChangeProgressChartStartDate) {
    date = action.dateTime;
  }
  return date;
}
