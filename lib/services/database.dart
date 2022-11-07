import 'package:calendar_app/models/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  // collection reference
  final CollectionReference eventCollection =
      FirebaseFirestore.instance.collection("events");

  late Future<DocumentSnapshot> eventDocument;

  void readData() {
    eventCollection.get().then(
      (res) {
        final data = res.docs;
        for (var i in data) {
          print(i.data());
          print(i.id);
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
  }

 

  void deleteData(String id) {
    eventCollection.doc(id).delete();
  }

  void createData(Map event) {
    //modifier pour prendre objet event
    eventCollection.add(event);
  }

  void updateData(String id, Map<String, Object> event) {
    //modifier pour prendre objet event
    DocumentReference eventDocument = eventCollection.doc(id);
    eventDocument.update(event);
  }
}
