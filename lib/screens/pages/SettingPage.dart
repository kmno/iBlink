import 'dart:ui';

import 'package:iblink/utils/Strings.dart';
import 'package:iblink/utils/Theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info/package_info.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:io' show Platform;

import 'ParentPage.dart';

// ignore: must_be_immutable
class SettingPage extends ParentPage {
  @override
  State<StatefulWidget> createState() =>
      _SettingPageState(ParentPage.prefs, ParentPage.packageInfo);
}

class _SettingPageState extends State<SettingPage> {
  SharedPreferences prefs;
  PackageInfo _packageInfo = PackageInfo(
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  _SettingPageState(SharedPreferences _prefs, PackageInfo _pckg) {
    prefs = _prefs;
    // pckg = _pckg;
  }

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
    createGeneralList();
  }

  Future<void> _initPackageInfo() async {
    print("_initPackageInfo");
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  void changePrefValue(_title, _value) async {
    settingsChanged = true;
    await prefs.setBool(_title, _value);
  }

  var settingsChanged = false;
  var generals = <SettingsTile>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(Strings.setting),
          leading: IconButton(
            icon: FaIcon(FontAwesomeIcons.chevronLeft),
            color: primaryColor,
            onPressed: () => Navigator.pop(context, settingsChanged),
          ),
          elevation: 0,
          centerTitle: true,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          textTheme: TextTheme(
              title: TextStyle(
                  color: primaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
        ),
        body: Theme(
          data: ThemeData(
              brightness: Brightness.light, accentColor: secondaryColor),
          child: SettingsList(
            sections: [
              SettingsSection(
                title: 'General',
                tiles: generals,
              ),
              SettingsSection(
                title: 'Notification',
                tiles: [
                  SettingsTile.switchTile(
                      title: 'Vibrate',
                      leading: Icon(Icons.vibration),
                      switchValue: prefs.get("vibrate"),
                      onToggle: (bool value) {
                        setState(() {
                          changePrefValue("vibrate", value);
                        });
                      }),
                  SettingsTile.switchTile(
                      title: 'Sound',
                      leading: Icon(Icons.notifications_active),
                      switchValue: prefs.get("sound"),
                      onToggle: (bool value) {
                        setState(() {
                          changePrefValue("sound", value);
                        });
                      })
                ],
              ),
              SettingsSection(
                title: 'About',
                tiles: [
                  SettingsTile(
                      title: 'Version',
                      subtitle: _packageInfo.version +
                          ' (${_packageInfo.buildNumber})'),
                  /*SettingsTile(
                    title: '',
                    subtitle: Strings.appDesc,
                  ),*/
                ],
              )
            ],
          ),
        ));
  }

  void createGeneralList() {
    if (!Platform.isIOS) {
      generals.add(SettingsTile.switchTile(
        title: 'Start On Boot',
        subtitle: 'iBlink will automatically start on system boot.',
        leading: Icon(Icons.power_settings_new),
        switchValue: prefs.get("startOnBoot"),
        onToggle: (bool value) {
          setState(() {
            changePrefValue("startOnBoot", value);
          });
        },
      ));
    }

    generals.add(SettingsTile.switchTile(
      title: 'Run in Background',
      subtitle: 'iBlink will run in background.',
      leading: Icon(Icons.refresh),
      switchValue: prefs.get("headlessTask"),
      onToggle: (bool value) {
        setState(() {
          changePrefValue("headlessTask", value);
        });
      },
    ));
  }
}
