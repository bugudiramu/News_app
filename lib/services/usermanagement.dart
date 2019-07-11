import 'package:firebase_database/firebase_database.dart';

class UserManagement {
  final FirebaseDatabase database = FirebaseDatabase.instance;
  createUser(String uid, Map data) {
    database
        .reference()
        .child("buzzyfeedusers/$uid")
        .push()
        .set(data)
        .catchError((e) => print(e.toString()));
  }
}
