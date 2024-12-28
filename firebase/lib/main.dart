import 'dart:developer';

import 'package:firebase/Home.dart';
import 'package:firebase/category/add.dart';
import 'package:firebase/category/edit.dart';
import 'package:firebase/myHomePage.dart';
import 'package:firebase/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
// import 'firebase_options.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  await FirebaseMessaging.instance.setAutoInitEnabled(true);

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: 'AIzaSyCBWnfCgxqWKTkpfMjZSCDhcBaJNbigioY',
          appId: '1:15172491051:android:60c27e3cd2546bc9ee176e',
          messagingSenderId: '15172491051	',
          projectId: 'fluttercourse-ce114'));
            final fcmToken = await FirebaseMessaging.instance.getToken();
log("FCMToken $fcmToken");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  getToken() async {
    String? mytoken = await FirebaseMessaging.instance.getToken();
    print("+++++++++++++++++++++++++++++++++++++++++");
    print(mytoken);
  }

  @override
  void initState() {
    getToken();
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
            backgroundColor: const Color.fromARGB(255, 63, 63, 63),
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
            iconTheme: IconThemeData(color: Colors.red)),
      ),
      routes: {
        "signIn": (context) => signIn(),
        "Home": (context) => Home(),
        "logIn": (context) => MyHomePage(),
        "addCategory": (context) => addCategory(),
      },
      home: (FirebaseAuth.instance.currentUser == null &&
              FirebaseAuth.instance.currentUser?.emailVerified == false)
          ? Home()
          : MyHomePage(),
    );
  }
}
