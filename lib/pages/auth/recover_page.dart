import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:wachup_android_12/pages/auth/login_page.dart';
//import 'package:wachup_android_12/pages/home_page.dart';
import 'package:wachup_android_12/service/auth_service.dart';
import 'package:wachup_android_12/shared/constants.dart';
import 'package:wachup_android_12/widgets/widgets.dart';

class RecoverPage extends StatefulWidget {
  const RecoverPage({super.key});

  @override
  State<RecoverPage> createState() => _RecoverPageState();
}

class _RecoverPageState extends State<RecoverPage> {
  bool _isLoading = false;
  final formKey = GlobalKey<FormState>();
  String userName = "";
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
                      LocaleText("recover_title",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 55,
                            color: Constants().customForeColor,
                          )),
                      const SizedBox(height: 5),
                      LocaleText("recover_subtitle",
                          style: TextStyle(
                              fontSize: 15,
                              color: Constants().customForeColor)),
                      const SizedBox(height: 50),
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
                            Locales.string(context, "recover_button"),
                            style: TextStyle(
                                color: Constants().customBackColor,
                                fontSize: 16),
                          ),
                          onPressed: () {
                            recover();
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

  recover() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .recoverUserWithEmailandPassword(userName)
          .then((value) async {
        if (value == true) {
          showDialog(
              context: context,
              builder: (context) {
                return const AlertDialog(
                  content: LocaleText("recover_email_sent"),
                );
              });
          await Future.delayed(const Duration(seconds: 3));
          nextScreenReplace(context, const LoginPage());
        } else {
          showSnackbar(context, Locales.string(context, "recover_email_fail"),
              Constants().customColor2);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}
