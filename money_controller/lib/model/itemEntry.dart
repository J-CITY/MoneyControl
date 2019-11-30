import 'package:firebase_database/firebase_database.dart';
import 'package:quiver/core.dart';

//дата
//доход.расход
//обязательный необязательный
//цена
//заметка

enum ItemType {
  //incoming
  salary,
  quickie,
  //outcoming
  gas,
  mobile,
  food,
  aliexpress
}

ItemType getItemFromString(String fruit) {
  fruit = 'ItemType.$fruit';
  return ItemType.values.firstWhere((f)=> f.toString() == fruit, orElse: () => null);
}

class ItemEntry {
  String key;

  DateTime dateTime;
  double price;
  String note;
  bool isIncoming;
  ItemType type;

  ItemEntry(this.dateTime, this.price,
      this.isIncoming, this.type, this.note);

  ItemEntry.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        dateTime = new DateTime.fromMillisecondsSinceEpoch(snapshot.value["date"]),
        price = snapshot.value["price"].toDouble(),
        isIncoming = snapshot.value["isIncoming"].toBool(),
        type = getItemFromString(snapshot.value["type"]),
        note = snapshot.value["note"];

  ItemEntry.copy(ItemEntry itemEntry)
      : key = itemEntry.key,
        dateTime = new DateTime.fromMillisecondsSinceEpoch(
            itemEntry.dateTime.millisecondsSinceEpoch),
        price = itemEntry.price,
        isIncoming = itemEntry.isIncoming,
        type = itemEntry.type,
        note = itemEntry.note;

  ItemEntry._internal(this.key, this.dateTime, this.price,
    this.isIncoming, this.type, this.note);

  ItemEntry copyWith(
      {String key, DateTime dateTime, double price,
        bool isIncoming, ItemType type, String note}) {
    return new ItemEntry._internal(
      key ?? this.key,
      dateTime ?? this.dateTime,
      price ?? this.price,
      isIncoming ?? this.isIncoming,
      type ?? this.type,
      note ?? this.note,
    );
  }

  toJson() {
    return {
      "price": price,
      "date": dateTime.millisecondsSinceEpoch,
      "isIncoming": isIncoming,
      "type": type.toString(),
      "note": note
    };
  }

  @override
  int get hashCode => hash4(key, dateTime, price, type.toString());

  @override
  bool operator==(other) =>
      other is ItemEntry &&
          key == other.key &&
          dateTime.millisecondsSinceEpoch == other.dateTime
              .millisecondsSinceEpoch &&
          price == other.price &&
          isIncoming == other.isIncoming &&
          type == other.type &&
          note == other.note;
}
