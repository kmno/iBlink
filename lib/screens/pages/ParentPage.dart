import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
abstract class ParentPage extends StatefulWidget {
  static SharedPreferences prefs;
  static PackageInfo packageInfo;

  //1
  @override
  State<StatefulWidget> createState() => _ParentState();

  @override
  StatefulElement createElement() {
    print("ParentPage createElement");
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    if (prefs == null) getPrefsInstance();
    // if(packageInfo == null)
    getPackageInfo();
    return super.createElement();
  }

  void getPrefsInstance() async {
    print("ParentPage getPrefsInstance");
    prefs = await SharedPreferences.getInstance();
  }

  void getPackageInfo() async {
    print("ParentPage getPackageInfo");
    // packageInfo = await PackageInfo.fromPlatform();
  }
}

class _ParentState extends State<ParentPage> {
  @override
  void initState() {
    print("ParentPage initState");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("ParentPage build");
    return Scaffold();
  }
}
