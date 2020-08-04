import 'dart:async';
import 'dart:ui';

import 'package:after_layout/after_layout.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iblink/screens/pages/SettingPage.dart';
import 'package:iblink/utils/MyTimer.dart';
import 'package:iblink/utils/Strings.dart';
import 'package:iblink/utils/Theme.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import 'ParentPage.dart';

/// This "Headless Task" is run when app is terminated.
void backgroundFetchHeadlessTask(String taskId) async {
  print('[BackgroundFetch] Headless event received.');
  _HomePageState._showNotification();
  BackgroundFetch.finish(taskId);
}

///Headless task end

class HomePage extends ParentPage {
  //1
  @override
  State<StatefulWidget> createState() => _HomePageState(ParentPage.prefs);
}

class _HomePageState extends State<HomePage>
    with AfterLayoutMixin<HomePage>, AutomaticKeepAliveClientMixin<HomePage> {
  final MethodChannel platform =
      MethodChannel('crossingthestreams.io/resourceResolver');
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static SharedPreferences prefs;

  _HomePageState(SharedPreferences _prefs) {
    prefs = _prefs;
  }

  var isRunning = false;
  var stateIcon = FontAwesomeIcons.eyeSlash;

  var buttonIcon = FontAwesomeIcons.play;
  var buttonIconColor = Colors.white;

  var stateText = Strings.disabled;
  var stateDesc = Strings.appDesc;
  var stateColor = deActiveState;

  var buttonText = Strings.start;
  var buttonColor = primaryColor;
  var buttonTextColor = Colors.white;
  var buttonHighlightColor = primaryColorDark;

  var time = "";
  static var notificationTimeout = 5000;
  bool timerVisibility = false;
  bool mustBuild = true;
  Widget timerWidget;
  var seconds = 0.0;
  Timer _timer;
  DateTime dateTime;
  var currentAppearance;

  NotificationAppLaunchDetails notificationAppLaunchDetails;

  //quick actions
  final QuickActions quickActions = QuickActions();

  //2
  @override
  bool get mounted => super.mounted;

  //3
  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    initNotification();
    initPlatformState();
    // Register to receive BackgroundFetch events after app is terminated.
    // Requires {stopOnTerminate: false, enableHeadless: true}
    BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);

    timerWidget = initTimer();
    //dateTime = DateTime.now();
    //_timer = Timer.periodic(const Duration(seconds: 1), setTime);

    currentAppearance = appearanceStop;
    seconds = 0;

    _initQuickActions();
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    debugPrint('afterFirstLayout');
    checkRunning();
    _showOngoingNotification();
  }

  /// PROGRESS BAR CONFIG ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  static final startAngle = 180.0;
  static final angleRange = 180.0;
  static final size = 260.0;
  static final barWidth =
      CustomSliderWidths(trackWidth: 3, progressBarWidth: 5);
  static final progressColorsActive = CustomSliderColors(
      trackColor: secondaryColor.withOpacity(0.3),
      progressBarColors: [
        primaryColorDark.withOpacity(0.5),
        primaryColor.withOpacity(0.5),
        secondaryColor.withOpacity(0.5)
      ],
      hideShadow: true);
  static final progressColorsStop = CustomSliderColors(
      dotColor: Colors.transparent,
      trackColor: deActiveStateText.withOpacity(0.2),
      progressBarColor: deActiveStateText.withOpacity(0.2),
      hideShadow: true);
  final CircularSliderAppearance appearanceStop = CircularSliderAppearance(
      customWidths: barWidth,
      customColors: progressColorsStop,
      startAngle: startAngle,
      angleRange: angleRange,
      size: size,
      animationEnabled: true);
  final CircularSliderAppearance appearanceActive = CircularSliderAppearance(
      customWidths: barWidth,
      customColors: progressColorsActive,
      startAngle: startAngle,
      angleRange: angleRange,
      size: size,
      animationEnabled: true);

  void setTime(Timer timer) {
    setState(() {
      //dateTime = DateTime.now();
      if (seconds < 117)
        seconds += 1;
      else
        seconds = 0;
    });
  }

  Widget initTimer() {
    return MyTimer(
      initialDate: DateTime.now(),
      running: prefs.get("isRunning"),
      backgroundColor: Colors.transparent,
      height: 50,
      borderRadius: 0,
      timerTextStyle: TextStyle(
          color: secondaryColor, fontSize: 16, fontWeight: FontWeight.bold),
      isRaised: true,
      width: 200,
    );
  }

  /// BUILD ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  //5
  @override
  Widget build(BuildContext context) {
    super.build(context);

    //if (prefs.get("isRunning")) seconds = dateTime.second.toDouble();
    if (prefs.get("isRunning")) seconds += 1;

    return new Scaffold(
        body: Builder(
            builder: (context) => Center(
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.only(
                      top: 30,
                    ),
                    alignment: AlignmentDirectional(0.0, 0.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                              flex: 0,
                              child: Container(
                                  alignment: FractionalOffset.centerRight,
                                  child: IconButton(
                                      icon: FaIcon(FontAwesomeIcons.cog,
                                          size: 22, color: Colors.black54),
                                      padding: const EdgeInsets.only(
                                        right: 20,
                                      ),
                                      onPressed: () {
                                        mustBuild = false;
                                        // FirebaseServices.analytics.logEvent(name: 'settingButtonClick');
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => SettingPage(),
                                          ),
                                        ).then((settingsChanged) {
                                          if (settingsChanged) {
                                            setState(() {
                                              timerWidget = initTimer();
                                              restartBackgroundFetch();
                                            });
                                          }
                                        });
                                      }))),
                          Expanded(
                              flex: 2,
                              child: Container(
                                  margin: new EdgeInsets.all(40.0),
                                  alignment: FractionalOffset.center,
                                  child: Visibility(
                                      visible: true,
                                      child: SleekCircularSlider(
                                        appearance: currentAppearance,
                                        min: 0,
                                        max: 119,
                                        initialValue: seconds,
                                        innerWidget: (double value) {
                                          return Padding(
                                              padding: EdgeInsets.only(top: 10),
                                              child: Center(
                                                  child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: <Widget>[
                                                    FaIcon(stateIcon,
                                                        size: 100,
                                                        color: stateColor),
                                                    Text(
                                                      stateText,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 25,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: stateColor,
                                                      ),
                                                    ),
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 10),
                                                        child: Text(
                                                          stateDesc,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            color: stateColor,
                                                          ),
                                                        )),
                                                    Visibility(
                                                        // visible: timerVisibility,
                                                        visible: false,
                                                        child: timerWidget)
                                                  ])));
                                        },
                                      )))),
                          Expanded(
                              child: Container(
                                  alignment: AlignmentDirectional(0.0, 0.0),
                                  child: SizedBox.expand(
                                      child: FlatButton(
                                          color: buttonColor,
                                          textColor: buttonTextColor,
                                          splashColor: Colors.transparent,
                                          highlightColor: buttonHighlightColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(0.0),
                                          ),
                                          onPressed: handleButtonClick,
                                          child: FaIcon(buttonIcon,
                                              size: 30, color: buttonIconColor)
                                          /*Text(buttonText,
                                              style:
                                                  TextStyle(fontSize: 30))*/
                                          )))),
                        ]),
                  ),
                )));
  }

  void handleButtonClick() async {
    if (!isRunning) {
      ///start background fetch
      BackgroundFetch.start().then((int status) async {
        print('[BackgroundFetch] start success: $status');
        isRunning = true;
        timerVisibility = true;
        await prefs.setBool('isRunning', isRunning);
        await prefs.setBool('isStartNow', false);
        _showOngoingNotification();
        toggleStates(true);
      }).catchError((e) {
        print('[BackgroundFetch] start FAILURE: $e');
      });
    } else {
      _showConfirmationAlert(
          context, Strings.terminateAlert, Strings.terminateContent);
      /*showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text(Strings.terminateAlert),
          actions: <Widget>[
            FlatButton(
              child: new Text(Strings.yes),
              textColor: primaryColor,
              onPressed: () async {
                isRunning = false;
                timerVisibility = false;
                await prefs.setBool('isRunning', isRunning);
                await prefs.setBool('isStartNow', true);
                BackgroundFetch.stop().then((int status) {
                  print('[BackgroundFetch] stop success: $status');
                });
                _showOngoingNotification();
                toggleStates(false);
                Navigator.of(context, rootNavigator: true).pop('dialog');
              },
            ),
            FlatButton(
              child: new Text(Strings.no),
              textColor: primaryColor,
              onPressed: () =>
                  Navigator.of(context, rootNavigator: true).pop('dialog'),
            ),
          ],
        ),
      );*/
    } //else
  }

  void checkRunning() async {
    if (prefs.get("isRunning")) {
      isRunning = true;
      timerVisibility = true;
      toggleStates(true);
    }
  }

  void toggleStates(bool _active) {
    if (_active) {
      setState(() {
        stateIcon = FontAwesomeIcons.eye;
        stateColor = secondaryColor;
        stateText = Strings.enabled;
        stateDesc = Strings.appDescActive;
        buttonTextColor = deActiveStateText;
        buttonColor = deActiveState;
        buttonText = Strings.stop;
        buttonIcon = FontAwesomeIcons.stop;
        buttonIconColor = deActiveStateText;
        currentAppearance = appearanceActive;
        seconds = 0;
        dateTime = DateTime.now();
        _timer = Timer.periodic(const Duration(seconds: 1), setTime);
        //seconds = dateTime.second.toDouble();
      });
    } else {
      setState(() {
        stateIcon = FontAwesomeIcons.eyeSlash;
        stateColor = deActiveState;
        stateText = Strings.disabled;
        stateDesc = Strings.appDesc;
        buttonTextColor = Colors.white;
        buttonColor = primaryColor;
        buttonText = Strings.start;
        buttonIcon = FontAwesomeIcons.play;
        buttonIconColor = Colors.white;
        currentAppearance = appearanceStop;
        seconds = 0;
        dateTime = null;
        _timer.cancel();
      });
    }
  }

  /// BACKGROUND FETCH++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  Future<void> initPlatformState() async {
    // Configure BackgroundFetch.
    BackgroundFetch.configure(
            BackgroundFetchConfig(
                minimumFetchInterval: 15,
                stopOnTerminate: !prefs.get("headlessTask"),
                enableHeadless: prefs.get("headlessTask"),
                startOnBoot: prefs.get("startOnBoot"),
                requiresBatteryNotLow: false,
                requiresCharging: false,
                requiresStorageNotLow: false,
                requiresDeviceIdle: false,
                requiredNetworkType: NetworkType.NONE),
            //callback
            _onBackgroundFetch)
        .then((int status) {
      print('[BackgroundFetch] configure success: $status');
    }).catchError((e) {
      print('[BackgroundFetch] configure ERROR: $e');
    });

    // Optionally query the current BackgroundFetch status.
    int status = await BackgroundFetch.status;
    print("BackgroundFetch.status : $status");
    //setState(() {});

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  void _onBackgroundFetch(String taskId) async {
    // This is the fetch-event callback.
    print("[BackgroundFetch] Event received: $taskId");

    // if (taskId == "flutter_background_fetch") {
    if (prefs.get("isRunning")) {
      if (!prefs.get("isStartNow")) {
        _showNotification();
        setState(() {
          seconds = 0.0;
        });
      }
    }

    // IMPORTANT:  You must signal completion of your fetch task or the OS can punish your app
    // for taking too long in the background.
    BackgroundFetch.finish(taskId);
  }

  void restartBackgroundFetch() {
    BackgroundFetch.stop().then((int status) {
      print('[BackgroundFetch] stop success: $status');
    }).then((taskId) {
      BackgroundFetch.start().then((int status) {
        print('[BackgroundFetch] restart success: $status');
      });
    });
  }

  /// NOTIFICATIONS ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  void initNotification() async {
    debugPrint('initNotification');
    notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    var initializationSettingsAndroid =
        AndroidInitializationSettings('ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
/*    var initializationSettingsIOS = IOSInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
        onDidReceiveLocalNotification:
            (int id, String title, String body, String payload) async {
              print('hdgfhjdgfjhdg fjhdsg fjhdgs fjdsgf jhgds j');
        });*/
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  static Future<void> _showNotification() async {
    var androidPlatformChannelSpecifics =
        AndroidNotificationDetails('13670508', Strings.appTitle, '',
            importance: Importance.Max,
            priority: Priority.High,
            enableVibration: true,
            // enableVibration: prefs.get("vibrate"),
            //  playSound: prefs.get("sound"),
            playSound: true,
            channelShowBadge: false,
            ticker: 'it\'s time to Rest. NOW CLOSE YOUR EYES FOR 3 SECONDS...',
            timeoutAfter: notificationTimeout);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails(
        presentAlert: true, presentBadge: false, presentSound: true);
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        1,
        'NOW CLOSE YOUR EYES FOR 3 SECONDS...',
        'it\'s time to Rest',
        platformChannelSpecifics,
        payload: 'item x');
  }

  ///This is sticky notification indicating app is active or not
  Future<void> _showOngoingNotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        '13670508', Strings.appTitle, '',
        importance: Importance.Low,
        priority: Priority.Min,
        ongoing: true,
        autoCancel: false,
        enableVibration: prefs.get("vibrate"),
        channelShowBadge: false,
        // ticker: 'iBlink Status : ' + (isRunning ? Strings.enabled : Strings.disabled)+'\nClick to See Details',
        playSound: prefs.get("sound"));
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0,
        'iBlink Status : ' + (isRunning ? Strings.enabled : Strings.disabled),
        'Click to See Details',
        platformChannelSpecifics);
  }

  Future selectNotification(String payload) async {
    if (payload != null) {}
  }

  ///Quick Actions
  void _initQuickActions() {
    quickActions.initialize((shortcutType) {
      if (shortcutType == 'action_start') {
        if (prefs.get("isRunning")) {
          _showAlert(context, Strings.alreadyStarted);
        } else {
          handleButtonClick();
        }
      } else if (shortcutType == 'action_stop') {
        if (!prefs.get("isRunning")) {
          _showAlert(context, Strings.alreadyStopped);
        } else {
          handleButtonClick();
        }
      }
    });

    quickActions.setShortcutItems(<ShortcutItem>[
      const ShortcutItem(type: 'action_stop', localizedTitle: 'Stop'),
      const ShortcutItem(type: 'action_start', localizedTitle: 'Start'),
    ]);
  }

  _showAlert(BuildContext context, String msg) {
    showPlatformDialog(
      context: context,
      builder: (_) => BasicDialogAlert(
        title: Text(msg),
        //content: Text("Your current location cannot be determined at this time."),
        actions: <Widget>[
          BasicDialogAction(
            title: Text("OK"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  _showConfirmationAlert(BuildContext context, String msg, String content) {
    showPlatformDialog(
      context: context,
      builder: (_) => BasicDialogAlert(
        title: Text(msg),
        content: Text(content),
        actions: <Widget>[
          BasicDialogAction(
            title: Text(Strings.yes),
            onPressed: () async {
              isRunning = false;
              timerVisibility = false;
              await prefs.setBool('isRunning', isRunning);
              await prefs.setBool('isStartNow', true);
              BackgroundFetch.stop().then((int status) {
                print('[BackgroundFetch] stop success: $status');
              });
              _showOngoingNotification();
              toggleStates(false);
              Navigator.pop(context);
            },
          ),
          BasicDialogAction(
            title: Text(Strings.no),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  //4
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  //6
  @override
  void didUpdateWidget(HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  //7
  @override
  void setState(fn) {
    super.setState(fn);
  }

  //8
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  // ignore: missing_return
  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) {
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {},
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
