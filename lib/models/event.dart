import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;            // id of the firestoreDB event
  final String calendarName;  // name of the group of the calendar ex: 17288, 4MIN,...
  final String location;      // location of the event ex: 2F51
  final String name;          // title of the event
  final String description;   // more details
  final bool public;          // is the event public or private?
  final Timestamp start;      
  final Timestamp end;
  final Map? rules;           // nullable rules that has 'freq', 'count' and 'byDay' keys

  Event(
      {required this.id,
      required this.name,
      required this.calendarName,
      this.description = "",
      required this.start,
      required this.end,
      this.location = "",
      required this.public,
      this.rules});

  @override
  String toString() {
    var string = "{id: $id, name: $name, calendarName: $calendarName, description: $description, start: $start, end: $end, location: $location, public: $public, rules: $rules}";
    return string;
  }
}
