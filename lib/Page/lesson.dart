import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myguard/Page/LessonPage.dart';
import 'package:myguard/Page/NewsPage.dart';
class Lesson extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LessonState();
  }
}

class _LessonState extends State<Lesson>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('lessons').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return new Text('Loading...');
          default:
            return Container(
                height: 650,
              child: new ListView(
                children: snapshot.data.documents.map((DocumentSnapshot document) {
                  return Column(
                    children: <Widget>[
                      Container(
                        margin:EdgeInsets.all( 10.0),
                        child: InkWell(
                          child: Card(
                            child: new Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Container(
                                  child:Image.network(document['image'],fit: BoxFit.fitWidth,
                                    width: double.infinity,),
                                )  ,
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(document['title'],style: TextStyle(color: Colors.blue,fontSize: 20.0),),
                                  ),
                                )
                              ],
                            ),
                          ),
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => LessonPage(name:document['title'])));
                          },
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            );
        }
      },
    );

  }
}