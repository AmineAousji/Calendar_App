import 'package:calendar_app/models/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  // collection reference
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final CollectionReference eventCollection =
      FirebaseFirestore.instance.collection("events");

  // convert events into Map so that Firestore understands and invertedly
  final eventsRef = FirebaseFirestore.instance
      .collection("events")
      .withConverter(
          fromFirestore: Event.fromFirestore,
          toFirestore: (Event eventTest, options) => eventTest.toFirestore());

  /// Get multiple events. You can filter with the parameters:
  /// - calendar : string
  Future<List<Event>> readBatchOfData(List calendarNames) async {
    List<Event> events = [];

    events = await eventsRef
        .where("calendarName", whereIn: calendarNames)
        .get()
        .then(
      (res) {
        for (var i in res.docs) {
          events.add(i.data());
        }
        print("Retrieved " + events.length.toString() + " events");
        return events;
      },
      onError: (e) => print("Error getting events: $e"),
    );

    return events;
  }

  /// Get a single event searching by id (doc name in firestore db)
  /// The parameter:
  /// - id : string
  Future<Event> readSingleEvent(String id) async {
    late Event event;

    event = (await eventsRef.doc(id).get()).data()!;

    return event;
  }

  void deleteData(Event event) {
    eventCollection.doc(event.id).delete();
  }

  void deleteBatchOfData(List<Event> events) {
    for (var event in events) {
      eventCollection.doc(event.id).delete();
    }
  }

  void createData(Event event) {
    eventsRef.add(event);
  }

  /// Create a Batch of multiple events and does a single request to Firestore.
  /// The parameter :
  /// - events : List(Event) = list of Event objects to send
  Future<void> createBatchOfData(List<Event> events) async {
    final batch = db.batch();

    // going through each event and add them to the batch
    for (Event event in events) {
      var docRef = eventsRef.doc(event.id);
      batch.set(docRef, event, SetOptions(merge: true));
    }

    batch.commit().then((value) =>
        print("Finnished batching ${events.length.toString()} events"));
  }

  void updateData(Event event) {
    DocumentReference eventDocument = eventsRef.doc(event.id);
    eventDocument.update(event.toFirestore());
  }

  void updateBatchOfData(List<Event> oldEvents, List<Event> newEvents) {
    for (Event event in oldEvents) {
      if (newEvents.any((element) => element.id == event.id)) {
        int index = newEvents.indexWhere((element) => element.id == event.id);
        updateData(newEvents[index]);
      }
    }
  }
}
