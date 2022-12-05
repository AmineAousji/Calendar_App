import 'package:calendar_app/pages/event_editing_page.dart';
import 'package:calendar_app/services/auth_service.dart';
import 'package:calendar_app/services/event_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widgets/calendar_widget.dart';
import 'package:calendar_app/pages/Login_page.dart';

void main() async {
  // initializers to talk with firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static String title = "Ecamlandar";

 /* @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => EventProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MainPage(),
        title: title,
      ),
    );
}*/
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
      create: (context) => EventProvider(),
      child: MaterialApp(
        title: title,
        home: Scaffold(
          appBar: AppBar(title: const Text("Ecamlandar")),
          body: const MyStatefulWidget(),
        ),
      )
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

}
