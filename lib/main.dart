import 'package:calendar_app/Schedule.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'services/database.dart';
import 'services/network.dart';

void main() async {
  // initializers to talk with firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // create instance of database
  final DatabaseService db = DatabaseService();
  final NetworkService nw = NetworkService();

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Schedule(),
    );
  }

  @override
  void initState() {
    super.initState();

    // get data from firestore database
    // db.readData(calendarNames: ["17288","Test"]);
    db.readSingleEvent("wiChYFKmELobcKq4MM6l");

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
  }
}
