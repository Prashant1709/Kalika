import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quotes/quotes.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:location/location.dart';
import 'package:map_launcher/map_launcher.dart';
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
  String news1="",news1u="",news1t="";
  String news2="",news2u="",news2t="";
  String news3="",news3u="",news3t="";
  String news4="",news4u="",news4t="";
  int pdur=0;
  String track="";
  var date;
  var diff;
  var datdate;
  int prg=0;
  double progress=0.0;
  double disp=0;
  @override
  void initState() {
    super.initState();
    getdat();
    quotes();
    article();

  }
  Future<void> getloc() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    //location.enableBackgroundMode(enable: true);
    _locationData = await location.getLocation();
    print(_locationData);
    final availableMaps = await MapLauncher.installedMaps;
    print(availableMaps); // [AvailableMap { mapName: Google Maps, mapType: google }, ...]

    await availableMaps.first.showMarker(
      coords: Coords(20.243116, 85.759110),
      title: "Nearest Store",
    );
  }
  void quotes(){
    qod=Quotes.getRandom().getContent();
    print(qod);
  }
  _Call() async {
    const url = 'tel:+91 79781 18439';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  _CallD() async {
    const url = 'tel:+91 9172420601';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  Future<void> _download(String url) async {
    if (!await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,
      headers: <String, String>{'my_header_key': 'my_header_value'},
    )) {
      throw 'Could not launch $url';
    }
  }
  void article(){
    firestoreInstance.collection("News").doc("News1").snapshots().listen((result) {
      news1=result.get("url");
      news1t=result.get("text");
      news1u=result.get("photourl");
    });
    firestoreInstance.collection("News").doc("News2").snapshots().listen((result) {
      news2=result.get("url");
      news2t=result.get("text");
      news2u=result.get("photourl");
    });
    firestoreInstance.collection("News").doc("News3").snapshots().listen((result) {
      news3=result.get("url");
      news3t=result.get("text");
      news3u=result.get("photourl");
    });
    firestoreInstance.collection("News").doc("News4").snapshots().listen((result) {
      news4=result.get("url");
      news4t=result.get("text");
      news4u=result.get("photourl");
    });
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
      firestoreInstance.collection('$ud').doc('PData').snapshots().listen((event) {
        Timestamp timestamp=event.get("Start Date");
        datdate=DateTime.fromMicrosecondsSinceEpoch(timestamp.microsecondsSinceEpoch);
        pdur=event.get("Duration");
      });
      date = DateTime.now().toString();
      firestoreInstance.collection('$ud').doc('prg').snapshots().listen((event) {
        prg=event.get('progress');
        //print(prg);
      });
      progress=prg/4;
      disp=progress*100;
      //print(progress);
    }
    void time(){
    diff=DateTime.parse(date).difference(datdate).inDays;
    if(diff<pdur){
      setState(() {
        var chk=pdur-diff;
        track="$chk days to next cycle";
      });
    }
    else if(diff==pdur){
      setState(() {
        track="Cycle Starts Today";
      });
    }
    else if(diff>pdur){
      setState(() {
        diff=7-diff;
        track="$diff days into cycle";
      });
    }
    else if((7-diff)==0){
      setState(() {
        firestoreInstance.collection('$ud').doc('PData').set({'Duration':pdur,'Start Date':date});
        track="$pdur days to next cycle";
      });
    }
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
            bottom: const TabBar(
              labelColor: Color.fromRGBO(255, 247, 240,1),
              indicatorColor: Color.fromRGBO(255, 247, 240,1),
              tabs: [
                Tab(icon: Icon(Icons.home)),
                Tab(icon: Icon(Icons.campaign)),
                Tab(icon: Icon(Icons.queue_sharp)),
                Tab(icon: Icon(Icons.volunteer_activism)),
                Tab(icon: Icon(Icons.map)),
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
                  leading: Icon(Icons.refresh,
                    size: 25,
                    color: Colors.teal.shade200,) ,
                  title: Text('Refresh'),
                  onTap: () {
                    time();
                    getdat();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.supervised_user_circle,
                    size: 25,
                    color: Colors.teal.shade200,) ,
                  title: Text('About Us'),
                  onTap: () {
                    //Navigator.pushNamed(context, '/pnt');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.exit_to_app,
                    size: 25,
                    color: Colors.teal.shade200,) ,
                  title: Text('Log Out'),
                  onTap: () {
                    _auth.signOut();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          body:TabBarView(
            children: [
              SingleChildScrollView(
                child: Container(
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
                                      children:<Widget>[
                                        Center(child: Text("$track",textAlign:TextAlign.center,style: TextStyle(fontSize:24,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold,fontFamily: 'poppins'),)),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20,),
                                  TextButton(onPressed: (){Navigator.pushNamed(context, '/trc');},style: TextButton.styleFrom(backgroundColor: Color.fromRGBO(79, 9, 29,1)),child: Text("Track Me",style: TextStyle(fontSize:22,fontFamily: 'Poppins',color: Colors.white),))
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
                                            child: StreamBuilder<Object>(
                                              stream: firestoreInstance.collection('$ud').doc('prg').snapshots(),
                                              builder: (context, snapshot) {
                                                return CircularProgressIndicator(
                                                  strokeWidth: 15,
                                                  value: progress,
                                                  color: Color.fromRGBO(79, 9, 29,1),
                                                );
                                              }
                                            ),
                                            width: 200,
                                            height:200,
                                        ),
                                      ),
                                        Center(child: Row(
                                          children: [
                                            Text("\t\t\t\t\t\t $disp%",textAlign:TextAlign.center,style: TextStyle(fontSize:20,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold,fontFamily: 'poppins'),),
                                          ],
                                        )),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20,),
                                  TextButton(onPressed: (){getdat();},style: TextButton.styleFrom(backgroundColor: Color.fromRGBO(79, 9, 29,1)),child: Text("Completed",style: TextStyle(fontSize:22,fontFamily: 'Poppins',color: Colors.white),))
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
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(child: Text("Tip Of the Day",style: TextStyle(fontFamily: 'Poppins',fontWeight: FontWeight.bold,fontStyle: FontStyle.italic,fontSize:24,color: Color.fromRGBO(79, 9, 29,1)),)),
                                    ),
                                    Container(height: 118,child: Image.network("https://res.cloudinary.com/mtree/w_1600,f_auto,dpr_auto/Whisper-IN/6myW8sa9UyyyKaD69OFuua/d094fbd6fe43b5fcc1b94b44365af759/DT_Clothing_Choices_2x.png")),
                                    SizedBox(height: 10,),
                                    Text("Clothing Choices - It is best to avoid tight clothes or fabric that sticks to your body such as spandex. Soft cotton underwear and loose-fitting clothes will help you stay fresh and dry, keeping moisture at bay",style: TextStyle(fontFamily: 'Poppins',fontWeight: FontWeight.bold,fontStyle: FontStyle.italic,fontSize:14,color: Color.fromRGBO(79, 9, 29,1)),textAlign: TextAlign.center,),
                                  ],
                                ),
                              ),
                              width: 350,
                              height: 300,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                color: Color.fromRGBO(151, 191, 180, 1),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 20,),
                      Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton(onPressed: (){
                            _download(news1);
                          },
                            style: OutlinedButton.styleFrom(
                              side:BorderSide(
                                color: Color.fromRGBO(151, 191, 180, 1),
                              ),
                            ),
                            child: StreamBuilder<Object>(
                              stream: firestoreInstance.collection("News").doc("News1").snapshots(),
                              builder: (context, snapshot) {
                                return Container(
                                  child: Card(color: Color.fromRGBO(255, 221, 200, 1),shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                    elevation: 0,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(child: Text("This Weeks Breaking",style: TextStyle(fontFamily: 'Poppins',fontWeight: FontWeight.bold,fontStyle: FontStyle.italic,fontSize:24,color: Color.fromRGBO(79, 9, 29,1)),)),
                                        ),
                                        Container(child: Image.network(news1u),height: 100,),
                                        SizedBox(height: 10,),
                                        Text("$news1t",style: TextStyle(fontFamily: 'Poppins',fontWeight: FontWeight.bold,fontStyle: FontStyle.italic,fontSize:14,color: Color.fromRGBO(79, 9, 29,1)),textAlign: TextAlign.center,)
                                      ],
                                    ),
                                  ),
                                  width: 350,
                                  height: 200,
                                );
                              }
                            ),
                          ),
                        ],
                      ),
                      Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton(onPressed: (){
                            _download(news2);
                          },
                            style: OutlinedButton.styleFrom(
                              side:BorderSide(
                                color: Color.fromRGBO(151, 191, 180, 1),
                              ),
                            ),
                            child: StreamBuilder<Object>(
                                stream: firestoreInstance.collection("News").doc("News2").snapshots(),
                                builder: (context, snapshot) {
                                  return Container(
                                    child: Card(color: Color.fromRGBO(255, 221, 200, 1),shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                      elevation: 0,
                                      child: Column(
                                        children: [
                                          SizedBox(height: 20,),
                                          Container(child: Image.network(news2u),height: 120,),
                                          SizedBox(height: 10,),
                                          Text("$news2t",style: TextStyle(fontFamily: 'Poppins',fontWeight: FontWeight.bold,fontStyle: FontStyle.italic,fontSize:14,color: Color.fromRGBO(79, 9, 29,1)),textAlign: TextAlign.center,)
                                        ],
                                      ),
                                    ),
                                    width: 350,
                                    height: 200,
                                  );
                                }
                            ),
                          ),
                        ],
                      ),
                      Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton(onPressed: (){
                            _download(news3);
                          },
                            style: OutlinedButton.styleFrom(
                              side:BorderSide(
                                color: Color.fromRGBO(151, 191, 180, 1),
                              ),
                            ),
                            child: StreamBuilder<Object>(
                                stream: firestoreInstance.collection("News").doc("News3").snapshots(),
                                builder: (context, snapshot) {
                                  return Container(
                                    child: Card(color: Color.fromRGBO(255, 221, 200, 1),shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                      elevation: 0,
                                      child: Column(
                                        children: [
                                          SizedBox(height: 20,),
                                          Container(child: Image.network(news3u),height: 120,),
                                          SizedBox(height: 10,),
                                          Text("$news3t",style: TextStyle(fontFamily: 'Poppins',fontWeight: FontWeight.bold,fontStyle: FontStyle.italic,fontSize:14,color: Color.fromRGBO(79, 9, 29,1)),textAlign: TextAlign.center,)
                                        ],
                                      ),
                                    ),
                                    width: 350,
                                    height: 200,
                                  );
                                }
                            ),
                          ),
                        ],
                      ),
                      Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton(onPressed: (){
                            _download(news4);
                          },
                            style: OutlinedButton.styleFrom(
                              side:BorderSide(
                                color: Color.fromRGBO(151, 191, 180, 1),
                              ),
                            ),
                            child: StreamBuilder<Object>(
                                stream: firestoreInstance.collection("News").doc("News4").snapshots(),
                                builder: (context, snapshot) {
                                  return Container(
                                    child: Card(color: Color.fromRGBO(255, 221, 200, 1),shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                      elevation: 0,
                                      child: Column(
                                        children: [
                                          SizedBox(height: 20,),
                                          Container(child: Image.network(news4u),height: 120,),
                                          SizedBox(height: 10,),
                                          Text("$news4t",style: TextStyle(fontFamily: 'Poppins',fontWeight: FontWeight.bold,fontStyle: FontStyle.italic,fontSize:14,color: Color.fromRGBO(79, 9, 29,1)),textAlign: TextAlign.center,)
                                        ],
                                      ),
                                    ),
                                    width: 350,
                                    height: 200,
                                  );
                                }
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SingleChildScrollView(
                child: SafeArea(child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(height: 20,),
                    Text("Choose your chapter",style: TextStyle(fontFamily: 'Poppins',fontWeight: FontWeight.bold,fontSize:20,color: Color.fromRGBO(79, 9, 29,1)),textAlign: TextAlign.center,),
                    Container(child: ListView(padding: EdgeInsets.all(8.0),
                    children: [
                      Divider(),
                      ListTile(
                        onTap: (){Navigator.pushNamed(context, '/ch1');},
                        tileColor: Colors.amber.shade900,
                        title: Text("WHAT ARE PERIODS ?",textAlign: TextAlign.center,style: TextStyle(fontFamily: 'Poppins',fontWeight: FontWeight.bold,fontSize:20,color: Colors.white)),
                      ),
                      Divider(),
                      ListTile(onTap: (){Navigator.pushNamed(context, '/ch2');},
                        tileColor: Colors.amber.shade800,
                        title: Text("WHY DO THEY HAPPEN ?",textAlign: TextAlign.center,style: TextStyle(fontFamily: 'Poppins',fontWeight: FontWeight.bold,fontSize:20,color: Colors.white)),
                      ),
                      Divider(),
                      ListTile(onTap: (){Navigator.pushNamed(context, '/ch3');},
                        tileColor: Colors.amber.shade700,
                        title: Text("WHAT YOU MIGHT EXPERIENCE?",textAlign: TextAlign.center,style: TextStyle(fontFamily: 'Poppins',fontWeight: FontWeight.bold,fontSize:20,color: Colors.white)),
                      ),
                      Divider(),
                      ListTile(onTap: (){Navigator.pushNamed(context, '/ch4');},
                        tileColor: Colors.amber.shade600,
                        title: Text("DON'T BE ASHAMED!",textAlign: TextAlign.center,style: TextStyle(fontFamily: 'Poppins',fontWeight: FontWeight.bold,fontSize:20,color: Colors.white)),
                      ),
                      Divider(),
                    ],
                    ),height: MediaQuery.of(context).size.height,),
                  ],
                ),)),
              ),
              Container(
                color: Color.fromRGBO(151, 191, 180, 1),
                child: Column(
                children: [
                  SizedBox(height: 10,),
                  Text("You Come First , Connect to us or a Professional Doctor",style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Poppins',fontStyle: FontStyle.italic,),textAlign: TextAlign.center,),
                  SizedBox(height: 40,),
                  Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(onPressed: (){
                        _Call();
                      },
                        style: OutlinedButton.styleFrom(
                          side:BorderSide(
                            color: Color.fromRGBO(151, 191, 180, 1),
                          ),
                        ),
                        child:  Container(
                                child: Card(color: Color.fromRGBO(255, 221, 200, 1),shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                  elevation: 0,
                                  child: Column(
                                    children: [
                                      SizedBox(height: 20,),
                                      IconButton(onPressed: (){_Call();}, icon: const Icon(Icons.phone),iconSize: 100,color: Colors.blue,tooltip: 'Call Helpline',),
                                      SizedBox(height: 10,),
                                      Text("Call Our HelpLine",style: TextStyle(fontFamily: 'Poppins',fontWeight: FontWeight.bold,fontStyle: FontStyle.italic,fontSize:28,color: Color.fromRGBO(79, 9, 29,1)),textAlign: TextAlign.center,)
                                    ],
                                  ),
                                ),
                                width: 350,
                                height: 200,

                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40,),
                  Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(onPressed: (){
                        _CallD();
                      },
                        style: OutlinedButton.styleFrom(
                          side:BorderSide(
                            color: Color.fromRGBO(151, 191, 180, 1),
                          ),
                        ),
                        child:  Container(
                          child: Card(color: Color.fromRGBO(255, 221, 200, 1),shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                            elevation: 0,
                            child: Column(
                              children: [
                                SizedBox(height: 20,),
                                IconButton(onPressed: (){_CallD();}, icon: const Icon(Icons.person),iconSize: 100,color: Colors.deepOrangeAccent,tooltip: 'Call Helpline',),
                                SizedBox(height: 10,),
                                Text("Call Doctor",style: TextStyle(fontFamily: 'Poppins',fontWeight: FontWeight.bold,fontStyle: FontStyle.italic,fontSize:28,color: Color.fromRGBO(79, 9, 29,1)),textAlign: TextAlign.center,)
                              ],
                            ),
                          ),
                          width: 350,
                          height: 200,

                        ),
                      ),
                    ],
                  ),
                ],
                ),
              ),
              Container(
                color: Color.fromRGBO(151, 191, 180, 1),
                child: Column(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 10,),
                    Text("You Come First , Find nearest Medical Store",style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Poppins',fontStyle: FontStyle.italic,),textAlign: TextAlign.center,),
                    SizedBox(height: 40,),
                    MaterialButton(onPressed: (){getloc();},
                      color:Color.fromRGBO(79, 9, 29,1),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                      minWidth: 200.0,
                      height: 52.0,
                      child: Text("Find Store",style: TextStyle(fontSize: 24,color: Colors.white),),),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}