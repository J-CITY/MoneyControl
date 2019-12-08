import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';
import 'package:money_controller/logic/actions.dart';
import 'package:money_controller/logic/reduxState.dart';
import 'package:money_controller/model/itemEntry.dart';
import 'package:numberpicker/numberpicker.dart';

class DialogViewModel {
  final ItemEntry itemEntry;
  final String unit;
  final bool isEditMode;
  final double itemToDisplay;

  final Function(ItemEntry) onEntryChanged;
  final Function() onDeletePressed;
  final Function() onSavePressed;

  DialogViewModel({
    this.itemEntry,
    this.unit,
    this.isEditMode,
    this.itemToDisplay,

    this.onEntryChanged,
    this.onDeletePressed,
    this.onSavePressed,
  });
}

class ItemEntryDialog extends StatefulWidget {
  @override
  State<ItemEntryDialog> createState() {
    return new ItemEntryDialogState();
  }
}

class ItemEntryDialogState extends State<ItemEntryDialog> {
  TextEditingController _textController;
  bool wasBuiltOnce = false;

  String dropdownValue = "Income";
  String dropdownValue2 = "111";

  @override
  void initState() {
    super.initState();
    _textController = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<ReduxState, DialogViewModel>(
      converter: (store) {
        ItemEntry activeEntry =
            store.state.itemEntryDialogState.activeEntry;
        return new DialogViewModel(
            itemEntry: activeEntry,
            unit: activeEntry.unit,
            isEditMode: store.state.itemEntryDialogState.isEditMode,
            itemToDisplay: activeEntry.price,
            onEntryChanged: (entry) =>
                store.dispatch(new UpdateActiveItemEntry(entry)),
            onDeletePressed: () {
              store.dispatch(new RemoveEntryAction(activeEntry));
              Navigator.of(context).pop();
            },
            onSavePressed: () {
              if (store.state.itemEntryDialogState.isEditMode) {
                store.dispatch(new EditEntryAction(activeEntry));
              } else {
                store.dispatch(new AddEntryAction(activeEntry));
              }
              Navigator.of(context).pop();
            });
      },
      builder: (context, viewModel) {
        if (!wasBuiltOnce) {
          wasBuiltOnce = true;
          //_textController.text = viewModel.itemEntry.note;
        }
        return new Scaffold(
          appBar: _createAppBar(context, viewModel),
          body: new Column(
            children: [
              new ListTile(
                leading: new Icon(Icons.today, color: Colors.grey[500]),
                title: new DateTimeItem(
                  dateTime: viewModel.itemEntry.dateTime,
                  onChanged: (dateTime) =>
                      viewModel.onEntryChanged(
                          viewModel.itemEntry..dateTime = dateTime),
                ),
              ),
              new ListTile(
                leading: new Image.asset(
                  "assets/scale-bathroom.png",
                  color: Colors.grey[500],
                  height: 24.0,
                  width: 24.0,
                ),
                title: new Text(
                  viewModel.itemToDisplay.toStringAsFixed(1) +
                      " " +
                      viewModel.unit,
                ),
                onTap: () => _showPricePicker(context, viewModel),
              ),
              new ListTile(
                leading: new Icon(Icons.speaker_notes, color: Colors.grey[500]),
                title: new TextField(
                    decoration: new InputDecoration(
                      hintText: 'Optional note',
                    ),
                    controller: _textController,
                    onChanged: (value) {
                      viewModel
                          .onEntryChanged(viewModel.itemEntry..note = value);
                    }),
              ),
              new ListTile(// incoming ore sale
                leading: new Icon(Icons.speaker_notes, color: Colors.grey[500]),
                title: new DropdownButton<String>(
                  value: dropdownValue,
                  icon: Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(
                      color: Colors.deepPurple
                  ),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String newValue) {
                    setState(() {
                      dropdownValue = newValue;
                      dropdownValue2 = dropdownValue == "Income" ? "111" : "333";
                    });
                  },
                  items: <String>['Income', 'Costs']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  })
                      .toList(),
                ),
              ),
              new ListTile(// incoming ore sale
                leading: new Icon(Icons.speaker_notes, color: Colors.grey[500]),
                title: new DropdownButton<String>(
                  value: dropdownValue2,
                  icon: Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(
                      color: Colors.deepPurple
                  ),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String newValue) {
                    setState(() {
                      dropdownValue2 = newValue;
                    });
                  },
                  items: (dropdownValue == "Income" ? <String>['111', '222'] : <String>['333', '444', '555'])
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  })
                      .toList(),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _createAppBar(BuildContext context, DialogViewModel viewModel) {
    TextStyle actionStyle =
    Theme
        .of(context)
        .textTheme
        .subhead
        .copyWith(color: Colors.white);
    Text title = viewModel.isEditMode
        ? const Text("Edit entry")
        : const Text("New entry");
    List<Widget> actions = [];
    if (viewModel.isEditMode) {
      actions.add(
        new FlatButton(
          onPressed: viewModel.onDeletePressed,
          child: new Text(
            'DELETE',
            style: actionStyle,
          ),
        ),
      );
    }
    actions.add(new FlatButton(
      onPressed: viewModel.onSavePressed,
      child: new Text(
        'SAVE',
        style: actionStyle,
      ),
    ));

    return new AppBar(
      title: title,
      actions: actions,
    );
  }

  _showPricePicker(BuildContext context, DialogViewModel viewModel) {
    showDialog<double>(
      context: context,
      builder: (context) =>
      new NumberPickerDialog.decimal(
        minValue: 1,
        maxValue: 1000000000,
        initialDoubleValue: viewModel.itemToDisplay,
        title: new Text("Enter your weight"),
      ),
    ).then((double value) {
      if (value != null) {
        viewModel.onEntryChanged(viewModel.itemEntry..price = value);
      }
    });
  }
}

class DateTimeItem extends StatelessWidget {
  DateTimeItem({Key key, DateTime dateTime, @required this.onChanged})
      : assert(onChanged != null),
        date = dateTime == null
            ? new DateTime.now()
            : new DateTime(dateTime.year, dateTime.month, dateTime.day),
        time = dateTime == null
            ? new DateTime.now()
            : new TimeOfDay(hour: dateTime.hour, minute: dateTime.minute),
        super(key: key);

  final DateTime date;
  final TimeOfDay time;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    return new Row(
      children: <Widget>[
        new Expanded(
          child: new InkWell(
            key: new Key('CalendarItem'),
            onTap: (() => _showDatePicker(context)),
            child: new Padding(
                padding: new EdgeInsets.symmetric(vertical: 8.0),
                child: new Text(new DateFormat('EEEE, MMMM d').format(date))),
          ),
        ),
        new InkWell(
          key: new Key('TimeItem'),
          onTap: (() => _showTimePicker(context)),
          child: new Padding(
              padding: new EdgeInsets.symmetric(vertical: 8.0),
              child: new Text(time.format(context))),
        ),
      ],
    );
  }

  Future _showDatePicker(BuildContext context) async {
    DateTime dateTimePicked = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: date.subtract(const Duration(days: 365)),
        lastDate: new DateTime.now());

    if (dateTimePicked != null) {
      onChanged(new DateTime(dateTimePicked.year, dateTimePicked.month,
          dateTimePicked.day, time.hour, time.minute));
    }
  }

  Future _showTimePicker(BuildContext context) async {
    TimeOfDay timeOfDay =
    await showTimePicker(context: context, initialTime: time);

    if (timeOfDay != null) {
      onChanged(new DateTime(
          date.year, date.month, date.day, timeOfDay.hour, timeOfDay.minute));
    }
  }
}
