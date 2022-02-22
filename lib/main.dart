import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:poverty/Screens/dash.dart';
import 'package:poverty/Screens/data.dart';
import 'package:poverty/Screens/login.dart';
import 'package:poverty/Screens/register.dart';
import 'package:poverty/Screens/splash.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        ),
      initialRoute: '/',
      routes: {
        '/':(context)=>Login(),
        '/reg':(context)=>register(),
        '/dat':(context)=>data(),
        '/ds':(context)=>dash(),
        '/spl':(context)=>splash()
      },
    );
  }
}
