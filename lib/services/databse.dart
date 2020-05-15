import 'package:brew_crew/models/brew.dart';
import 'package:brew_crew/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference brewCollection =
      Firestore.instance.collection('brews');

  Future updateUserData(String sugars, String name, int strength) async {
    return brewCollection.document(uid).setData({
      'sugars': sugars,
      'name': name,
      "strength": strength,
    });
  }

  List<Brew> _brewListfromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Brew(
        name: doc.data['name'] ?? "",
        sugars: doc.data['sugars'] ?? "0",
        strength: doc.data['strength'] ?? 0,
      );
    }).toList();
  }

  UserData userDataFromSnapshot(DocumentSnapshot shot) {
    return UserData(
      uid: uid,
      name: shot.data['name'],
      sugars: shot.data['sugars'],
      strength: shot.data['strength'],
    );
  }

  Stream<List<Brew>> get brews {
    return brewCollection.snapshots().map(_brewListfromSnapshot);
  }

  Stream<UserData> get userData {
    return brewCollection.document(uid).snapshots().map(userDataFromSnapshot);
  }
}
