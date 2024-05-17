import 'package:flutter/material.dart';
import 'package:project3/HomeScreen.dart';
import 'package:project3/ManagerHome.dart';
import 'package:project3/Splash.dart';
import 'package:project3/screens/Admin/Admin_Homepage.dart';
import 'package:project3/screens/Admin/settings_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => Splash(),
        '/home': (context) => HomeScreen(),
        '/settings': (context) => SettingsPage(),
        '/admin_home': (context) => NavHomePage(),
        '/manager_home': (context) => ManagerHome(),



        // Add more routes as needed
      },
    );
  }
}
