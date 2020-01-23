import 'package:flutter/material.dart';
import 'ui/LoginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.getInstance().then((prefs){
    runApp(
        new MaterialApp(
          home: LoginPage(prefs: prefs,),
          title: "My Guard",
        )
    );
  });

}
