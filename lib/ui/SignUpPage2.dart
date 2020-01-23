import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myguard/ui/ButtonNavigationBarHome.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class SignUpPage2 extends StatefulWidget{
  final String username,gmail,password;
  final SharedPreferences prefs;

  const SignUpPage2({Key key, this.username, this.gmail, this.password, this.prefs}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SignUpPage2state();
  }
}

class _SignUpPage2state  extends State<SignUpPage2>{
   String username,email,password,first,second,third,location;
   Position currentposition;
   static final GlobalKey<FormState> _formkey=new GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {

    username=widget.username;
    email=widget.gmail;
    password=widget.password;

    print(email);
    // TODO: implement build
    return Scaffold(
        body:Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image:AssetImage('images/signup.png'),
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
                            margin: EdgeInsets.only(top:30.0),
                            child: Text("Turst Contact 1",
                              style: TextStyle(color: Colors.blue,fontSize: 15.0),
                              textAlign: TextAlign.start,)
                        ),
                        Container(
                          padding: EdgeInsets.only(left:10.0,right: 10.0),
                          width: double.infinity,
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                decoration: InputDecoration.collapsed( ),
                                onSaved: (input)=> first=input,

                              ),
                            ),
                          ),
                        ),
                        Container(
                            padding: EdgeInsets.only(left: 15.0),
                            width: double.infinity,
                            margin: EdgeInsets.only(top:20.0),
                            child: Text("Trust Contact 2",
                              style: TextStyle(color: Colors.blue,fontSize: 15.0),
                              textAlign: TextAlign.start,)
                        ),
                        Container(
                          padding: EdgeInsets.only(left:10.0,right: 10.0),
                          width: double.infinity,
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                decoration: InputDecoration.collapsed( ),
                                onSaved: (input)=>second=input,
                              ),
                            ),
                          ),
                        ),
                        Container(
                            padding: EdgeInsets.only(left: 15.0),
                            width: double.infinity,
                            margin: EdgeInsets.only(top:20.0),
                            child: Text("Trust Contact 3",
                              style: TextStyle(color: Colors.blue,fontSize: 15.0),
                              textAlign: TextAlign.start,)
                        ),
                        Container(
                          padding: EdgeInsets.only(left:10.0,right: 10.0),
                          width: double.infinity,
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                decoration: InputDecoration.collapsed( ),
                                onSaved: (input)=> third=input,
                              ),
                            ),
                          ),
                        ),
                        Container(
                            padding: EdgeInsets.only(left: 15.0),
                            width: double.infinity,
                            margin: EdgeInsets.only(top:20.0),
                            child: Text("Location",
                              style: TextStyle(color: Colors.blue,fontSize: 15.0),
                              textAlign: TextAlign.start,)
                        ),
                        Container(
                          padding: EdgeInsets.only(left:10.0,right: 10.0),
                          width: double.infinity,
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                decoration: InputDecoration.collapsed( ),
                                onSaved: (input)=> location=input,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 15.0,right: 15.0),
                          height: 50.0,
                          margin: EdgeInsets.only(top: 20.0),
                          width: double.infinity,
                          child: RaisedButton(

                              onPressed:( ){
                                  singup();
                              },
                            child: Center(
                              child: Text("Sign Up",style: TextStyle(color: Colors.white),),
                            ),
                            color: Colors.blue,

                              ),
                        )
                      ],
                    ),
                  ),
                ),
              ]
          ),
        )
    );
  }
   Future<void> singup() async {
    currentposition=await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print('Sign Up');
    print(email);
    print(password);
     final formstate=_formkey.currentState;
     formstate.save();
     AuthResult result=await FirebaseAuth.instance.createUserWithEmailAndPassword(email:email, password:password);
     FirebaseUser user=result.user;
     print(user.uid);
     Firestore.instance.collection("users")
         .document(user.uid)
         .setData({'gmail':email,'username':username,'lat':currentposition.latitude,'long':currentposition.longitude,'first':first,'second':second,'third':third,'isOnline':true,'location':location})
         .whenComplete((){
       Navigator.of(context).pop();
       Navigator.push(
           context,
           MaterialPageRoute(builder: (context) => ButtonNavigationBarHome(uid: user.uid,prefs: widget.prefs,)));
     });
   }
}