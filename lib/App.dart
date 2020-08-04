import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:iblink/utils/Strings.dart';
import 'package:iblink/utils/Theme.dart';

import 'routes/Routes.dart';
import 'package:iblink/screens/pages/SplashPage.dart';

class App extends StatefulWidget {
  App({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new MyAppState();
}

class MyAppState extends State<App> {
  Widget splashPage = new SplashPage();

  @override
  void initState() {
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Strings.appTitle,
      // theme: kDarkGalleryTheme,
      routes: Routes.routes,
      initialRoute: Routes.splash,
      debugShowCheckedModeBanner: false,
      //home: splashPage
    );
  }
}
