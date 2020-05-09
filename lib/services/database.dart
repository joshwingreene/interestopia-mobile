import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:interestopia/models/user.dart';

class DatabaseService {

  final String uid;
  DatabaseService({ this.uid });


  // collection reference
  final CollectionReference userCollection = Firestore.instance.collection('users');

  Future updateUserData(String name) async { // I will add more parameters later
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

}