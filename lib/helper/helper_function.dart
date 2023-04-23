import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
// Keys
  static String userLoggedInKey = "WACHUPLOGGEDINKEY";
  static String userFullNameKey = "WACHUPUSERFULLNAMEKEY";
  static String userEmailKey = "WACHUPEMAILKEY";
  static String userAccountTypeKey = "WACHUPACCOUNTTYPEKEY";
  static String userLanguageKey = "WACHUPLANGUAGEKEY";
  static String profilePictureKey = "WACHUPPROFILEKEY";
// Save
  static Future<bool> saveUserLoggedInStatus(bool isUserLoggedIn) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(userLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveUserFullNameSF(String userName) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userFullNameKey, userName);
  }

  static Future<bool> saveUserEmailSF(String userEmail) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userEmailKey, userEmail);
  }

  static Future<bool> saveUserAccountTypeSF(String userAccountType) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userAccountTypeKey, userAccountType);
  }

  static Future<bool> saveUserLanguageSF(String userLanguage) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(userLanguageKey, userLanguage);
  }

  static Future<bool> saveProfilePictureSF(String userProfilePicture) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(profilePictureKey, userProfilePicture);
  }

// Get
  static Future<bool?> getUserLoggedInStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userLoggedInKey);
  }

  static Future<String?> getUserEmailFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userEmailKey);
  }

  static Future<String?> getUserNameFromSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userFullNameKey);
  }

  static Future<String?> getUserAccountTypeSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userAccountTypeKey);
  }

  static Future<String?> getUserLanguageSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userLanguageKey);
  }

  static Future<String?> getProfilePictureSF() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(profilePictureKey);
  }
}
