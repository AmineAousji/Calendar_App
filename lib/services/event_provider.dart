import 'package:calendar_app/services/database.dart';
import '../models/event.dart';
import 'package:flutter/cupertino.dart';

class EventProvider extends ChangeNotifier {
  final DatabaseService db = DatabaseService();
  List<Event> _events = [];
  List<Event> get events => _events;
  DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;

  void setDate(DateTime date) => _selectedDate = date;

  List<Event> get eventsOfSelectedDate => _events;

  void addEevent(Event event) {
    _events.add(event);
    notifyListeners();
    // syncEventsFromDB();
  }

  void deleteEvent(Event event) {
    _events.remove(event);
    notifyListeners();
    // syncEventsFromDB();
  }

  void editEvent(Event newEvent, Event oldEvent) {
    final index = _events.indexOf(oldEvent);
    _events[index] = newEvent;
    notifyListeners();
    // syncEventsFromDB();
  }

  Future<void> syncEventsFromDB() async {
    _events = await db.readBatchOfData(["17288", "Test", "serie_4MIN5A"]);
    notifyListeners();
  }
}
