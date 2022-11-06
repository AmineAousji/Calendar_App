import 'package:http/http.dart' as http;

class NetworkService {
  var calendarUrl = "https://calendar.ecam.be/ics/";

  /* 
  Types of calendar ID :
    - user id (matricule) ex : 17288
    - year serie (année) ex : serie_4MIN5A
    - classroom ex : 2D15
  **/
  void getCalendar(calendarId) async {
    // add the selected Id of the calendar
    var url = Uri.parse(calendarUrl + calendarId);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      var events = response.body;

      // split each event (beware of the first "event" that is not an event)
      List<String> eventsList = events.split("BEGIN:VEVENT");
      print(eventsList.length);
      // print(eventsList[0]); // those are the headers of the calendar
      // for (var event in eventsList) {
      //   print(event);
      //   print("\n");
      // }
    } else {
      throw Exception("failure getting the calendar");
    }
  }
}
