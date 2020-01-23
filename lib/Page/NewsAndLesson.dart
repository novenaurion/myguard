import 'package:flutter/material.dart';
import 'package:myguard/Page/lesson.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'News.dart';

class NewsandLesson extends StatefulWidget{
  final SharedPreferences prefs;

  const NewsandLesson({Key key, this.prefs}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _NewsandLessonState();
  }
}

class _NewsandLessonState extends State<NewsandLesson> with SingleTickerProviderStateMixin{
  TabController _tabController;
  List tabs;
  int _currentIndex = 0;

  @override
  void dispose() {

    _tabController.dispose();
    super.dispose();
  }

  void initState() {
    super.initState();

    tabs = ['News','Lesson'];
    _tabController = TabController(length: tabs.length, vsync: this);
    _tabController.addListener(_handleTabControllerTick);
  }


  void _handleTabControllerTick() {
    setState(() {
      _currentIndex = _tabController.index;
    });
  }


  _tabsContent() {
    if (_currentIndex == 0) {
      return News();
    } else if (_currentIndex == 1) {
      return Lesson();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Material(
        child: ListView(children: <Widget>[

          TabBar(
            indicatorColor: Theme.of(context).primaryColor,
            labelColor: Colors.blue,
            labelStyle: Theme.of(context).textTheme.headline,
            controller: _tabController,
            tabs: tabs.map((e) => Tab(text: e)).toList(),
          ),
          _tabsContent(),
        ]));
  }
}