import 'package:iblink/screens/pages/ParentPage.dart';
import 'package:iblink/screens/pages/SettingPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iblink/screens/pages/HomePage.dart';
import 'package:iblink/screens/pages/SplashPage.dart';
import 'package:page_transition/page_transition.dart';

class Routes {
  static const splash = "/";
  static const home = "/home";
  static const setting = "/setting";

  static final routes = <String, WidgetBuilder>{
    splash: (BuildContext context) => new SplashPage(),
    home: (BuildContext context) => new HomePage(),
    setting: (BuildContext context) => new SettingPage(),
  };

  static Future<Null> navigateToPage(
      BuildContext context, ParentPage dest) async {
    Navigator.pushReplacement(
        context,
        PageTransition(
            type: PageTransitionType.rightToLeft,
            child: dest,
            duration: Duration(milliseconds: 500)));
  }

  static Future<Null> navigateToPageAndBackWithSlide(
      BuildContext context, ParentPage now, ParentPage dest) async {
    Navigator.push(
        context,
        //EnterExitRoute(exitPage: now, enterPage: dest)
        PageTransition(
            type: PageTransitionType.rightToLeft,
            child: dest,
            duration: Duration(milliseconds: 500)));
  }
}

class EnterExitRoute extends PageRouteBuilder {
  final Widget enterPage;
  final Widget exitPage;

  EnterExitRoute({this.exitPage, this.enterPage})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              enterPage,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              Stack(
            children: <Widget>[
              SlideTransition(
                position: new Tween<Offset>(
                  begin: const Offset(0.0, 0.0),
                  end: const Offset(-1.0, 0.0),
                ).animate(animation),
                child: exitPage,
              ),
              SlideTransition(
                position: new Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: enterPage,
              )
            ],
          ),
        );
}
