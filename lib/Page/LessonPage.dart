import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class LessonPage extends StatefulWidget{
  final String name;

  const LessonPage({Key key, this.name}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LessonPageState();
  }
}

class _LessonPageState extends State<LessonPage>{
  String name;
  @override
  Widget build(BuildContext context) {
    name=widget.name;
    // TODO: implement build
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('lessons').where('title',isEqualTo: name).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return new Text('Loading...');
          default:
            return Scaffold(
              appBar: AppBar(
                title: Text(name),
              ),
              body: new ListView(
                children: snapshot.data.documents.map((DocumentSnapshot document) {
                  return Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          child :Image.network(document.data['image'],
                            width: double.infinity,
                            fit: BoxFit.fitWidth,),
                        ),
                        Card(
                          margin: EdgeInsets.only(top:20.0,left: 10.0,right: 10.0),
                          elevation: 10.0,
                          child: new Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Step 1",style: TextStyle(fontSize: 18.0),),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(document.data['step1'],style: TextStyle(fontSize: 18.0),textAlign: TextAlign.justify,),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Step 1",style: TextStyle(fontSize: 18.0),),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(document.data['step2'],style: TextStyle(fontSize: 18.0),textAlign: TextAlign.justify,),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Step 3",style: TextStyle(fontSize: 18.0),),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(document.data['step3'],style: TextStyle(fontSize: 18.0),textAlign: TextAlign.justify,),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            );
        }
      },
    );
  }
}