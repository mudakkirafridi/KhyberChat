import 'package:shared_preferences/shared_preferences.dart';

class HelperFunction {

  // keys
  static String userLoggedInKey = "isloggedin";
  static String userNameKey = 'username';
  static String userEmailKey = 'useremail';

  // save data to shared preferences
  static Future<bool> saveUserLoggedInStatus(bool isUserLoggedIn)async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(userLoggedInKey, isUserLoggedIn);
  }

    static Future<bool> saveUserNameSf(String userName)async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userNameKey, userName);
  }

    static Future<bool> saveUserEmailSf(String userEmail)async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userEmailKey, userEmail);
  }




  // get data from shared preferences
  static Future<bool?> getUserLoggedInStatus()async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userLoggedInKey);
  }

  static Future<String?> getUserEmailFromSf()async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userEmailKey);
  }

  static Future<String?> getUserNameFromSf()async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userNameKey);
  }


}