
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:khyber_chat/helpers/helper_function.dart';
import 'package:khyber_chat/services/database_service.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // login 
  Future loginWithEmailAndPassword(String email , String password)async{
    try {
     User user = (await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password)).user!;
     if (user != null) {
       return true;
     }
    }on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return e.message;
    }
  }



  // sign in
  Future signInUserWithEmailAndPassword(String fullName , String email , String password)async{
    try {
     User user = (await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password)).user!;
     if (user != null) {
       // calling db
      await DatabaseService(uid: user.uid).savingUserData(fullName, email);
       return true;
     }
    }on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return e.message;
    }
  }

  // signout
  Future signOut()async{
    try {
      await HelperFunction.saveUserLoggedInStatus(false);
      await HelperFunction.saveUserNameSf('');
      await HelperFunction.saveUserEmailSf('');
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      return e;
    }
  }
}
