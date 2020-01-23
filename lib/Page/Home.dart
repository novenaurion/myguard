import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sms_maintained/sms.dart';
import 'package:call_number/call_number.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
//import 'package:sms/sms.dart';
//import 'package:flutter/services.dart';

class Home extends StatefulWidget{
  final String uid;
  final SharedPreferences prefs;
  

  const Home({Key key, this.uid, this.prefs}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomeState();
  }
}

class _HomeState extends State<Home> {


  final Firestore db=Firestore.instance;
  static String uid;
  String txt_press='Press Me';
  String click;
  String username;
  String bgimage;
  Color cardcolor=Colors.blue;
  List<String> ph_list=[];
  double lat,long;
  String address,_first,_second,_third,_location;
//  static const platform = const MethodChannel('sendSms');

  @override
  initState() {
    super.initState();
    click=widget.prefs.getString('click');
    print(click);
    if(widget.prefs.getString('click')=='0' || widget.prefs.getString('click')==null ) {
      setState(() {
        txt_press = "Click Me";
        bgimage = 'images/homebg.png';
        cardcolor=Colors.blue;
      });
    }
    else if(widget.prefs.getString('click')=='1' ) {
      setState(() {
        txt_press = "Warning";
        bgimage = 'images/warningbg.png';
        cardcolor=Color.fromRGBO(255, 175, 41, 1);
      });
    }
     else if(widget.prefs.getString('click')=='2' ) {
      setState(() {
        txt_press = "Danger ";
        bgimage = 'images/dangerbg.png';
        cardcolor=Color.fromRGBO(217, 83,79, 1);
      });
    }
  }

  _initCall(String  ph_no) async{
    print(ph_no);
    await new CallNumber().callNumber(ph_no);
  }



  @override
  Widget build(BuildContext context) {
    uid=widget.uid;
    if(widget.prefs.getString('click')==0){
      setState(() {
        txt_press="Click Me";
        bgimage='images/homebg.png';
        widget.prefs.setString('click','1');
      });
    }

    db.collection('users').document(uid)
    .get()
    .then((DocumentSnapshot ds){
      ph_list.add(ds.data['first']);
      ph_list.add(ds.data['second']);
      ph_list.add(ds.data['third']);
      lat=ds.data['lat'];
      long=ds.data['long'];
      username=ds.data['username'];

    });

//    Scaffold.of(context).showSnackBar(SnackBar(content: Text(_first)));
    // TODO: implement build
    if(bgimage==null){
      return Container(
        child: Center(
          child: Text("Loading"),
        ),
      );
    }
    else {
      return Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
              image:AssetImage(bgimage),
              fit: BoxFit.cover
          ),
        ),
        child:Center(
          child:Material(
            type:MaterialType.transparency,
            child: InkWell(
                child: Container(

                    width: 420.0,
                    decoration: new BoxDecoration(
                      shape:BoxShape.circle,
                      color: cardcolor,
                    ),

                    child: Center(child: Text(txt_press,style: TextStyle(color: Colors.white,fontSize:30.0),))
                ),
                onTap: () async {
                  if(widget.prefs.getString("click")==null ||widget.prefs.getString('click')=='0'){
                    setState(() {
                      cardcolor=Color.fromRGBO(255, 175, 41, 1);
                      bgimage='images/warningbg.png';
                      txt_press='Warning State';
                      widget.prefs.setString('click','1');
                    });

                    sendSms(ph_list,"I'm in Danger");
                    sendNoti();
                  }
                  else if(widget.prefs.getString('click')=='1' || widget.prefs.getString('click')=='2'){
                    setState(() {
                      cardcolor=Color.fromRGBO(217, 83,79, 1);
                      bgimage='images/dangerbg.png';
                      txt_press='Danger State';
                      widget.prefs.setString('click','2');
                    });
                    _initCall('09978125396');
                    sendNoti();
                  }
                },
                onDoubleTap:(){

                  _initCall('09978125396');
                  sendNoti();
//          sendSms(ph_list,"Please Help Me,Hurry");
                }),
          ),
        ),
      );
    }
  }



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

  void sendNoti() {
    Firestore.instance.collection('users')
        .getDocuments().then((QuerySnapshot qs) {
      double distance;
      int dis;
      qs.documents.forEach((ele) async =>
      {
        if(ele.documentID!=uid){
          print("good for you"),
          distance=await Geolocator().distanceBetween(
          lat,long, ele.data['lat'],
          ele.data['long']),
          print(distance),
          if(distance<10000.00){
            print('Godd'),
              Firestore.instance.collection('showuser').add({
                'message':username+' is in trouble now.'+distance.toInt().toString()+ ' meter around you.Go and help.',
                'sender':uid,
                'showuser':ele.documentID,
                'forhelp':'forhelp',
                'timestamp':new DateTime.now().millisecondsSinceEpoch
              })
          }
        }
      });
        Firestore.instance.collection('showuser').add({
          'message':"You Asked For Help",
          'showuser':uid,
          'sender':uid,
          'forhelp':'askedhelp',
          'timestamp':new DateTime.now().millisecondsSinceEpoch
        });


    });
  }
}