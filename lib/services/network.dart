import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

import '../models/event.dart';

class NetworkService {
  var calendarUrl = "https://calendar.ecam.be/ics/";

  /* 
  Types of calendar ID :
    - user id (matricule) ex : 17288
    - year serie (année) ex : serie_4MIN5A
    - classroom ex : 2D15
  **/
  Future<List<Event>> getCalendar(calendarId) async {
    // add the selected Id of the calendar
    var url = Uri.parse(calendarUrl + calendarId);
    final response = await http.get(url);
    List<Event> events = [];

    if (response.statusCode == 200) {
      var eventsResponse = response.body;

      // split each event (beware of the first "event" that is not an event)
      List<String> eventsList = eventsResponse.split("BEGIN:VEVENT");

      // this removes the headers of the calendar
      eventsList.removeAt(0);

      for (var event in eventsList) {
        var eventDetails = event.split("\n");
        eventDetails.removeLast();
        eventDetails.removeAt(0);

        late String id;
        late String calendarName = calendarId;
        String? location;
        late String name;
        late String description;
        late bool public = true;
        late Timestamp start;
        late Timestamp end;
        Map? rules;

        for (var detail in eventDetails) {
          if (detail.startsWith("UID")) {
            id = detail.substring(4);
          } else if (detail.startsWith("SUMMARY")) {
            name = detail.substring(8);
          } else if (detail.startsWith("DESCRIPTION")) {
            description = detail.substring(11);
          } else if (detail.startsWith("LOCATION")) {
            location = detail.substring(8);
          } else if (detail.startsWith("DTSTART")) {
            var startString = detail.split(":").last;
            start = Timestamp.fromDate(DateTime.parse(startString));
          } else if (detail.startsWith("DTEND")) {
            var endtString = detail.split(":").last;
            end = Timestamp.fromDate(DateTime.parse(endtString));
          } else if (detail.startsWith("RRULE")) {
            var rulesList = detail.split(":").last.split(";");
            rules = {for (var e in rulesList) e.split("=")[0]: e.split("=")[1]};
          }

          // print(detail);
        }
        var newEvent = Event(
            id: id,
            name: name,
            calendarName: calendarName,
            description: description,
            start: start,
            end: end,
            location: location,
            public: public,
            rules: rules);

        // print(newEvent);
        events.add(newEvent);
      }
      print("Retrieved " + events.length.toString() + " events");

    } else {
      throw Exception("failure getting the calendar");
    }

    return events;
  }
}
