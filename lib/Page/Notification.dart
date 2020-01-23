import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sms_maintained/sms.dart';
class NotificationPage extends StatefulWidget{
  final String uid;
  final SharedPreferences prefs;

  const NotificationPage({Key key, this.uid, this. prefs}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _NotificationState();
  }
}

class _NotificationState extends State<NotificationPage>{
  String uid;
  var stream;
  final Firestore _db = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  double lat,long;
  List<String> ph_list=[];
  double dis_lat,dis_long;
  String address;
  String username;

  @override
  void initState() {
    setState(() {
      print(widget.uid);
      stream = moveStream(widget.uid);
    });

    super.initState();
  }

  Stream<QuerySnapshot> moveStream(String uid1) {
    return  _db.collection('showuser').where('showuser',isEqualTo: uid1).orderBy('timestamp',descending: true).snapshots();
  }


  @override
  Widget build(BuildContext context) {
    uid=widget.uid;


    Firestore.instance.collection('users').document(uid)
        .get()
        .then((DocumentSnapshot ds){
      lat=ds.data['lat'];
      long=ds.data['long'];
      username=ds.data['username'];
      ph_list.add(ds.data['first']);
      ph_list.add(ds.data['second']);
      ph_list.add(ds.data['third']);

    });
    // TODO: implement build
    return StreamBuilder(
      stream:  _db.collection('showuser').where('showuser',isEqualTo: uid).orderBy('timestamp',descending: true).snapshots(),
      builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData)
          return new Text('Error');
        else {
          List item = [];
          snapshot.data.documents.forEach((document) {
            item.add({
              'message': document.data['message'],
              'documentid': document.documentID,
              'forhelp':document.data['forhelp'],
              'sender': document.data['sender'],

            });
          });
          return ListView.builder(
              itemCount: item.length,
              itemBuilder: (context, index) {
                if (item[index]['forhelp'] == 'askedhelp') {
                  return new Container(
                    padding: EdgeInsets.all(10.0),
                    width: double.infinity,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[

                        Expanded
                          (
                            child: Row(
                              children: <Widget>[
                                Image.asset(
                                  'images/notiprofile.png', width: 60,),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0, top: 15.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: <Widget>[
                                      Text(item[index]['message'],
                                        style: TextStyle(color: Colors.blue,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.start,),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0),
                                        child: Text('1 minute ago',
                                          style: TextStyle(
                                              color: Colors.blue[500],
                                              fontSize: 15),
                                          textAlign: TextAlign.start,),
                                      ),
                                    ],
                                  ),
                                ),

                              ],
                            )),
                        Container(
                          width: 130.00,
                          height: 60.00,
                          child: InkWell(
                              child: Card(
                                color: Colors.blue,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0)
                                ),
                                child: Center(child: Text("Cancel",
                                  style: TextStyle(color: Colors.white),)),
                              ),
                              onTap: () {
                                sendSms(ph_list,"I'm fine now,Don't Worry");
                                widget.prefs.setString('click', '0');
                                setsafeshowuser(item[index]['documentid']);
                              }
                          ),
                        )
                      ],
                    ),
                  );
                }
                else if (item[index]['forhelp'] == 'forhelp') {
                  return new Container(
                    padding: EdgeInsets.all(10.0),
                    width: double.infinity,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Image.asset('images/notiprofile.png', width: 60,),
                        Expanded
                          (child: Padding(
                          padding: const EdgeInsets.only(
                              top: 15.0, left: 15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(item[index]['message'],
                                style: TextStyle(color: Colors.blue,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.start,),

                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text('1 minute ago',
                                  style: TextStyle(color: Colors.blue[500],
                                      fontSize: 15),
                                  textAlign: TextAlign.start,),
                              ),

                            ],
                          ),

                        ),),
                        InkWell(
                          child: Container(
                            width: 50.0,
                            child: Icon(Icons.near_me,
                              size: 40,
                              color: Colors.blue,),
                          ),
                          onTap: () {
                            getLatLong(item[index]['sender']);
                            String url1 = 'https://www.google.com/maps/search/?api=1&query=' +
                                dis_lat.toString() + ',' +
                                dis_long.toString();
                            String url = 'https://www.google.com/maps/dir/?api=1&orgin=${lat},${long}&destination=${dis_lat},${dis_long}&travelmode=driving&dir_action=navigate';
                            launch(
                                'https://www.google.com/maps/search/?api=1&query=' +
                                    dis_lat.toString() + ',' +
                                    dis_long.toString());
                          },
                        )
                      ],
                    ),
                  );
                }
                else if (item[index]['forhelp'] == 'okstate') {
                  return new Container(
                    padding: EdgeInsets.all(10.0),
                    width: double.infinity,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Expanded
                          (
                            child: Row(
                              children: <Widget>[
                                Image.asset(
                                  'images/notiprofile.png', width: 60,),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0, top: 15.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: <Widget>[
                                      Text(item[index]['message'],
                                          style: TextStyle(color: Colors.blue,
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.start),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8.0),
                                        child: Text('1 second ago',
                                            style: TextStyle(
                                                color: Colors.blue[600],
                                                fontSize: 15)),
                                      )
                                    ],
                                  ),
                                ),

                              ],
                            )),
                      ],
                    ),
                  );
                }
              });
        }
      });
      }

//        switch(snapshot.connectionState){
//          case ConnectionState.waiting: return new Text('Loading');
//          default:
//            return new ListView(
//              children:snapshot.data.documents.map((DocumentSnapshot ds){
//                if(ds.data['forhelp']=='askedhelp'){
//                  return new Container(
//                    padding: EdgeInsets.all(10.0),
//                    width: double.infinity,
//                    child: Row(
//                      mainAxisSize: MainAxisSize.min,
//                      children: <Widget>[
//
//                        Expanded
//                          (
//                            child:Row(
//                            children: <Widget>[
//                              Image.asset('images/notiprofile.png',width: 60,),
//                              Padding(
//                                padding: const EdgeInsets.only(left:15.0,top:15.0),
//                                child: Column(
//                                  crossAxisAlignment: CrossAxisAlignment.start,
//                                children: <Widget>[
//                                Text(ds.data['message'],style: TextStyle(color: Colors.blue,
//                                    fontSize: 17,fontWeight: FontWeight.bold),textAlign: TextAlign.start,),
//                                  Padding(
//                                    padding: const EdgeInsets.only(top:8.0),
//                                    child: Text('1 minute ago',style: TextStyle(color: Colors.blue[500],
//                                        fontSize: 15),textAlign: TextAlign.start,),
//                                  ),
//                                ],
//                                ),
//                              ),
//
//                            ],
//                          )),
//                        Container(
//                          width: 130.00,
//                          height: 60.00,
//                          child: InkWell(
//                            child: Card(
//                              color: Colors.blue,
//                              shape: RoundedRectangleBorder(
//                                borderRadius: BorderRadius.circular(20.0)
//                              ),
//                              child: Center(child: Text("Cancel",style: TextStyle(color: Colors.white),)),
//                            ),
//                            onTap:(){
//                              setsafeshowuser(ds.documentID);
//                            }
//                          ),
//                        )
//                      ],
//                    ),
//                  ) ;
//                }
//                else if(ds.data['forhelp']=='forhelp'){
//                  return new Container(
//                    padding: EdgeInsets.all(10.0),
//                    width: double.infinity,
//                    child: Row(
//                      mainAxisSize: MainAxisSize.min,
//                      children: <Widget>[
//                        Image.asset('images/notiprofile.png',width: 60,),
//                        Expanded
//                          (child:Padding(
//                            padding: const EdgeInsets.only(top:15.0,left:15.0),
//                            child: Column(
//                              crossAxisAlignment: CrossAxisAlignment.start,
//                              children: <Widget>[
//                                Text(ds.data['message'],style: TextStyle(color: Colors.blue,
//                                  fontSize: 17,fontWeight: FontWeight.bold),textAlign: TextAlign.start,),
//
//                                Padding(
//                                  padding: const EdgeInsets.only(top:8.0),
//                                  child: Text('1 minute ago',style: TextStyle(color: Colors.blue[500],
//                                      fontSize: 15),textAlign: TextAlign.start,),
//                                ),
//
//                              ],
//                            ),
//
//                          ),),
//                        InkWell(
//                          child: Container(
//                            width: 50.0,
//                            child: Icon(Icons.near_me,
//                            size: 40,
//                            color: Colors.blue,),
//                          ),
//                          onTap: (){
//                            getLatLong(ds.data['sender']);
//                            String url1='https://www.google.com/maps/search/?api=1&query='+dis_lat.toString()+','+dis_long.toString();
//                            String url= 'https://www.google.com/maps/dir/?api=1&orgin=${lat},${long}&destination=${dis_lat},${dis_long}&travelmode=driving&dir_action=navigate';
//                            launch('https://www.google.com/maps/search/?api=1&query='+dis_lat.toString()+','+dis_long.toString());
//                          },
//                        )
//                      ],
//                    ),
//                  ) ;
//                }
//                else if(ds.data['forhelp']=='okstate'){
//                  return new Container(
//                    padding: EdgeInsets.all(10.0),
//                    width: double.infinity,
//                    child: Row(
//                      mainAxisSize: MainAxisSize.min,
//                      children: <Widget>[
//                        Expanded
//                          (
//                            child:Row(
//                              children: <Widget>[
//                                Image.asset('images/notiprofile.png',width: 60,),
//                                Padding(
//                                  padding: const EdgeInsets.only(left:15.0,top:15.0),
//                                  child: Column(
//                                    crossAxisAlignment: CrossAxisAlignment.start,
//                                    children: <Widget>[
//                                      Text(ds.data['message'],style: TextStyle(color: Colors.blue,
//                                          fontSize: 17,fontWeight: FontWeight.bold),textAlign: TextAlign.start),
//                                      Padding(
//                                        padding: const EdgeInsets.only(top:8.0),
//                                        child: Text('1 second ago',style: TextStyle(color:Colors.blue[600],fontSize: 15)),
//                                      )
//                                    ],
//                                  ),
//                                ),
//
//                              ],
//                            )),
//                      ],
//                    ),
//                  ) ;
//                }
//              }).toList(),
//            );
//        }
//      },
//    );
  void sendSms(List<String> ph_list,String body) {
    for(int i=0;i<ph_list.length; i++) {
      if (i == 0) {
        address = ph_list[0];
      }
      else if (i == 1){
        address = ph_list[1];
      }
      else{
        address = ph_list[2];
      }
      SmsSender sender = new SmsSender();
      SmsMessage message = new SmsMessage(
          address, body);
      message.onStateChanged.listen((state) {
        if (state == SmsMessageState.Delivered) {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(
                '${message.address} received your message.'),
          ));
        }
      });
      sender.sendSms(message);
    }
  }

          void setsafeshowuser(String documentID) {
            Firestore.instance.collection('users')
                .getDocuments().then((QuerySnapshot qs) {
              double distance;

              qs.documents.forEach((ele) async =>
              {
                if(ele.documentID != uid){

                  distance = await Geolocator().distanceBetween(
                      lat, long, ele.data['lat'], ele.data['long']),
                  if(distance < 10000.00){
                    Firestore.instance.collection('showuser').add({
                      'message': username + ' is in Safe State',
                      'forhelp': 'okstate',
                      'showuser': ele.documentID,
                      'timestamp': new DateTime.now().millisecondsSinceEpoch
                    })
                  }
                }
                else
                  {
                    Firestore.instance.collection('showuser').add({
                      'message': 'I Am Save now.',
                      'forhelp': 'okstate',
                      'showuser': ele.documentID,
                      'timestamp': new DateTime.now().millisecondsSinceEpoch
                    }).whenComplete(() {
                      Firestore.instance.collection('showuser').document(
                          documentID).delete();
                    })
                  }
              });
            });
          }

          void getLatLong(String id) {
            Firestore.instance.collection('users').document(id).get().then((
                DocumentSnapshot ds) {
              dis_lat = ds.data['lat'];
              dis_long = ds.data['long'];
            });
          }

          Future<void> _launchURL(String url) async {
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              throw 'Could not launch $url';
            }
          }
        }