import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myguard/ui/ButtonNavigationBarHome.dart';
import 'package:geolocator/geolocator.dart';
import 'package:myguard/ui/SignUpPage2.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpPage extends StatefulWidget{
  final SharedPreferences prefs;

  const SignUpPage({Key key, this.prefs}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SignUpState();
  }
}

class _SignUpState extends State<SignUpPage> {
  String _username,_gmail,_password,_first,_second,_third,_retype;
  static final GlobalKey<FormState> _formkey=new GlobalKey<FormState>();
  Position currentposition;
  @override
  Widget build(BuildContext context) {

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
                        child: Text("Full Name",
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
                            onSaved: (input)=> _username=input,
                          ),
                        ),
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.only(left: 15.0),
                        width: double.infinity,
                        margin: EdgeInsets.only(top:20.0),
                        child: Text("Gmail",
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
                            onSaved: (input)=> _gmail=input,
                          ),
                        ),
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.only(left: 15.0),
                        width: double.infinity,
                        margin: EdgeInsets.only(top:20.0),
                        child: Text("Password",
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
                            obscureText: true,
                            onSaved: (input)=> _password=input,
                          ),
                        ),
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.only(left: 15.0),
                        width: double.infinity,
                        margin: EdgeInsets.only(top:20.0),
                        child: Text("Retype Password",
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
                            obscureText: true,
                            onSaved: (input)=> _retype=input,
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
                          child: Center(
                            child: Text("Next Page",style: TextStyle(color: Colors.white),),
                          ),
                          color: Colors.blue,
                          onPressed: (){
                            final formstate=_formkey.currentState;
                            formstate.save();
                            if(_password==_retype){
                              Navigator.of(context).pop();
                              Navigator.push(context,
                              MaterialPageRoute(builder: (context) =>SignUpPage2(username:_username,gmail:_gmail,password:_password,prefs:widget.prefs)));
                            }
                          }),
                    )
                  ],
                ),
              ),
            ),
         ]
        ),
      )
    );
    // TODO: implement build

//    return Scaffold(
//      body: ListView(
//        children: <Widget>[
//          Container(
//            margin:EdgeInsets.only(top:50.0),
//            width: double.infinity,
//
//            child: Padding(
//              padding: const EdgeInsets.only(left:20.0,right: 20.0),
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
//                              child:Text("SIGN UP",
//                                style:TextStyle(fontSize:20.0),
//                              ),
//                            ),
//                            SizedBox(
//                              height: 20.0,
//                            ),
//                            Padding(
//                              padding: const EdgeInsets.all(8.0),
//                              child: Container(
//                                  child:TextFormField(
//                                    validator: (str){
//                                      if(str.isEmpty){
//                                        return "required username";
//                                      }
//                                    },
//                                    onSaved: (input)=> _username=input,
//                                    decoration: InputDecoration(
//                                        icon:Icon(Icons.person),
//                                        hintText: "User Name",
//                                    ),
//
//                                  )
//                              ),
//                            ),
//                            SizedBox(
//                              height: 20.0,
//                            ),
//                            Padding(
//                              padding: const EdgeInsets.all(8.0),
//                              child: Container(
//                                  child:TextFormField(
//                                    validator: (str){
//                                      if(str.isEmpty){
//                                        return "required Gmail";
//                                      }
//                                    },
//                                    onSaved: (input)=> _gmail=input,
//                                    decoration: InputDecoration(
//                                        icon:Icon(Icons.mail),
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
//                                  child:TextFormField(
//                                    obscureText: true,
//                                    validator: (str){
//                                      if(str.isEmpty){
//                                        return "required password";
//                                      }
//                                    },
//                                    onSaved: (input)=> _password=input,
//                                    decoration: InputDecoration(
//                                        icon: Icon(Icons.lock),
//                                        hintText: "Enter Password"
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
//                                  child:TextFormField(
//                                    obscureText: true,
//                                    validator: (str){
//                                      if(str.isEmpty){
//                                        return "required password";
//                                      }
//                                    },
//                                    decoration: InputDecoration(
//                                        icon:Icon(Icons.lock),
//                                        hintText: "Retype password"
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
//                                  child:TextFormField(
//                                    obscureText: true,
//                                    validator: (str){
//                                      if(str.isEmpty){
//                                      }
//                                    },
//                                    onSaved: (input)=> _first=input,
//                                    decoration: InputDecoration(
//                                        icon:Icon(Icons.lock),
//                                        hintText: "First Trust Number"
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
//                                  child:TextFormField(
//                                    obscureText: true,
//                                    validator: (str){
//                                      if(str.isEmpty){
//                                        return "required password";
//                                      }
//                                    },
//                                    onSaved: (input)=> _second=input,
//                                    decoration: InputDecoration(
//                                        icon:Icon(Icons.lock),
//                                        hintText: "Second Trust Number"
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
//                                  child:TextFormField(
//                                    obscureText: true,
//                                    validator: (str){
//                                      if(str.isEmpty){
//                                        return "required password";
//                                      }
//                                    },
//                                    onSaved: (input)=> _third=input,
//                                    decoration: InputDecoration(
//                                        icon:Icon(Icons.lock),
//                                        hintText: "Third Trust Number"
//                                    ),
//                                  )
//                              ),
//                            ),
//
//                            SizedBox(
//                              height: 20.0,
//                            ),
//                            Padding(
//                              padding: const EdgeInsets.all(8.0),
//                              child: Container(
//                                width: double.infinity,
//                                child: RaisedButton(
//                                    color: Colors.blue,
//                                    textColor: Colors.white,
//                                    onPressed: (){
//                                      singup();
//                                    },
//                                    child: Text("Sign Up")),
//                              ),
//                            ),
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
//    );
  }
}