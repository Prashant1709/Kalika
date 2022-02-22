import 'dart:async';

import 'package:flutter/material.dart';
import 'package:poverty/Screens/dash.dart';
class splash extends StatefulWidget {
  const splash({Key? key}) : super(key: key);

  @override
  _splashState createState() => _splashState();
}

class _splashState extends State<splash> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5),
            ()=>Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) =>dash()
            )
        )
    );
  }
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(backgroundColor:Color.fromRGBO(255, 221, 200, 1),
        body:
        Center(child: Container(
          child: Card(color: Color.fromRGBO(255, 221, 200, 1),shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
            elevation: 0,
            child: Column(
              children: [
                CircleAvatar(backgroundColor:Color.fromRGBO(255, 221, 200, 1) ,backgroundImage: AssetImage("images/hands.png"),radius: 70,),
                Center(child: Text("नमस्ते",style: TextStyle(fontFamily: 'Poppins',fontWeight: FontWeight.bold,fontStyle: FontStyle.italic,fontSize:28,color: Color.fromRGBO(79, 9, 29,1)),)),
              ],
            ),
          ),
          width: 300,
          height: 200,
        ),),
      ),
    );
  }
}
