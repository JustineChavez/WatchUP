import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:wachup_android_12/helper/helper_function.dart';
//import 'package:wachup_android_12/pages/home_page.dart';
import 'package:wachup_android_12/service/auth_service.dart';
import 'package:wachup_android_12/shared/constants.dart';
import 'package:wachup_android_12/widgets/widgets.dart';
import 'package:flutter/gestures.dart';

import '../home_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();
  String userName = "";
  String password = "";
  String fullName = "";
  String accountType = "Student";
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ))
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      LocaleText("register_title",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 55,
                            color: Constants().customForeColor,
                          )),
                      const SizedBox(height: 5),
                      LocaleText("register_subtitle",
                          style: TextStyle(
                              fontSize: 15,
                              color: Constants().customForeColor)),
                      const SizedBox(height: 50),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                            labelText: Locales.string(context, "name_text"),
                            prefixIcon: Icon(
                              Icons.supervised_user_circle,
                              color: Theme.of(context).primaryColor,
                            )),
                        onChanged: (val) {
                          setState(() {
                            fullName = val;
                          });
                        },
                        validator: (val) {
                          if (val!.length < 6) {
                            return Locales.string(context, "fullname_validate");
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                            labelText: Locales.string(context, "email_text"),
                            prefixIcon: Icon(
                              Icons.email,
                              color: Theme.of(context).primaryColor,
                            )),
                        onChanged: (val) {
                          setState(() {
                            userName = val;
                          });
                        },
                        validator: (val) {
                          return RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(val!)
                              ? null
                              : Locales.string(context, "email_validate");
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        obscureText: true,
                        decoration: textInputDecoration.copyWith(
                            labelText: Locales.string(context, "password_text"),
                            prefixIcon: Icon(
                              Icons.password,
                              color: Theme.of(context).primaryColor,
                            )),
                        onChanged: (val) {
                          setState(() {
                            password = val;
                          });
                        },
                        validator: (val) {
                          if (val!.length < 6) {
                            return Locales.string(context, "password_validate");
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      DropdownButtonFormField(
                          items: [
                            DropdownMenuItem<String>(
                                value: Constants().textTeacher,
                                child: Text(
                                    Locales.string(context, "teacher_text"))),
                            DropdownMenuItem<String>(
                                value: Constants().textStudent,
                                child: Text(
                                    Locales.string(context, "student_text")))
                          ],
                          value: accountType,
                          isExpanded: true,
                          iconEnabledColor: Theme.of(context).primaryColor,
                          decoration: textInputDecoration.copyWith(
                              prefixIcon: Icon(
                            Icons.abc,
                            color: Theme.of(context).primaryColor,
                          )),
                          onChanged: dropDownCallBack),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Constants().customColor3,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8))),
                          child: Text(
                            Locales.string(context, "reg_button"),
                            style: TextStyle(
                                color: Constants().customBackColor,
                                fontSize: 16),
                          ),
                          onPressed: () {
                            register();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  void dropDownCallBack(String? selectedValue) {
    if (selectedValue is String) {
      setState(() {
        accountType = selectedValue;
      });
    }
  }

  register() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .registerUserWithEmailandPassword(
              fullName, password, userName, accountType)
          .then((value) async {
        if (value == true) {
          //saving the shared preference state
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(userName);
          await HelperFunctions.saveUserFullNameSF(fullName);
          await HelperFunctions.saveUserAccountTypeSF(accountType);
          //await HelperFunctions.saveUserIsEnglishSF(true);
          nextScreenReplace(context, const HomePage());
        } else {
          showSnackbar(context, value, Constants().customColor2);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}
