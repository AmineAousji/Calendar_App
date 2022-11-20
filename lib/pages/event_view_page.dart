import 'package:calendar_app/pages/event_editing_page.dart';
import 'package:calendar_app/services/event_provider.dart';
import 'package:flutter/material.dart';
import '../models/event.dart';
import 'package:provider/provider.dart';
import '../tools.dart';

class EventViewPage extends StatelessWidget {
  final Event event;

  const EventViewPage({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: CloseButton(),
          actions: buildViewingActions(context, event),
        ),
        body: ListView(
          padding: EdgeInsets.all(32),
          children: <Widget>[
            buildDateTime(event),
            SizedBox(height: 32),
            Text(
              event.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Text(
              event.getDescription(),
              style: const TextStyle(color: Colors.black, fontSize: 18),
            )
          ],
        ),
      );
  Widget buildDateTime(Event event) {
    return Column(
      children: [
        buildDate('Start', event.start.toDate()),
        const SizedBox(height: 20),
        buildDate('End', event.end.toDate()),
      ],
    );
  }

  
}

Widget buildDate(String name, DateTime date) {
  return Row(children: [
    Expanded(
      flex: 2,
      child: Text(
        name,
        style: const TextStyle(
            color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),
    Expanded(
      flex: 2,
      child: Text(
        Tools.toDate(date),
        style: const TextStyle(color: Colors.black, fontSize: 16),
      ),
    ),
    Text(
      Tools.toTime(date),
      style: const TextStyle(color: Colors.black, fontSize: 16),
    )
  ]);
}

List<Widget> buildViewingActions(BuildContext context, Event event) => [
      IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () => Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => EventEditingPage(event: event),
          ),
        ),
      ),
      IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            final provider = Provider.of<EventProvider>(context, listen: false);
            provider.deleteEvent(event);
            Navigator.of(context).pop();
          })
    ];
