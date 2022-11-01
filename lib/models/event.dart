class Event {
  final String calendarName;
  final String location;
  final String name;
  final String description;
  final bool public;
  final DateTime start;
  final DateTime end;
  final Map? rules; //nullable or change it to non nullable and defaults

  Event(
      {required this.calendarName,
      this.description = "",
      required this.end,
      required this.location,
      required this.name,
      required this.public,
      required this.start,
      this.rules });

  //TODO: complete here all the parameters, match with firebase and
  //chose if "description" should be string or map
}
