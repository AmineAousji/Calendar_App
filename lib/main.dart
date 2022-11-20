<<<<<<< Updated upstream
import 'package:calendar_app/pages/event_editing_page.dart';
import 'package:calendar_app/services/event_provider.dart';
=======
import 'package:calendar_app/Schedule.dart';
import 'package:calendar_app/models/event.dart';
>>>>>>> Stashed changes
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widgets/calendar_widget.dart';

void main() async {
  // initializers to talk with firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static String title = "Ecamlandar";

  


  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => EventProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MainPage(),
        title: title,
      ),   
    );
}

class MainPage extends StatelessWidget {
  // Provider.of<EventProvider>(context, listen: false).syncEventsFromDB();

  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(MyApp.title),
          centerTitle: true,
          actions: syncChangesActions(context),
        ),
        body: CalendarWidget(),
        floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () => {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const EventEditingPage())),
        }
    )
  );
  
 List<Widget> syncChangesActions(BuildContext context) => [
        ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.blue,
                elevation: 0),
            onPressed: Provider.of<EventProvider>(context, listen: false).syncEventsFromDB,
            icon: const Icon(Icons.sync),
            label: const Text("SYNC"))
      ];

<<<<<<< Updated upstream
=======
  @override
  void initState() {
    super.initState();

    // get data from firestore database
    db.readData(calendarNames: ["17288","Test"]);
    db.readSingleEvent("wiChYFKmELobcKq4MM6l");

    // nw.getCalendar("serie_4MIN5A");
    // print(calendar.length.toString());
    // db.createBatchOfData(calendar);


    // db.updateData("6Xc4RPHwTtm5ztsU3K4R", event);
  }
>>>>>>> Stashed changes
}
