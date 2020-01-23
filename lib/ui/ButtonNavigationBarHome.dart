import 'package:flutter/material.dart';
import 'package:myguard/Page/Home.dart';
import 'package:myguard/Page/News.dart';
import 'package:myguard/Page/NewsAndLesson.dart';
import 'package:myguard/Page/Profile.dart';
import 'package:myguard/Page/Notification.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ButtonNavigationBarHome extends StatefulWidget{
  final String uid;
  final SharedPreferences prefs;


  const ButtonNavigationBarHome({Key key, this.uid, this.prefs}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ButtonNavigatinoBarHome();
  }
}

class _ButtonNavigatinoBarHome extends State<ButtonNavigationBarHome>{
  static String uid;
  int _selectPage=0;
  String _title="MyGuard";
  Widget getPage(int index){
    if(index==0){
      return Home(uid:uid,prefs:widget.prefs);
    }
    else if(index==1){
      return NewsandLesson(prefs:widget.prefs);
    }
    else if(index==2){
      return NotificationPage(uid:uid,prefs:widget.prefs);
    }
    else if(index==3){
      return Profile(uid:uid,prefs:widget.prefs);
    }
  }

//  final _pageOption=[
//    Home(uid: uid),
//    News(),
//    Profile()
//  ];
  @override
  Widget build(BuildContext context) {
      uid=widget.uid;
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title:Text(_title,style: TextStyle(color: Colors.blue),),
        automaticallyImplyLeading: false,
      ),
      body:getPage(_selectPage),
      bottomNavigationBar: BottomNavigationBar(
       selectedItemColor: Colors.blue,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        showUnselectedLabels: true,
        unselectedItemColor: Colors.blue[400],
        backgroundColor: Colors.white,
          currentIndex: _selectPage,
          onTap: (int index){
            setState((){
              _selectPage=index;
              switch(index){
                case 0: _title="MyGuard";
                  break;
                case 1:_title="News";
                  break;
                case 2:_title="Notification";
                  break;
                case 3:_title="Profile";
                  break;
              }
            });
          },

          items: [
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.home,color: Colors.blue,),
              title: Text("Home"),
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.newspaper,color: Colors.blue,),
                title: Text("News"),
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.bell,color: Colors.blue,),
              title: Text("Notification"),
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.user,color: Colors.blue,),
              title: Text("Profile"),
            )
          ]),

    );
  }
}