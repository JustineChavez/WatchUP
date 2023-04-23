import 'package:firebase_auth/firebase_auth.dart';
import 'package:wachup_android_12/helper/helper_function.dart';
import 'package:wachup_android_12/service/database_service.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //login
  Future loginUserWithEmailandPassword(String email, String password) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;
      if (user != null) {
        return true;
      }
    } on FirebaseAuthException catch (err) {
      return err.message;
    }
  }

  //register
  Future registerUserWithEmailandPassword(String fullName, String password,
      String email, String accountType) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;
      if (user != null) {
        //call our database service to update the user data.
        await DatabaseService(uid: user.uid)
            .savingUserData(fullName, email, accountType, "English");
        return true;
      }
    } on FirebaseAuthException catch (err) {
      return err.message;
    }
  }

  //recover
  Future recoverUserWithEmailandPassword(String email) async {
    try {
      (await firebaseAuth.sendPasswordResetEmail(email: email));
      return true;
    } on FirebaseAuthException catch (err) {
      return err.message;
    }
  }

  //signout
  Future signOut() async {
    try {
      await HelperFunctions.saveUserLoggedInStatus(false);
      await HelperFunctions.saveUserFullNameSF("");
      await HelperFunctions.saveUserEmailSF("");
      await HelperFunctions.saveUserAccountTypeSF("");
      await HelperFunctions.saveUserLanguageSF("");
      await HelperFunctions.saveProfilePictureSF("");
      await firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }
}
