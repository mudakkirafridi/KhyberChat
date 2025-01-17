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

  // saving the user data
  Future savingUserData(String fullName, String email) async {
    return await userCollection.doc(uid).set({
      "fullName": fullName,
      "email": email,
      'groups': [],
      'profile': "",
      'uid': uid
    });
  }

  // getting user data
  Future gettingUserData(String email) async {
    QuerySnapshot querySnapshot =
        await userCollection.where('email', isEqualTo: email).get();
    return querySnapshot;
  }


 // get user group
 getUserGroup()async{
  return userCollection.doc(uid).snapshots();
 }

 // create group
 Future createGroup(String userName , String id , String groupName)async{
  DocumentReference groupDocumentReference = await groupCollection.add({
    "groupName": groupName,
    "groupIcon": "",
    "admin": "${id}_$userName",
    "members": [],
    "groupId": "",
    "recentMessage": "",
    "recentMessageSender": "",
  }); 

  // update the member
  await groupDocumentReference.update({
    "members": FieldValue.arrayUnion(["${uid}_$userName"]),
    "groupId": groupDocumentReference.id
  });

  DocumentReference userDocumentRefrence = await userCollection.doc(uid);
  return await userDocumentRefrence.update({
    "groups": FieldValue.arrayUnion(["${groupDocumentReference.id}_$groupName"])
  });
 }

 // getting the chats
 getChats(String groupId)async{
  return groupCollection.doc(groupId).collection('messages').orderBy('time').snapshots(); // and .get();
 }

 // get group admin
 Future getGroupAdmin(String groupId)async{
   DocumentReference d = groupCollection.doc(groupId);
   DocumentSnapshot documentSnapshot = await d.get();
   return documentSnapshot['admin'];
 }

 // get Group member
 getGroupMembers(groupId)async{
  return groupCollection.doc(groupId).snapshots();
 }


 // search group by name
 searchByName(String groupName)async{
  return groupCollection.where("groupName",isEqualTo: groupName).get();
 }

 // future => bool
 Future<bool> isUserJoined(String groupName, String groupId, String userName)async{
  DocumentReference userDocumentRefrence = userCollection.doc(uid);
  DocumentSnapshot snapshot = await userDocumentRefrence.get();

  List<dynamic> groups = await snapshot['groups'];
  if (groups.contains("${groupId}_$groupName")) {
    return true;
  } else {
    return false;
  }
 }
}
