import 'package:calendar_app/services/database.dart';
import 'package:calendar_app/services/network.dart';
import '../models/event.dart';
import 'package:flutter/cupertino.dart';

class EventProvider extends ChangeNotifier {
  final DatabaseService db = DatabaseService();
  final NetworkService nw = NetworkService();
  List<Event> _events = [];
  List<Event> get events => _events;
  DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;

  void setDate(DateTime date) => _selectedDate = date;

  List<Event> get eventsOfSelectedDate => _events;

  void addEevent(Event event) {
    _events.add(event);
    notifyListeners();
    db.createData(event);
  }

  void deleteEvent(Event event) {
    _events.remove(event);
    db.deleteData(event);
    notifyListeners();
  }

  void editEvent(Event newEvent, Event oldEvent) {
    final index = _events.indexOf(oldEvent);
    _events[index] = newEvent;
    notifyListeners();
    db.updateData(newEvent);
  }

  Future<void> syncEventsFromDB() async {
    // var ecamEvents = await nw.getCalendar('serie_4MIN5A');
    // await db.createBatchOfData(ecamEvents);
    

    _events = await db.readBatchOfData(["17288", "ECAM", "serie_4MIN5A"]);
    notifyListeners();
  }
}