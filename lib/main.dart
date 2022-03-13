import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:test/test.dart';
import 'firebase_options.dart';
import 'components/list.dart';
import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  runApp(const MyApp());
}

ThemeData _appThemeBlue = ThemeData(
    accentColor: Color.fromARGB(255, 48, 58, 68),
    primaryColor: Color.fromRGBO(226, 220, 222, 1),
    scaffoldBackgroundColor: Color.fromRGBO(64, 78, 92, 1));

ThemeData _appThemeRed = ThemeData(
    accentColor: Color.fromRGBO(220, 38, 38, 1),
    primaryColor: Color.fromRGBO(252, 252, 255, 1),
    scaffoldBackgroundColor: Color.fromRGBO(89, 89, 89, 1));

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wastey',
      theme: _appThemeBlue,
      home: const MyHomePage(title: 'Wastey'),
    );
  }
}
