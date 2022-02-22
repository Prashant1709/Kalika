import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class data extends StatefulWidget {
  const data({Key? key}) : super(key: key);

  @override
  _dataState createState() => _dataState();
}
class _dataState extends State<data> {
  final _auth= FirebaseAuth.instance;
  FirebaseAuth auth=FirebaseAuth.instance;
  final firestoreInstance = FirebaseFirestore.instance;
  String name="";
  String Lang="Select Language";
  String pno="";
  String ud="";
  @override
  void initState() {
    super.initState();
    getdat();
  }
  Future<void> getdat() async {
    final newUser = await _auth.currentUser;
    //print(newUser?.uid);
    ud=newUser!.uid;
    print(ud);
  }
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromRGBO(151, 191, 180, 1),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                Row(
                    children: [IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back,color: Colors.black,),)]
                ),
                SizedBox(height: 70,),
                Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Enter the below data",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold ,color: Color.fromRGBO(79, 9, 29, 1)),),
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
                          name = value;},
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(

                          hintText:'Name',
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
                        textInputAction: TextInputAction.next,
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.number,
                        onChanged: (value){
                          pno = value;},
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(

                          hintText:'Phone Number',
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
                  child:DropdownButton(value: Lang,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    iconSize: 24,
                    elevation: 16,
                    style: const TextStyle(color: Colors.deepPurple),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurple,
                    ),
                    onChanged: (String? newValue){
                      setState(() {
                        Lang=newValue!;
                      });
                    },
                    items: <String>['Select Language','English','हिन्दी']
                        .map<DropdownMenuItem<String>>((String value){
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value,style: TextStyle(
                          fontSize: 18,
                        ),),
                      );
                    }).toList(),

                  ),
                ),
                SizedBox(height: 20,),
                Padding(padding: EdgeInsets.all(10.0),
                  child: MaterialButton(onPressed: ()async{
                    try{
                      final newUser = await _auth.currentUser;
                      //print(newUser?.uid);
                      ud=newUser!.uid;
                      if(newUser!=Null)
                      {
                        showDialog<void>(
                          context: context,
                          barrierDismissible: false, // user must tap button!
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Confirmation"),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: const <Widget>[
                                    Text('All entered data is best in my knowledge'),
                                    SizedBox(height: 20,),
                                    Text('Click proceed to go to loging page'),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Proceed'),
                                  onPressed: () {
                                    print(ud);
                                    firestoreInstance.collection('$ud').doc('Data').set({'Name':name,'Phone':pno,'Language':Lang,'Email':newUser.email});
                                    //ref.child("/$ud/name/").set(name);
                                    //ref.child("/$ud/phone/").set(pno);
                                    //ref.child("/$ud/lang/").set(Lang);
                                    //ref.child("/$ud/email/").set(newUser.email);
                                    Navigator.pop(context);
                                    Navigator.of(context).pushNamed('/');
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
                                  Text("Data inconsistant"),
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
                    child: Text("Submit",style: TextStyle(fontSize: 24,color: Colors.white),),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
