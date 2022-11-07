
import 'package:calendar_app/models/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  // collection reference
  final CollectionReference eventCollection =
      FirebaseFirestore.instance.collection("events");

        late Future<DocumentSnapshot> eventDocument;

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

  void getDocIds() async{
    var querySnapshots = await eventCollection.get();
    for (var snapshot in querySnapshots.docs) {
      var documentID = snapshot.id; // <-- Document ID
      print(documentID);
}
  }
  
  void deleteData(String id){
    eventCollection.doc(id).delete();
  }
  void addData(Map event){
    //modifier pour prendre objet event
    eventCollection.add(event);

  }
  void updateData(String id, Map<String,Object> event){
    //modifier pour prendre objet event
    DocumentReference eventDocument =eventCollection.doc(id);
    eventDocument.update(event);

  }
}

