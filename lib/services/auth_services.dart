
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:khyber_chat/services/database_service.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // login 



  // sign in
  Future signInUserWithEmailAndPassword(String fullName , String email , String password)async{
    try {
     User user = (await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password)).user!;
     if (user != null) {
       // calling db
      await DatabaseService(uid: user.uid).updateUserData(fullName, email);
       return true;
     }
    }on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return e.message;
    }
  }
}