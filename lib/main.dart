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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Schedule(),
    );
  }

  @override
  void initState() {
    super.initState();

    // get data from firestore database
    db.printData();
    nw.getCalendar("17288");
  }
}
