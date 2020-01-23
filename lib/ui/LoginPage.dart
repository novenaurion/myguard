import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:myguard/ui/ButtonNavigationBarHome.dart';
import 'package:myguard/ui/SignUpPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class LoginPage extends StatefulWidget{
  final SharedPreferences prefs;

  const LoginPage({Key key, this.prefs}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return  _LogInState();
  }

}

class  _LogInState extends State<LoginPage> {
  static final GlobalKey<FormState> _formkey = new GlobalKey<FormState>();
  final FirebaseMessaging _fcm = FirebaseMessaging();
  String _email, _password;
  Position currentPosition;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
//      body: ListView(
//        children: <Widget>[
//          Container(
//            margin: EdgeInsets.only(top: 200.0),
//            width: double.infinity,
//
//            child: Padding(
//              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
//              child: Column(
//                mainAxisSize: MainAxisSize.min,
//                children: <Widget>[
//                  Container(
//                    child: Card(
//                      child: Form(
//                        key: _formkey,
//                        child: Column(
//                          children: <Widget>[
//                            SizedBox(
//                              height: 20.0,
//                            ),
//                            Container(
//                              child: Text(" LOGIN",
//                                style: TextStyle(fontSize: 20.0),
//                              ),
//                            ),
//                            SizedBox(
//                              height: 20.0,
//                            ),
//                            Padding(
//                              padding: const EdgeInsets.all(8.0),
//                              child: Container(
//                                  child: TextFormField(
//                                    validator: (str) {
//                                      if (str.isEmpty) {
//                                        return "required gmail";
//                                      }
//                                    },
//                                    onSaved: (input) => _email = input,
//                                    decoration: InputDecoration(
//                                        icon: Icon(Icons.mail),
//                                        hintText: "Enter Gmail"
//                                    ),
//                                  )
//                              ),
//                            ),
//                            SizedBox(
//                              height: 20.0,
//                            ),
//                            Padding(
//                              padding: const EdgeInsets.all(8.0),
//                              child: Container(
//                                  child: TextFormField(
//                                    obscureText: true,
//                                    validator: (str) {
//                                      if (str.isEmpty) {
//                                        return "required password";
//                                      }
//                                    },
//                                    onSaved: (input) => _password = input,
//                                    decoration: InputDecoration(
//                                        icon: Icon(Icons.lock),
//                                        hintText: "Enter password"
//                                    ),
//                                  )
//                              ),
//                            ),
//                            SizedBox(
//                              height: 20.0,
//                            ),
//                            Padding(
//                              padding: const EdgeInsets.all(8.0),
//                              child: Container(
//                                width: double.infinity,
//                                child: FlatButton(
//                                    color: Colors.blue,
//                                    textColor: Colors.white,
//                                    onPressed: () async {
//                                      final formstate = _formkey.currentState;
//                                      formstate.save();
//                                      AuthResult authresult = await FirebaseAuth
//                                          .instance.signInWithEmailAndPassword(
//                                          email: _email, password: _password);
//                                      currentPosition=await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//                                      FirebaseUser user = authresult.user;
//                                      Firestore.instance.collection('users')
//                                          .document(user.uid)
//                                          .updateData({'isOnline': true,'lat':currentPosition.latitude,'long':currentPosition.longitude})
//                                          .whenComplete(() {
//                                        Navigator.push(
//                                            context,
//                                            MaterialPageRoute(
//                                                builder: (context) =>
//                                                    ButtonNavigationBarHome(
//                                                        uid: user.uid)));
//                                      });
//                                    },
//
////                                onPressed: (){
//
////                                },
//                                    child: Text("Log In")),
//                              ),
//                            ),
//
//                            Container(
//                              margin: EdgeInsets.only(bottom: 10.0, top: 10.0),
//                              child: Center(
//                                child: InkWell(
//                                  child: Text("No Account? Sign up Here!",),
//                                  onTap: () {
//                                    Navigator.push(
//                                        context,
//                                        MaterialPageRoute(builder: (context) =>
//                                            SignUpPage()));
//                                  },
//                                ),
//                              ),
//                            )
//                          ],
//                        ),
//                      ),
//                    ),
//                  ),
//                ],
//              ),
//            ),
//          ),
//        ],),
        body:Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image:AssetImage('images/login.png'),
                fit: BoxFit.cover
            ),
          ),
          child:ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _formkey,
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 100.0),
                          child: Center(
                            child: Image.asset('images/profile.png'),
                          ),
                        ),
                        Container(
                            padding: EdgeInsets.only(left: 15.0),
                            width: double.infinity,
                            margin: EdgeInsets.only(top:20.0),
                            child: Text("Gmail",
                              style: TextStyle(color: Colors.white,fontSize: 15.0),
                              textAlign: TextAlign.start,)
                        ),
                        Container(
                          padding: EdgeInsets.only(left:10.0,right: 10.0),
                          width: double.infinity,
                          child: Card(
                            child: TextFormField(
                              decoration: InputDecoration.collapsed( ),
                              onSaved: (input)=> _email=input,
                            ),
                          ),
                        ),
                        Container(
                            padding: EdgeInsets.only(left: 15.0),
                            width: double.infinity,
                            margin: EdgeInsets.only(top:20.0),
                            child: Text("Password",
                              style: TextStyle(color: Colors.white,fontSize: 15.0),
                              textAlign: TextAlign.start,)
                        ),
                        Container(
                          padding: EdgeInsets.only(left:10.0,right: 10.0),
                          width: double.infinity,
                          child: Card(
                            child: TextFormField(
                              decoration: InputDecoration.collapsed( ),
                              obscureText: true,
                              onSaved: (input)=> _password=input,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 15.0,right: 15.0),
                          height: 50.0,
                          margin: EdgeInsets.only(top: 20.0),
                          width: double.infinity,
                          child: RaisedButton(
                              child: Center(
                                child: Text(" Log In",style: TextStyle(color: Colors.white),),
                              ),
                              color: Colors.blue,
                              onPressed: ()async {
                                      final formstate = _formkey.currentState;
                                      formstate.save();
                                      AuthResult authresult = await FirebaseAuth
                                          .instance.signInWithEmailAndPassword(
                                          email: _email, password: _password);
                                      currentPosition=await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                                      FirebaseUser user = authresult.user;
                                      _saveDeviceToken(user.uid);
                                      Firestore.instance.collection('users')
                                          .document(user.uid)
                                          .updateData({'isOnline': true,'lat':currentPosition.latitude,'long':currentPosition.longitude})
                                          .whenComplete(() {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ButtonNavigationBarHome(uid:user.uid,prefs: widget.prefs)));
                                      });
                              }),
                        ),
                        Container(
                            padding: EdgeInsets.only(left: 15.0),
                            width: double.infinity,
                            margin: EdgeInsets.only(top:20.0),
                            child: Center(
                              child: InkWell(
                                child: Text("Don't Have an account! Sign Up Here",
                                  style: TextStyle(color: Colors.white,fontSize: 15.0),
                                  textAlign: TextAlign.start,),
                                onTap: (){
                                  Navigator.push(context,MaterialPageRoute(builder: (context) => SignUpPage(prefs: widget.prefs,)));
                                },
                              ),
                            )
                        ),

                      ],
                    ),
                  ),
                ),
              ]
          ),
        )
    );
  }

  void _saveDeviceToken(String uid) async{
    String fcmToken= await _fcm.getToken();

    if (fcmToken != null) {
      var tokens = Firestore.instance
          .collection('users')
          .document(uid)
          .collection('tokens')
          .document(fcmToken);

      await tokens.setData({
        'token': fcmToken,
        'createdAt': FieldValue.serverTimestamp(), // optional
        'platform': Platform.operatingSystem // optional
      });
    }

  }
}