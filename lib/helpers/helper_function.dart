import 'package:shared_preferences/shared_preferences.dart';

class HelperFunction {

  // keys
  static String userLoggedInKey = "isloggedin";
  static String userNameKey = 'username';
  static String userEmailKey = 'useremail';

  // save data to shared preferences





  // get data from shared preferences
  static Future<bool?> getUserLoggedInStatus()async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userLoggedInKey);
  }


}