import 'package:calendar_app/models/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  // collection reference
  final CollectionReference eventCollection =
      FirebaseFirestore.instance.collection("events");

  late Future<DocumentSnapshot> eventDocument;

  /// Get multiple events. (Need to put an "await" keyword to recuperate the events)
  /// You can filter with the parameters:
  /// - calendar : string
  Future<List<Event>> readData({List? calendarNames}) async {
    List<Event> events = [];

    print(calendarNames);
    // .where({"calendarName","in",[calendarNames]})
    eventCollection.get()
        .then(
          (res) {
            final docs = res.docs;
            for (var i in docs) {
              var data = i.data() as Map<String, dynamic>;

              var event = Event(
                  id: i.id,
                  name: data["name"],
                  calendarName: data["calendarName"],
                  start: data["start"],
                  end: data["end"],
                  location: data["location"],
                  public: data["public"]);
              events.add(event);
            }
            print(events.length);
          },
          onError: (e) => print("Error getting events: $e"),
        );

    return events;
  }

  void deleteData(String id) {
    eventCollection.doc(id).delete();
  }

  void createData(Map event) {
    //modifier pour prendre objet event
    eventCollection.add(event);
  }

  void updateData(String id, Map<String, Object> event) {
    //maybe in the future try to only be able to update "public=false" events
    //modifier pour prendre objet event
    DocumentReference eventDocument = eventCollection.doc(id);
    eventDocument.update(event);
  }
}
