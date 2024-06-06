
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test_projcets/auth/phonesign.dart';
import 'package:flutter_test_projcets/splshscreens.dart';
import 'package:flutter_test_projcets/views/addusersdetails/addusers.dart';
import 'package:flutter_test_projcets/views/addusersdetails/addusersrealtime.dart';
import 'package:flutter_test_projcets/views/addusersdetails/profile.dart';
import 'package:flutter_test_projcets/views/addusersdetails/showusersrealtime.dart';
import 'package:flutter_test_projcets/views/bottomnav/bottomnav.dart';
import 'package:flutter_test_projcets/views/bottomnav/homescreens.dart';
import 'package:get/get.dart';

import 'firebasefirestore/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
 
  runApp(const MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return  GetMaterialApp(
      debugShowCheckedModeBanner: false,
     // home: BottomNavigationsPages(),
      home: SplashScreens(),
     // home: ProfileScreens(),
     // home: ProfileScreens(),
    );
  }
}
