import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:poverty/Screens/ch1.dart';
import 'package:poverty/Screens/ch2.dart';
import 'package:poverty/Screens/ch3.dart';
import 'package:poverty/Screens/ch4.dart';
import 'package:poverty/Screens/dash.dart';
import 'package:poverty/Screens/data.dart';
import 'package:poverty/Screens/login.dart';
import 'package:poverty/Screens/register.dart';
import 'package:poverty/Screens/splash.dart';
import 'package:poverty/Screens/tracker.dart';

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
        '/spl':(context)=>splash(),
        '/trc':(context)=>tracker(),
        '/ch1':(context)=>ch1(),
        '/ch2':(context)=>ch2(),
        '/ch3':(context)=>ch3(),
        '/ch4':(context)=>ch4(),
      },
    );
  }
}
