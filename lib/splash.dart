import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wellhelp/login.dart';
import 'package:wellhelp/main.dart';

import 'homescreen.dart';

class splashscreen extends StatefulWidget {
  const splashscreen({Key? key}) : super(key: key);

  @override
  State<splashscreen> createState() => _splashscreenState();
}

class _splashscreenState extends State<splashscreen> {
  @override
  void initState() {
    checKUserLogin(context);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

Future<void> gotoLogin(BuildContext context) async {
  await Future.delayed(Duration(seconds: 5));
  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
    return loginScreen();
  }));
}

Future<void> checKUserLogin(BuildContext context) async {
  await Future.delayed(Duration(seconds: 3));
  final sharedprefs = await SharedPreferences.getInstance();
  final userLoggedIN = sharedprefs.getBool(SAVEKEY);
  final userName = sharedprefs.getString(USER);
  if (userLoggedIN == null || userLoggedIN == false) {
    gotoLogin(context);
  }
  else {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) {
      return homeScreen(name: userName);
    }));
  }
}
