import 'package:calendar_app/Schedule.dart';
import 'package:flutter/material.dart';

void main() {
  return runApp(CalendarApp());
}

/// The app which hosts the home page which contains the calendar on it.
class CalendarApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        title: 'Calendar',
        debugShowCheckedModeBanner: false,
        home: Schedule());
  }
}
