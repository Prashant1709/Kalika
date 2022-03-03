import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
class tracker extends StatefulWidget {
  const tracker({Key? key}) : super(key: key);

  @override
  _trackerState createState() => _trackerState();
}

class _trackerState extends State<tracker> {
  final dateController = TextEditingController();
  final _auth= FirebaseAuth.instance;
  FirebaseAuth auth=FirebaseAuth.instance;
  final firestoreInstance = FirebaseFirestore.instance;
  var dates;
  int pdur = 10;
  String ud="";
  String name="";
  @override
  void initState() {
    getdat();
    super.initState();
  }
  @override
  Future<void> getdat() async {
    final newUser = _auth.currentUser;
    //print(newUser?.uid);
    ud=newUser!.uid;
    firestoreInstance
        .collection('$ud').doc('Data').snapshots()
        .listen((result)  {
      name=result.get("Name");
    });
  }
  void setData(){
    firestoreInstance.collection('$ud').doc('PData').set({'Start Date':dates,'Duration':pdur});
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: const Text("Confirmation"),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text('Hi!'),
              SizedBox(height: 20,),
              Text('Your cycle is being calculated and will be shown on home page'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Proceed'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
        elevation: 24,
      );
    });
  }
  void dispose() {
    // Clean up the controller when the widget is removed
    dateController.dispose();
    super.dispose();
  }
  void _incrementCounter() {
    setState(() {
      pdur++;
    });
  }
  void _decrementCounter() {
    setState(() {
      pdur--;
    });
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton:FloatingActionButton(onPressed: (){Navigator.pop(context);},backgroundColor: Color.fromRGBO(79, 9, 29,1),child: Icon(Icons.arrow_back),),
        body: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Select When your last period started",style: TextStyle(fontFamily: 'Poppins',fontWeight: FontWeight.bold,fontSize:20,color: Color.fromRGBO(79, 9, 29,1)),textAlign: TextAlign.center,),
            SizedBox(height: 10,),
            Row(mainAxisAlignment:MainAxisAlignment.center,children: [
              Center(
                child: Container(width: 90,
                  height: 100,
                  child: TextField(
                    autofocus: false,
                    readOnly: true,
                    controller: dateController,
                    cursorColor: Color.fromRGBO(79, 9, 29,1),
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Color.fromRGBO(79, 9, 29,1),fontSize: 22),
                        hintText: 'Choose',
                    ),
                    onTap: () async {
                      dates =  await showDatePicker(
                          context: context,
                          initialDate:DateTime.now(),
                          firstDate:DateTime(1900),
                          lastDate: DateTime(2100));
                      dateController.text = dates.toString().substring(0,10);
                    },),
                ),
              ),
            ],),
            Text("Select the length of your cycle",style: TextStyle(fontFamily: 'Poppins',fontWeight: FontWeight.bold,fontSize:20,color: Color.fromRGBO(79, 9, 29,1)),textAlign: TextAlign.center,),
            SizedBox(height: 20,),
            Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [
              FloatingActionButton(
                onPressed: _decrementCounter,
                tooltip: 'Decrement',
                child: const Icon(Icons.exposure_minus_1,color: Colors.white,),
                backgroundColor: Color.fromRGBO(79, 9, 29,1),
              ),
              SizedBox(width: 20,),
              Text("$pdur",style: TextStyle(fontFamily: 'Poppins',fontWeight: FontWeight.bold,fontSize:38,color: Color.fromRGBO(79, 9, 29,1)),textAlign: TextAlign.center,),
                SizedBox(width: 20,),
                FloatingActionButton(
                onPressed: _incrementCounter,
                tooltip: 'Increment',
                child: const Icon(Icons.exposure_plus_1,color: Colors.white,),
                  backgroundColor: Color.fromRGBO(79, 9, 29,1),
              ),
            ],),
            SizedBox(height: 60,),
            MaterialButton(onPressed: (){setData();Navigator.pop(context);},
                color:Color.fromRGBO(79, 9, 29,1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        minWidth: 200.0,
        height: 52.0,
        child: Text("Submit",style: TextStyle(fontSize: 24,color: Colors.white),),),

          ],
        ),
      ),
    );
  }
}
