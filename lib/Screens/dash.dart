import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quotes/quotes.dart';
class dash extends StatefulWidget {
  const dash({Key? key}) : super(key: key);

  @override
  _dashState createState() => _dashState();
}

class _dashState extends State<dash> {
  final _auth= FirebaseAuth.instance;
  FirebaseAuth auth=FirebaseAuth.instance;
  final firestoreInstance = FirebaseFirestore.instance;
  String name="";
  String ud="";
  String qod="";
  @override
  void initState() {
    super.initState();
    getdat();
    quotes();
    
  }
  void quotes(){
    qod=Quotes.getRandom().getContent();
    print(qod);
  }
  Future<void> getdat() async {
    final newUser = _auth.currentUser;
    //print(newUser?.uid);
    ud=newUser!.uid;
    print(ud);
    firestoreInstance
        .collection('$ud').doc('Data').snapshots()
        .listen((result)  {
      print(result.get("Name"));
      name=result.get("Name");
      });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 5,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor:Color.fromRGBO(79, 9, 29,1),
            centerTitle: true,
            title: Text("Kalika"),
            titleTextStyle: TextStyle(fontSize: 28,letterSpacing: 2,fontFamily: 'Vidaloka'),
            actions: <Widget>[
              IconButton(onPressed: (){getdat();quotes();}, icon: Icon(Icons.lens_blur,color: Color.fromRGBO(255, 247, 240,1),))
            ],
            bottom: const TabBar(
              labelColor: Color.fromRGBO(255, 247, 240,1),
              indicatorColor: Color.fromRGBO(255, 247, 240,1),
              tabs: [
                Tab(icon: Icon(Icons.home)),
                Tab(icon: Icon(Icons.campaign)),
                Tab(icon: Icon(Icons.queue_sharp)),
                Tab(icon: Icon(Icons.volunteer_activism)),
                Tab(icon: Icon(Icons.task)),
              ],
            ),
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(193, 69, 69,1),
                  ),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[
                      CircleAvatar(radius: 28,
                      backgroundImage: NetworkImage("https://clipartspub.com/images/face-clipart-woman-7.jpg")),
                      SizedBox(height: 10,),
                      StreamBuilder<Object>(
                        stream: firestoreInstance.collection('$ud').doc('Data').snapshots(),
                        builder: (context, snapshot) {
                          return Text("Hi $name",style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),);
                        }
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.man,
                    size: 25,
                    color: Colors.teal.shade200,) ,
                  title: Text('About Us'),
                  onTap: () {
                    //Navigator.pushNamed(context, '/pnt');
                  },
                ),
              ],
            ),
          ),
          body:TabBarView(
            children: [
              Container(
                color: Color.fromRGBO(151, 191, 180, 1),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      SizedBox(height: 10,),
                      Text("\"$qod\"",style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Poppins',fontStyle: FontStyle.italic,),textAlign: TextAlign.center,),
                      SizedBox(height: 40,),
                      IntrinsicHeight(
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [

                            Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 120,
                                  width: 120,
                                  child: Stack(
                                    children:<Widget>[ Center(
                                      child: Container(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 15,
                                            value: 0.7,

                                            color: Color.fromRGBO(79, 9, 29,1),
                                          ),
                                          width: 200,
                                          height:200,
                                      ),
                                    ),
                                      Center(child: Row(
                                        children: [
                                          Text("\t\t\t\t\t\t\t\t\t7/21",textAlign:TextAlign.center,style: TextStyle(fontSize:16,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold,fontFamily: 'poppins'),),
                                        ],
                                      )),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20,),
                                Text("Days Left",style: TextStyle(fontSize:22,fontFamily: 'Poppins',color: Colors.white),)
                              ],
                            ),
                            VerticalDivider(
                              thickness: 2,
                              indent: 5,
                              endIndent: 15,
                            ),
                            Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 120,
                                  width: 120,
                                  child: Stack(
                                    children:<Widget>[ Center(
                                      child: Container(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 15,
                                            value: 0.7,
                                            color: Color.fromRGBO(79, 9, 29,1),
                                          ),
                                          width: 200,
                                          height:200,
                                      ),
                                    ),
                                      Center(child: Row(
                                        children: [
                                          Text("\t\t\t\t\t\t\t\t\t\t21%",textAlign:TextAlign.center,style: TextStyle(fontSize:16,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold,fontFamily: 'poppins'),),
                                        ],
                                      )),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20,),
                                Text("Completed",style: TextStyle(fontSize:22,fontFamily: 'Poppins',color: Colors.white),)
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20,),
                      Divider(indent: 15,endIndent: 15,thickness: 2,),
                      SizedBox(height: 20,),
                      Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Card(color: Color.fromRGBO(255, 221, 200, 1),shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                              elevation: 0,
                              child: Column(
                                children: [
                                  Center(child: Text("Tip Of the Day",style: TextStyle(fontFamily: 'Poppins',fontWeight: FontWeight.bold,fontStyle: FontStyle.italic,fontSize:24,color: Color.fromRGBO(79, 9, 29,1)),)),
                                  SizedBox(height: 60,),
                                  Text("Here Goes the tip"),
                                ],
                              ),
                            ),
                            width: 300,
                            height: 200,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                color: Color.fromRGBO(151, 191, 180, 1),
                child: Column(),
              ),
              Container(
                color: Color.fromRGBO(151, 191, 180, 1),
                child: Column(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(height: 150,width: 250,
                    child: Card(elevation: 20,
                      child: Text("Welcome! $name",style: TextStyle(fontSize: 27,color: Colors.red),),
                    ),
                  ),
                ],),
              ),
              Container(
                color: Color.fromRGBO(151, 191, 180, 1),
                child: Column(),
              ),
              Container(
                color: Color.fromRGBO(151, 191, 180, 1),
                child: Column(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}