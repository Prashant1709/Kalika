import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
class ch4 extends StatefulWidget {
  const ch4({Key? key}) : super(key: key);

  @override
  _ch4State createState() => _ch4State();
}

class _ch4State extends State<ch4> {
  final _auth= FirebaseAuth.instance;
  FirebaseAuth auth=FirebaseAuth.instance;
  final firestoreInstance = FirebaseFirestore.instance;
  String ptext="";
  String eurl="";
  String hurl="";
  var link;
  int lan=1;
  int prg=4;
  String ud="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firestoreInstance.collection("Language").doc("Chapter4").snapshots().listen((event) {
      ptext=event.get("English");
      eurl=event.get("ea");
      hurl=event.get("ha");
      print(eurl);
    });
    final newUser = _auth.currentUser;
    //print(newUser?.uid);
    ud=newUser!.uid;
  }
  Future<void> _launch(String url) async {
    if (!await launch(
      url,
      forceSafariVC: false,
      forceWebView: true,
      headers: <String, String>{'my_header_key': 'my_header_value'},
    )) {
      throw 'Could not launch $url';
    }
  }
  void chooselan(){
    showDialog(context: context, builder:(BuildContext context){
      return AlertDialog(
        title: Text("Choose Language"),
        content:Row(
          children: [
            FloatingActionButton.extended(
              onPressed: () {

                setState(() {
                  lan=1;
                  firestoreInstance.collection("Language").doc("Chapter4").snapshots().listen((event) {
                    ptext=event.get("English");
                  });
                });
                Navigator.pop(context);
              },
              label: const Text('English'),
              icon: const Icon(Icons.translate),
              backgroundColor: Color.fromRGBO(79, 9, 29,1),
            ),
            SizedBox(width: 10,),
            FloatingActionButton.extended(
              onPressed: () {

                setState(() {
                  lan=2;
                  firestoreInstance.collection("Language").doc("Chapter4").snapshots().listen((event) {
                    ptext=event.get("Hindi");
                  });
                });
                Navigator.pop(context);
              },
              label: const Text('Hindi'),
              icon: const Icon(Icons.translate),
              backgroundColor: Color.fromRGBO(79, 9, 29,1),
            ),
          ],
        ),
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          chooselan();
        },
        label: const Text('Language'),
        icon: const Icon(Icons.language),
        backgroundColor: Color.fromRGBO(79, 9, 29,1),
      ),
      appBar: AppBar(
        backgroundColor:Color.fromRGBO(79, 9, 29,1),
        centerTitle: true,

        title: Text("DON'T BE ASHAMED?"),
        titleTextStyle: TextStyle(fontSize: 20,letterSpacing: 2,fontFamily: 'Vidaloka'),
      ),
      body: SingleChildScrollView(child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(onPressed: (){
                if(lan==1){
                  _launch(eurl);}
                else if(lan==2){
                  _launch(hurl);
                }}, icon: Icon(Icons.play_arrow)),
            ],),
          StreamBuilder<Object>(
              stream: firestoreInstance.collection("Language").doc("Chapter4").snapshots(),
              builder: (context, snapshot) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("$ptext",textAlign: TextAlign.justify,style: TextStyle(fontSize: 20),),
                );
              }
          ),
          Row(mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 5,),
              MaterialButton(onPressed: (){
                setState(() {
                  prg=4;
                });
                firestoreInstance.collection('$ud').doc('prg').update({'progress':prg,});Navigator.pop(context);
              },
                color:Color.fromRGBO(79, 9, 29,1),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                minWidth: 100.0,
                height: 42.0,
                child: Text("Mark Done",style: TextStyle(fontSize: 24,color: Colors.white),),),
            ],
          ),
        ],
      ),),
    ),);
  }
}
