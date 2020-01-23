import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myguard/Page/NewsPage.dart';
class News extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _NewsState();
  }
}

class _NewsState extends State<News>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build  
      return StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('news').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting: return new Text('Loading...');
              default:
                return Container(
                  height: 650,
                  child: ListView(
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
                                Navigator.push(context, MaterialPageRoute(builder: (context) => NewsPage(name:document['title'])));
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