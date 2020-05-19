import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:interestopia/models/savedItem.dart';
import 'package:interestopia/models/user.dart';

class DatabaseService {

  String uid;
  CollectionReference usersSavedItemCollection;

  DatabaseService({ String uid }) { // TODO: Look into if not using final for the uid is unsafe in any way
    this.uid = uid;
    this.usersSavedItemCollection = Firestore.instance.collection('users/$uid/savedItems');
  }

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

  // get saved item doc stream for user
  Stream<List<SavedItem>> get savedItems {
    return usersSavedItemCollection.snapshots()
      .map(_savedItemListFromSnapshot);
  }

  List<SavedItem> _savedItemListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return SavedItem(
          title: doc.data['title'] ?? '',
          dateTimeSaved: doc.data['dateTimeSaved'].toDate() ?? null,
          description: doc.data['description'] ?? '',
          topic: doc.data['topic'] ?? null
      );
    }).toList();
  }

  StreamSubscription<QuerySnapshot> listenToDocumentChanges() { // TODO: We need to confirm that the frontend isn't rebuilding everything more than it needs to (I'm getting double print statements, 16 added and 2 modified). Plus, this needs to be fixed if I want to show some type of update to the user.
    return usersSavedItemCollection.snapshots().listen((querySnapshot) {
      querySnapshot.documentChanges.forEach((change) {
        if (change.type == DocumentChangeType.added) {
          print('Item was added');
        } else if (change.type == DocumentChangeType.modified) {
          print('Item was modified');
        } else if (change.type == DocumentChangeType.removed) {
          print('Item was removed');
        }
      });
    });
  }

  /// Temporarily being used on the settings screen

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

  /// Not Using

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