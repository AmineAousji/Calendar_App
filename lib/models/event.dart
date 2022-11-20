import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id; // id of the firestoreDB event
  final String
      calendarName; // name of the group of the calendar ex: 17288, 4MIN,...
  final String? location; // location of the event ex: 2F51
  final String name; // title of the event
  final String? description; // more details
  final bool public; // is the event public or private?
  final Timestamp start;
  final Timestamp end;
  final Map? rules; // nullable rules that has 'freq', 'count' and 'byDay' keys
  final Color? backgroundColor;

  Event(
      {required this.id,
      required this.name,
      required this.calendarName,
      this.description,
      required this.start,
      required this.end,
      this.location,
      required this.public,
      this.rules,
      this.backgroundColor});

  @override
  String toString() {
    var string = """{
          id: $id, 
          name: $name, 
          calendarName: $calendarName, 
          description: $description, 
          start: $start, 
          end: $end, 
          location: $location, 
          public: $public, 
          rules: $rules, 
          color: $backgroundColor}""";
    return string;
  }

  String getDescription() {
    var newDescription = "";
    if (description != null) {
      newDescription = description!;
      // newDescription =
      //     description!.split('\\n').join('\n').split(':').join(' : ');
      // // newDescription = formatted!.join("\n");
      // print(newDescription);
    }

    return newDescription;
  }

  factory Event.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Event(
        id: snapshot.id,
        name: data?['name'],
        calendarName: data?['calendarName'],
        start: data?['start'],
        end: data?['end'],
        public: data?['public'],
        rules: data?['rules'] is Iterable ? Map.from(data?['rules']) : null,
        description: data?['description'],
        location: data?['location'],
        backgroundColor: data?['backgroundColor']);
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "name": name,
      if (calendarName != null) "calendarName": calendarName,
      if (start != null) "start": start,
      if (end != null) "end": end,
      if (public != null) "public": public,
      if (rules != null) "rules": rules,
      if (description != null) "description": description,
      if (location != null) "location": location,
      if (backgroundColor != null) "backgroundColor": backgroundColor,
    };
  }
}
