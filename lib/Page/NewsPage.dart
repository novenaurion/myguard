import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class NewsPage extends StatefulWidget{
  final String name;

  const NewsPage({Key key, this.name}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _NewsPageState();
  }
}

class _NewsPageState extends State<NewsPage>{
  String name;
  @override
  Widget build(BuildContext context) {
    name=widget.name;
    // TODO: implement build
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('news').where('title',isEqualTo: name).snapshots(),
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
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Date",style: TextStyle(fontSize: 18.0),),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(document.data['date'],style: TextStyle(fontSize: 18.0),),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text("Time",style: TextStyle(fontSize: 18.0),),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(document.data['time'],style: TextStyle(fontSize: 18.0)),
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
                                    child: Text("Place",style: TextStyle(fontSize: 18.0)),
                                  ),
                                  
                                  Expanded(child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(document.data['place'],style: TextStyle(fontSize: 18.0),textAlign: TextAlign.justify,),
                                  ))
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("about",style: TextStyle(fontSize: 18.0)),
                                  ),

                                  Expanded(child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(document.data['about'],textAlign: TextAlign.justify,style: TextStyle(fontSize: 18.0)),
                                  ))
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