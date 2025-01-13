import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  // refrence for our collection
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  // refrence for our group
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection('groups');


  // updating the user data
  Future updateUserData(String fullName , String email)async{
    return await userCollection.doc(uid).set({
      "fullName": fullName,
      "email": email,
      'groups': [],
      'profile': "",
       'uid': uid
    });
  }
}
