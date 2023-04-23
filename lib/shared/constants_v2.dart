import 'package:flutter/material.dart';

class FinalConstants {
  final Future<bool?> isEnglish;
  FinalConstants({required this.isEnglish});

  final apiId = "1:332585078492:web:f96918598c2b9ba902ee19";
  final apiKey = "AIzaSyBf052S2-_LTIJM-7lgDgZ9EXSSs1CW44c";
  final messagingSenderId = "332585078492";
  final projectId = "test-flutter-login-bcb8f";
  // final customForeColor = const Color(0xFF403D39); //Black Olive
  // final customBackColor = const Color(0xFFFFFFFA); //Baby Powder
  // final customColor1 = const Color(0xFFEB5E28); //Flame
  // final customColor2 = const Color(0xFFE15A97); //Brilliant Rose
  // final customColor3 = const Color(0xFFF2BB05); //Amber

//Login Page
//Title
  final title = "Wachup";

//Subtitle
  final subtitle = "This is a test text only.";

//Sign In
  final titleEmail = "Email";
  final titlePassword = "Password";
  final titleSignIn = "Sign In";
//Forgot
  final assist1 = "Don't have an account? ";
  final assist2 = "Register here";
  final assist3 = "Forgot Password? ";
  final assist4 = "Click here";

//Register Page
//Reg
  final regTitle = "Register";
//Sign
  final regSubtitle = "Sign up for free.";
  final textName = "Full Name";
  final textEmail = "Email";
  final textPassword = "Password";
  final textTeacher = "Teacher";
  final textStudent = "Student";
  final buttonRegister = "Register";

//Validation
  final vUserName = "Please enter a valid username";
  final vPassword = "Password must be at least 6 characters";
  final vFullName = "Please input your full name";

  //Profile
  String buttonViewOnBoarding() {
    return isEnglish == true ? "View Introduction" : "Tingnan Ang Introduksyon";
  }

  String fullName() {
    return isEnglish == true ? "Full Name" : "Buong Pangalan";
  }

  String email() {
    return isEnglish == true ? "Email" : "Email";
  }

  //Drawer
  String buttonGroup() {
    return isEnglish == true ? "My Groups" : "Aking Mga Grupo";
  }

  String buttonProfile() {
    return isEnglish == true ? "My Profile" : "Aking Propayl";
  }

  String buttonTopics() {
    return isEnglish == true ? "Lessons or Topics" : "Mga Tapik";
  }

  String buttonGames() {
    return isEnglish == true ? "Fun and Games" : "Mga Laro";
  }

  String buttonLanguage() {
    return isEnglish == true ? "Change Language" : "Baguhin ang lengguwahe";
  }

  String buttonLogout() {
    return isEnglish == true ? "Logout" : "Lag awt";
  }

  //Change Language
  String titleCL() {
    return isEnglish == true ? "Localization" : "Lokalisasyon";
  }

  String questionCL() {
    return isEnglish == true
        ? "Are you sure you want to change language?"
        : "Sigurado kang gusto mong baguhin ang lengguwahe?";
  }

  //Logout
  String titleLogout() {
    return isEnglish == true ? "Logout" : "Lag awt";
  }

  String questionLogout() {
    return isEnglish == true
        ? "Are you sure you want to logout?"
        : "Sigurado kang gusto mong umalis na?";
  }

  //Group
  String createGroup() {
    return isEnglish == true ? "Create Group" : "Gumawa ng Grupo";
  }

  String createGroupSuccess() {
    return isEnglish == true
        ? "Group created successfully."
        : "Matagumpay na nagawa ang grupo.";
  }

  String noGroup() {
    return isEnglish == true
        ? "You've not joined any groups, tap on the add icon to create a group or also search from top search button."
        : "Ikaw ay hindi kasali sa kahit anong grupo, pindutin ang add icon para gumawa ng sariling grupo o humanap ng grupo na masasalihan.";
  }

  String joinConvo() {
    return isEnglish == true
        ? "Join the conversation as"
        : "Sumali sa usapan bilang si";
  }

  String cancel() {
    return isEnglish == true ? "Cancel" : "Ikansela";
  }

  String create() {
    return isEnglish == true ? "Create" : "Gumawa";
  }

  String exit() {
    return isEnglish == true ? "Exit" : "Lumiban";
  }

  // Group Info

  String groupInfo() {
    return isEnglish == true ? "Group Info" : "Impormasyon Sa Grupo";
  }

  String exitGroupQuestion() {
    return isEnglish == true
        ? "Are you sure you exit the group? "
        : "Sigurado ka bang nais mong lumiban sa grupo? ";
  }

  String noMembers() {
    return isEnglish == true ? "NO MEMBERS" : "WALANG MIYEMBRO";
  }

  //Search

  String searchGroup() {
    return isEnglish == true ? "Search" : "Maghanap";
  }

  String searchGroup2() {
    return isEnglish == true ? "Search groups...." : "Maghanap ng grupo....";
  }

  String joinGroupSuccess() {
    return isEnglish == true
        ? "Successfully joined the group"
        : "Matagumpay na nakasali sa grupo";
  }

  String leftGroupSuccess() {
    return isEnglish == true ? "Left the group" : "Niliban na ang grupong";
  }

  String joined() {
    return isEnglish == true ? "Joined" : "Kasali";
  }

  String joinNow() {
    return isEnglish == true ? "Join Now" : "Sumali";
  }

  //Chat

  String sendMessage() {
    return isEnglish == true ? "Send a message..." : "Ipadala ang mensahe...";
  }

  //Topics
  //Group
  String createTopic() {
    return isEnglish == true ? "Create Topic" : "Gumawa ng Tapik";
  }

  String createTopicSuccess() {
    return isEnglish == true
        ? "Topic created successfully."
        : "Matagumpay na nagawa ang tapik.";
  }

  String noTopic() {
    return isEnglish == true
        ? "You've not created any topics, tap on the add icon to create a topic or also search from top search button."
        : "Ikaw ay hindi pa gumagawa ng kahit anong paksa, pindutin ang add icon para gumawa o humanap ng paksa.";
  }
}
