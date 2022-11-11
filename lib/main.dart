import 'package:calendar_app/Schedule.dart';
import 'package:calendar_app/services/event_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/database.dart';
import 'services/network.dart';
import 'EventPage.dart';

void main() async {
  // initializers to talk with firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final DatabaseService db = DatabaseService();
  final NetworkService nw = NetworkService();

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (context) => EventProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MainPage(),
      )
  );

  }

class MainPage extends StatelessWidget{
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calendar"),
        centerTitle: true,
      ),
      body: Schedule(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add, color: Colors.red,),
        onPressed: () => {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => Eventpage())
          ),
        },
      ),
    );

  }
}
 /*@override
  void initState() {
    super.initState();

    // get data from firestore database
    db.readData();
    // nw.getCalendar("17288");
    //Test de la fonction update
    Map<String, Object> event = {};
    event["calendarName"] = "3/11";
    event["start"] = DateTime.utc(2022, 11, 9);
    event["end"] = DateTime.utc(2022, 11, 10);
    event["location"] = "LLN";
    event["name"] = "Nicolas";
    event["public"] = false;
    db.updateData("6Xc4RPHwTtm5ztsU3K4R", event);
  }*/



