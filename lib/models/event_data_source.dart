import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'event.dart';

class EventDataSource extends CalendarDataSource {

  EventDataSource(List<Event> source) {
    appointments = source;
  }

  Event getEvent (int index) => appointments![index] as Event;

  @override
  DateTime getStartTime(int index) {
    return getEvent(index).start;
  }

  @override
  DateTime getEndTime(int index) {
    return  getEvent(index).end;
  }

  @override
  String getSubject(int index) {
    return  getEvent(index).title;
  }

}