import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  // collection reference
  final CollectionReference eventCollection =
      FirebaseFirestore.instance.collection("events");

  void printData() {
    eventCollection.get().then(
      (res) {
        final data = res.docs;
        for (var i in data) {
          print(i.data());
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
  }
}
