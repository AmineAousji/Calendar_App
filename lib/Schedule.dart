import 'package:calendar_app/services/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'models/event_data_source.dart';

class Schedule extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final events = Provider
        .of<EventProvider>(context)
        .events;
    return SfCalendar(
      view: CalendarView.week,
      dataSource: EventDataSource(events),
      initialDisplayDate: DateTime.now(),
      cellBorderColor: Colors.transparent,
      //to show the events of a selected date
      onLongPress: (details){
        final provider = Provider.of<EventProvider>(context,listen: false );
        provider.setDate(details.date!);
      },
    );
  }
}


