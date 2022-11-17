import 'package:calendar_app/services/event_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'event_view_page.dart';
import 'models/event_data_source.dart';

class Schedule extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var events = Provider.of<EventProvider>(context).events;
    return SfCalendar(
      view: CalendarView.week,
      dataSource: EventDataSource(events),
      initialDisplayDate: DateTime.now(),
      cellBorderColor: Colors.transparent,

      //to show the events of a selected date
      onLongPress: (details) {
        final provider = Provider.of<EventProvider>(context, listen: false);
        provider.setDate(details.date!);
      },
      // ability to open a UI to update / delete the event
      onTap: (details) {
        if (details.appointments == null) return;
        final event = details.appointments!.first;
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => EventViewPage(event: event),
        ));
      },
      appointmentBuilder: appointmentBuilder,
    );
  }

  Widget appointmentBuilder(
    BuildContext context,
    CalendarAppointmentDetails details,
  ) {
    final event = details.appointments.first;
    return Container(
        width: details.bounds.width,
        height: details.bounds.height,
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            event.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ));
  }
}
