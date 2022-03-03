import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _auth=FirebaseAuth.instance;
  String email="";
  String pass="";
  bool en=true;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', ''), // English, no country code
        Locale('hi', ''), // Spanish, no country code
      ],
      home: Scaffold(
        backgroundColor: Color.fromRGBO(221, 74, 72, 1),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(height: 60,),
              CircleAvatar(radius: 140,
                backgroundColor: Color.fromRGBO(221, 74, 72, 1),
                backgroundImage: AssetImage("images/Kalika logo.png"),
              ),

              ToggleSwitch(
                minWidth: 90.0,
                cornerRadius: 20.0,
                activeBgColors: [[Color.fromRGBO(151, 191, 180, 1)], [Color.fromRGBO(151, 191, 180, 1)]],
                activeFgColor: Colors.white,
                inactiveBgColor: Color.fromRGBO(255, 247, 240, 1),
                inactiveFgColor: Colors.black,
                initialLabelIndex: 1,
                totalSwitches: 2,
                labels: ['English', 'हिन्दी'],
                radiusStyle: true,
                onToggle: (index) {
                  print('switched to: $index');
                },
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
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: MaterialButton(onPressed: ()async{
                  CircularProgressIndicator(
                    strokeWidth: 7,
                    color: Colors.red,
                  );
                  try {

                    final user = await _auth.signInWithEmailAndPassword(
                        email: email, password: pass);

                    if (user != null) {
                      //print("Logged In");
                      //print(user.user?.uid);
                      Navigator.pushNamed(context, '/spl');
                    }
                    if(_auth.currentUser==null){
                      showDialog<void>(
                        context: context,
                        barrierDismissible: false, // user must tap button!
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('User Not Found'),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: const <Widget>[
                                  Text('Please click on register to proceed!'),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('Accept'),
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


                  } catch (e) {
                    showDialog<void>(
                      context: context,
                      barrierDismissible: false, // user must tap button!
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Error'),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: const <Widget>[
                                Text('Please check the credentials to proceed!'),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Accept'),
                              onPressed: () {
                                Navigator.of(context).pop();


                              },
                            ),
                          ],
                          elevation: 24,
                        );
                      },
                    );
                    print(e);
                  }
                },
                  color: Color.fromRGBO(151, 191, 180, 1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                  minWidth: 200.0,
                  height: 52.0,
                  child: Text("Login",style: TextStyle(fontSize: 24,color: Colors.white,fontFamily: 'Vidaloka'),),
                ),
              ),
              SizedBox(height: 20,),
              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [Text("Not Registered",style: TextStyle(fontSize: 21,color: Colors.white),),
                  TextButton(onPressed: (){
                    Navigator.pushNamed(context, '/reg');
                  }, child: Text("Register Here!",style: TextStyle(fontSize: 21,color: Colors.white),)),
                ],
              )
            ],),
          ),
        ),
      ),
    );
  }
}
