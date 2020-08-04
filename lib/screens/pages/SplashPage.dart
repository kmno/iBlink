import 'dart:async';

import 'package:iblink/routes/Routes.dart';
import 'package:iblink/utils/Strings.dart';
import 'package:iblink/utils/Theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'HomePage.dart';
import 'ParentPage.dart';

class SplashPage extends ParentPage {
  @override
  State<StatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  startTimeout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("isRunning")) {
      await prefs.setBool('isRunning', false);
    }
    if (!prefs.containsKey("startOnBoot")) {
      await prefs.setBool('startOnBoot', true);
    }
    if (!prefs.containsKey("vibrate")) {
      await prefs.setBool('vibrate', true);
    }
    if (!prefs.containsKey("sound")) {
      await prefs.setBool('sound', true);
    }
    if (!prefs.containsKey("headlessTask")) {
      await prefs.setBool('headlessTask', true);
    }
    if (!prefs.containsKey("isStartNow")) {
      await prefs.setBool('isStartNow', true);
    }
    var duration = const Duration(seconds: 3);
    return new Timer(duration, moveToHome);
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light));
    startTimeout();
  }

  void moveToHome() {
    Routes.navigateToPage(context, HomePage());
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Builder(
            builder: (context) => Center(
                    child: Container(
                  color: primaryColor,
                  child: Container(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Column(children: <Widget>[
                                  FaIcon(FontAwesomeIcons.eye,
                                      size: 120, color: Colors.white),
                                  Text(
                                    Strings.appTitle,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 35,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    Strings.appTitleTip,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  )
                                ])
                              ])
                        ]),
                    constraints: BoxConstraints(
                        maxHeight: 200.0,
                        maxWidth: 200.0,
                        minWidth: 150.0,
                        minHeight: 150.0),
                  ),
                  alignment: FractionalOffset(0.5, 0.5),
                ))));
  }
}
