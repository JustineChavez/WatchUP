import 'package:flutter/material.dart';

class Constants {
  static String apiId = "1:332585078492:web:f96918598c2b9ba902ee19";
  static String apiKey = "AIzaSyBf052S2-_LTIJM-7lgDgZ9EXSSs1CW44c";
  static String messagingSenderId = "332585078492";
  static String projectId = "test-flutter-login-bcb8f";
  final customForeColor = const Color(0xFF1d3557); //Black Olive
  final customBackColor = const Color(0xFFffffff); //Baby Powder
  final customColor1 = const Color(0xFFe76f51); //Flame
  final customColor2 = const Color(0xFFef476f); //Brilliant Rose
  final customColor3 = const Color(0xFFe9c46a); //Amber

  //Original
  // final customForeColor = const Color(0xFF403D39); //Black Olive
  // final customBackColor = const Color(0xFFFFFFFA); //Baby Powder
  // final customColor1 = const Color(0xFFEB5E28); //Flame
  // final customColor2 = const Color(0xFFE15A97); //Brilliant Rose
  // final customColor3 = const Color(0xFFF2BB05); //Amber

  final kDefaultPadding = 20.0;

//Login Page
//Title
  String title = "Wachup";
//Subtitle
  String subtitle = "This is a test text only.";

//Sign In
  String titleEmail = "Email";
  String titlePassword = "Password";
  String titleSignIn = "Sign In";
//Forgot
  String assist1 = "Don't have an account? ";
  String assist2 = "Register here";
  String assist3 = "Forgot Password? ";
  String assist4 = "Click here";

//Register Page
//Reg
  String regTitle = "Register";
//Sign
  String regSubtitle = "Sign up for free.";
  String textName = "Full Name";
  String textEmail = "Email";
  String textPassword = "Password";
  String textTeacher = "Teacher";
  String textStudent = "Student";
  String buttonRegister = "Register";

//Validation
  String vUserName = "Please enter a valid username";
  String vPassword = "Password must be at least 6 characters";
  String vFullName = "Please input your full name";

  //Profile
  String buttonViewOnBoarding = "View Introduction";

  //Drawer
  String buttonGroup = "My Groups";
  String buttonProfile = "My Profile";
  String buttonTopics = "Lessons or Topics";
  String buttonGames = "Fun and Games";
  String buttonLanguage = "Change Language";
  String buttonLogout = "Logout";

  //Change Language
  String titleCL = "Localization";
  String questionCL = "Are you sure you want to change language?";

  //Logout
  String titleLogout = "Logout";
  String questionLogout = "Are you sure you want to logout?";
}
