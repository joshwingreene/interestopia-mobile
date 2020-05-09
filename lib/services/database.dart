import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:interestopia/models/savedItem.dart';
import 'package:interestopia/models/user.dart';

class DatabaseService {

  final String uid;

  DatabaseService({ this.uid });


  // collection reference
  final CollectionReference userCollection = Firestore.instance.collection(
      'users');

  Future updateUserData(String name) async {
    // I will add more parameters later
    return await userCollection.document(uid).setData({
      'name': name
    });
  }

  // userData from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        uid: uid,
        name: snapshot.data['name']
    );
  }

  // get user doc stream
  Stream<UserData> get userData {
    return userCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  }

  // post saved item
  void postNewSavedItem(String title, DateTime dateTimeSaved,
      String description, String topic) async {
    CollectionReference savedItemsCollection = Firestore.instance.collection(
        'users/$uid/savedItems');

    await savedItemsCollection.document().setData({
      'title': title,
      'dateTimeSaved': dateTimeSaved,
      'description': description,
      'topic': topic
    });
  }

  Future getSavedItemListFromFirebase() async {
    CollectionReference savedItemsCollection = Firestore.instance.collection(
        'users/$uid/savedItems');

    return await savedItemsCollection.getDocuments().then((querySnapshot) {
      return querySnapshot.documents.map((doc) {
        return SavedItem(
          title: doc.data['title'] ?? '',
          dateTimeSaved: doc.data['dateTimeSaved'].toDate() ?? null,
          description: doc.data['description'] ?? '',
          topic: doc.data['topic'] ?? null
        );
      }).toList();
    });
  }

  void savedItemListFromFirebase() async {
    CollectionReference savedItemsCollection = Firestore.instance.collection(
        'users/$uid/savedItems');

    await savedItemsCollection.getDocuments().then((querySnapshot) {
      querySnapshot.documents.forEach((doc) {
        print('Title: ' + doc.data['title']);
      });
    });
    /*
    savedItemsCollection.getDocuments().then((QuerySnapshot snapshot) {
      return snapshot.documents.map((doc) {
        return SavedItem(
          title: doc.data['title'],
          description: doc.data['description'],
          date
        )
      };
    }).
    }
   */
  }
}