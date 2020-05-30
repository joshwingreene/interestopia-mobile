import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:interestopia/models/savedItem.dart';
import 'package:interestopia/models/tag.dart';
import 'package:interestopia/models/user.dart';
import 'package:interestopia/shared/tag_selector_manager.dart';

class DatabaseService {

  String uid;
  CollectionReference usersSavedItemCollection;
  CollectionReference usersTagCollection;

  DatabaseService({ String uid }) {
    this.uid = uid;
    this.usersSavedItemCollection = Firestore.instance.collection('users/$uid/savedItems');
    this.usersTagCollection = Firestore.instance.collection('users/$uid/tags');
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

  // get tag stream for user
  Stream<List<Tag>> get tags {
    return usersTagCollection.snapshots()
        .map(_tagListFromSnapshot);
  }

  List<SavedItem> _savedItemListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return SavedItem(
          title: doc.data['title'] ?? null,
          dateTimeSaved: doc.data['dateTimeSaved'].toDate() ?? null,
          description: doc.data['description'] ?? '',
          topic: doc.data['topic'] ?? null,
          consumptionOrReference: doc.data['consumptionOrReference'] ?? null,
          associatedTagIds: doc.data['associatedTagIds'] ?? null
      );
    }).toList();
  }

  List<Tag> _tagListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      print('tag title: ' + doc.data['title'] + ' tag id: ' + doc.documentID + ' associatedItemIds: ' + doc.data['associatedItemIds'].toString());

      return Tag(
          id: doc.documentID ?? null,
          title: doc.data['title'] ?? null,
          associatedItemIds: doc.data['associatedItemIds'] ?? null
      );
    }).toList();
  }

  StreamSubscription<QuerySnapshot> listenToDocumentChanges() { // TODO: We need to confirm that the frontend isn't rebuilding everything more than it needs to (I'm getting double print statements, 16 added and 2 modified). Plus, this needs to be fixed if I want to show some type of update to the user.
    return usersSavedItemCollection.snapshots().listen((querySnapshot) {

      List<DocumentChange> docChanges = querySnapshot.documentChanges;

      print('Number of Document Changes: ' + docChanges.length.toString());

      docChanges.forEach((change) {
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

  StreamSubscription<QuerySnapshot> listenToTagChanges({ TagSelectorManager tagSelectorManager }) { // TODO: We need to confirm that the frontend isn't rebuilding everything more than it needs to (I'm getting double print statements, 16 added and 2 modified). Plus, this needs to be fixed if I want to show some type of update to the user.
    return usersTagCollection.snapshots().listen((querySnapshot) {

      List<DocumentChange> docChanges = querySnapshot.documentChanges;

      print('Number of Document Changes: ' + docChanges.length.toString());

      docChanges.forEach((change) {
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

  void postNewTag({ String title }) async {

    await usersTagCollection.document(title).setData({
      'title': title,
      'associatedItemIds': []
    });
  }

  void modifyTag({ String title, List<dynamic> associatedItemIds }) async {

    await usersTagCollection.document(title).setData({
      'title': title,
      'associatedItemIds': associatedItemIds
    });

  }

  /// Temporarily being used on the settings screen

  // post saved item
  void postNewSavedItem({ String title, String url, DateTime dateTimeSaved, String description, String topic, String consumptionOrReference, List<dynamic> associatedTagIds }) async {

    await usersSavedItemCollection.document(url).setData({
      'title': title,
      'url': url,
      'dateTimeSaved': dateTimeSaved,
      'description': description,
      'topic': topic,
      'consumptionOrReference': consumptionOrReference,
      'associatedTagIds': associatedTagIds
    });

    for (int i = 0; i < associatedTagIds.length; i++) {
      dynamic tempTag = await usersTagCollection.document(associatedTagIds[i]).get();
      List<dynamic> tempList = tempTag.data['associatedItemIds'];
      tempList.add(url);

      modifyTag(title: tempTag.documentID, associatedItemIds: tempList);
    }
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