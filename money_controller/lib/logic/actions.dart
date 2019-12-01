import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:money_controller/model/itemEntry.dart';

class UserLoadedAction {
  final FirebaseUser firebaseUser;
  final List<ItemEntry> cachedEntries;
  UserLoadedAction(this.firebaseUser, {this.cachedEntries = const []});
}

class AddDatabaseReferenceAction {
  final DatabaseReference databaseReference;
  final List<ItemEntry> cachedEntries;
  AddDatabaseReferenceAction(this.databaseReference,
      {this.cachedEntries = const []});
}

class GetSavedWeightNote {}

class AddItemFromNotes {
  final double item;
  AddItemFromNotes(this.item);
}

class ConsumeItemFromNotes {}

class AddEntryAction {
  final ItemEntry initEntry;
  AddEntryAction(this.initEntry);
}

class EditEntryAction {
  final ItemEntry initEntry;
  EditEntryAction(this.initEntry);
}

class RemoveEntryAction {
  final ItemEntry initEntry;
  RemoveEntryAction(this.initEntry);
}

class OnAddedAction {
  final Event event;
  OnAddedAction(this.event);
}

class OnChangedAction {
  final Event event;
  OnChangedAction(this.event);
}

class OnRemovedAction {
  final Event event;
  OnRemovedAction(this.event);
}

class AcceptEntryAddedAction {}

class AcceptEntryRemovalAction {}

class UndoRemovalAction {}

class InitAction {}

class UpdateActiveItemEntry {
  final ItemEntry itemEntry;
  UpdateActiveItemEntry(this.itemEntry);
}

class OpenAddEntryDialog {}

class OpenEditEntryDialog {
  final ItemEntry itemEntry;
  OpenEditEntryDialog(this.itemEntry);
}

class ChangeProgressChartStartDate {
  final DateTime dateTime;
  ChangeProgressChartStartDate(this.dateTime);
}

class LoginWithGoogle {
  final List<ItemEntry> cachedEntries;
  LoginWithGoogle({this.cachedEntries = const []});
}

class LogoutAction {
  LogoutAction();
}
