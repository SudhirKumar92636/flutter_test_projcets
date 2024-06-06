import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_projcets/views/bottomnav/bottomnav.dart';

import 'auth/phonesign.dart';

class SplashScreens extends StatefulWidget {
  const SplashScreens({Key? key}) : super(key: key);

  @override
  State<SplashScreens> createState() => _SplashScreensState();
}

class _SplashScreensState extends State<SplashScreens> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      checkUser().then((widget) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => widget),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(

      body: Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           Image(image: AssetImage("assets/images/splash.png"),fit: BoxFit.cover,)
          ],
        )
      )

    );
  }

  Future<Widget> checkUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return const BottomNavigationsPages();
    } else {
      return  PhoneScreen();
    }
  }
}
