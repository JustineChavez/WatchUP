import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../../shared/constants.dart';
import 'login_page.dart';
import '../../helper/helper_function.dart';
//import '../home_page.dart';

/* void main(List<String> args) {
  runApp(SplashScreen());
} */

class AnimatedLogo extends AnimatedWidget {
  const AnimatedLogo({super.key, required Animation<double> animation})
      : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    timeDilation = 2.0;
    return Scaffold(
      backgroundColor: Constants().customBackColor,
      body: Center(
        child: Hero(
          tag: 'logo',
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            height: animation.value,
            width: animation.value,
            child: Image.asset(
              'assets/WachupLogoResized.png',
              height: animation.value,
              width: animation.value,
            ),
          ),
        ),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  bool isSignedIn = false;

  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation = Tween<double>(begin: 190, end: 200).animate(controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });
    controller.forward();

    getUserLoggedInStatus();
    _navigatetohome();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  getUserLoggedInStatus() async {
    await HelperFunctions.getUserLoggedInStatus().then((value) {
      if (value != null) {
        setState(() {
          isSignedIn = value;
        });
      }
    });
  }

  void _navigatetohome() async {
    await Future.delayed(const Duration(seconds: 3), () {});
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) =>
              //isSignedIn ? const HomePage() : const LoginPage()),
              isSignedIn ? const LoginPage() : const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) => AnimatedLogo(animation: animation);
}
