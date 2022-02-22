import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
class register extends StatefulWidget {
  const register({Key? key}) : super(key: key);

  @override
  _registerState createState() => _registerState();
}

class _registerState extends State<register> {
  final _auth= FirebaseAuth.instance;

  FirebaseAuth auth=FirebaseAuth.instance;
  @override
  String email="";
  String pass="";
  String uid="";

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromRGBO(151, 191, 180, 1),
        body: SingleChildScrollView(
          child: SafeArea(child: Column(
          children: [
            Row(
              children: [IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back,color: Colors.black,),)]
            ),
            SizedBox(height: 70,),
            Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Enter the below data to Register",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold ,color: Color.fromRGBO(79, 9, 29, 1)),),
              ],
            ),
            SizedBox(height: 90,),
            Padding(padding: const EdgeInsets.all(5.0),
              child: Card(elevation: 2,

                color: Color.fromRGBO(255, 247, 240, 1),
                child:Padding(
                  padding: const EdgeInsets.fromLTRB(10.0,0,0,0),
                  child: TextFormField(
                    textAlign: TextAlign.justify,
                    autofocus: true,
                    textInputAction: TextInputAction.next,
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      email = value;},
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(

                      hintText:'E-mail',
                      focusColor: Colors.black,
                      hintStyle: TextStyle(
                        color: Colors.black,
                        decorationColor: Colors.black,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
            Padding(padding: const EdgeInsets.all(5.0),
              child: Card(elevation: 2,

                color: Color.fromRGBO(255, 247, 240, 1),
                child:Padding(
                  padding: const EdgeInsets.fromLTRB(10.0,0,0,0),
                  child: TextFormField(
                    textAlign: TextAlign.justify,
                    autofocus: true,
                    obscureText: true,
                    textInputAction: TextInputAction.next,
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.visiblePassword,
                    onChanged: (value){
                      pass = value;},
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(

                      hintText:'Password',
                      focusColor: Colors.black,
                      hintStyle: TextStyle(
                        color: Colors.black,
                        decorationColor: Colors.black,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
            Padding(padding: EdgeInsets.all(10.0),
            child: MaterialButton(onPressed: ()async{
              try{
                final newUser = await _auth.createUserWithEmailAndPassword(email: email, password: pass);
                uid=newUser.credential.toString();
                print(uid);
                if(newUser!=Null)
                  {
                    showDialog<void>(
                      context: context,
                      barrierDismissible: false, // user must tap button!
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('User Registered'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: const <Widget>[
                                Text('Click proceed to enter additional info'),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Proceed'),
                              onPressed: () {
                                Navigator.of(context).pushNamed('/dat');
                              },
                            ),
                          ],
                          elevation: 24,
                        );
                      },
                    );
                  }
              }
              catch(e){
                print(e);
                showDialog<void>(
                  context: context,
                  barrierDismissible: false, // user must tap button!
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Error Encountered'),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: const <Widget>[
                            Text("Check password, min 6 charachters needed"),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Proceed'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                      elevation: 24,
                    );
                  },
                );
              }
            },color: Color.fromRGBO(234, 76, 76, 1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
              minWidth: 200.0,
              height: 52.0,
              child: Text("Register",style: TextStyle(fontSize: 24,color: Colors.white),),),
            )
          ],
          ),),
        ),
      ),
    );
  }
}
