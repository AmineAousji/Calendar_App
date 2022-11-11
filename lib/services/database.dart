import 'package:calendar_app/models/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  // collection reference
  final CollectionReference eventCollection =
      FirebaseFirestore.instance.collection("events");

  late Future<DocumentSnapshot> eventDocument;

  /// Get multiple events. You can filter with the parameters:
  /// - calendar : string
  Future<List<Event>> readData({List? calendarNames}) async {
    List<Event> events = [];

    await eventCollection.where("calendarName", whereIn: calendarNames).get().then(
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
        print("Retrieved " + events.length.toString() + " events");
      },
      onError: (e) => print("Error getting events: $e"),
    );

    return events;
  }

  /// Get a single event searching by id (doc name in firestore db)
  /// The parameter:
  /// - id : string
  Future<Event> readSingleEvent(String id) async {
    final docRef = eventCollection.doc(id);
    late Event event;

    await docRef.get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;

        event = Event(
            id: id,
            name: data["name"],
            calendarName: data["calendarName"],
            start: data["start"],
            end: data["end"],
            location: data["location"],
            public: data["public"]);

        print("Retrieved event :" + event.name);
      },
      onError: (e) => print("Error getting document: $e"),
    );

    return event;
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
