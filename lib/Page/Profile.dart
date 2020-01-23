import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget{
  final String uid;
  final SharedPreferences prefs;

  const Profile({Key key, this.uid,  this.prefs}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ProfileState();
  }
}

class _ProfileState extends State<Profile>{

  static final GlobalKey<FormState> _formkey = new GlobalKey<FormState>();
  final Firestore db=Firestore.instance;
   static String uid;
  var showcursorforthird=false;

   String first,second,third,location,user;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    uid=widget.uid;

    print(uid);

    db.collection('users').document(uid)
        .get()
        .then((DocumentSnapshot ds){
          setState(() {
            print(ds.data['location']);
            print(ds.data['username']);
            first=ds.data['first'];
            second=ds.data['second'];
            third=ds.data['third'];
            location=ds.data['location'];
            user=ds.data['username'];
          });




    });

    // TODO: implement build

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          child: ListView(
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top:30.0),
                    child:
                    Center(child: Image.asset('images/profile.png')),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(user,style: TextStyle(color: Colors.blue,fontSize: 25.0,fontWeight:FontWeight.bold),),
                    ),
                  ),
                  Center(
                    child: Text(location,style: TextStyle(color: Colors.blue,fontSize: 15.0),),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(top: 50.0,left: 20.0),
                    child: Text("Trusted Contacts",style: TextStyle(color:Colors.blue,fontSize: 20.0,fontWeight: FontWeight.bold),textAlign: TextAlign.start,),
                  ),
                  Container(
                      child: Form(
                        key: _formkey,
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: double.infinity,
                              height: 70.0,
                              child: Padding(
                                padding: const EdgeInsets.only(top:8.0,left: 10.0,right: 10.0),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 20.0,right: 20.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Expanded(
                                          child: Container(
                                            width: 150,
                                            height: 100,
                                            child: Padding(
                                              padding: const EdgeInsets.only(top:4.0,left:8.0),
                                              child: TextFormField(
                                                style: TextStyle(
                                                    fontSize: 20.0,
                                                    color: Colors.black54
                                                ),
                                                initialValue: first,
                                                decoration: InputDecoration.collapsed( ),
                                                onSaved: (input)=> first=input,
                                              ),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                            child: Icon(FontAwesomeIcons.save,),
                                        onTap: (){
                                          final formstate=_formkey.currentState;
                                          formstate.save();
                                          db.collection('users').document(uid)
                                              .updateData({'first':first});
                                        },)
                                      ],

                                    ),
                                  ),
                                ),
                              ),
                            ),

                            Container(
                              width: double.infinity,
                              height: 70.0,
                              child: Padding(
                                padding: const EdgeInsets.only(top:8.0,left: 10.0,right: 10.0),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 20.0,right: 20.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Expanded(
                                          child: Container(
                                            width: 150,
                                            height: 100,
                                            child: Padding(
                                              padding: const EdgeInsets.only(top:4.0,left:8.0),
                                              child: TextFormField(
                                                style: TextStyle(
                                                    fontSize: 20.0,
                                                    color: Colors.black54
                                                ),
                                                initialValue: second,
                                                decoration: InputDecoration.collapsed( ),
                                                onSaved: (input)=> second=input,
                                              ),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          child: Icon(FontAwesomeIcons.save,),
                                          onTap: (){
                                            final formstate=_formkey.currentState;
                                            formstate.save();
                                            db.collection('users').document(uid)
                                                .updateData({'second':second});
                                          },)
                                      ],

                                    ),
                                  ),
                                ),
                              ),
                            ),

                            Container(
                              width: double.infinity,
                              height: 70.0,
                              child: Padding(
                                padding: const EdgeInsets.only(top:8.0,left: 10.0,right: 10.0),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 20.0,right: 20.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Expanded(
                                          child: Container(
                                            width: 150,
                                            height: 100,
                                            child: Padding(
                                              padding: const EdgeInsets.only(top:4.0,left:8.0),
                                              child: TextFormField(
                                                style: TextStyle(
                                                  fontSize: 20.0,
                                                  color: Colors.black54
                                                ),
                                                autofocus: true,
                                                initialValue: third,
                                                decoration: InputDecoration.collapsed(
                                                ),
                                                onSaved: (input)=> third=input,
                                              ),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          child: Icon(FontAwesomeIcons.save,),
                                          onTap: (){
                                            final formstate=_formkey.currentState;
                                            formstate.save();
                                            db.collection('users').document(uid)
                                                .updateData({'third':third});
                                          },),
                                      ],

                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
//                    child: Form(
//                      key: _formkey,
//                      child: Column(
//                        children: <Widget>[
//                          Container(
//                            width: double.infinity,
//                            child: Text("Edit Trusted Contacts",style:TextStyle(color: Colors.blue,fontSize: 15.0),textAlign: TextAlign.start,
//                            ),
//                          ),
//                          SizedBox(
//                            height: 10.0,
//                           ),
//                          TextFormField(
//                            decoration: InputDecoration.collapsed(
//                          ),
//                            initialValue:first,
//                            onSaved: (input)=> first=input,
//
//                          ),
//                          SizedBox(
//                            height: 10.0,
//                          ),
//                          TextFormField(
//                            decoration: InputDecoration.collapsed(
//                                ),
//                            initialValue: second,
//                            onSaved: (input)=> second=input,
//
//                          ),
//                          SizedBox(
//                            height: 10.0,
//                          ),
//                          TextFormField(
//
//                            decoration: InputDecoration.collapsed(
//
//                            ),
//                            initialValue: third,
//                            onSaved: (input)=>third=input,
//                          ),
//                          SizedBox(
//                            height: 10.0,
//                          ),
//                        ],
//                      ),
//                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

}