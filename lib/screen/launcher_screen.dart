import 'dart:async';

import 'package:flutter/material.dart';
import 'package:questionhub/commons/global.dart';
import 'package:questionhub/commons/res/res_colors.dart';
import 'package:questionhub/commons/res/res_string.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';

import '../commons/routes/route_name.dart';
import '../utils/screen_utils.dart';

class LauncherScreen extends StatefulWidget {
  const LauncherScreen({Key? key}) : super(key: key);

  @override
  State<LauncherScreen> createState() => _LauncherScreenState();
}

class _LauncherScreenState extends State<LauncherScreen> {
  final LauncherStr resStr = LauncherStr();
  final LauncherColor resColor = LauncherColor();

  Timer? _timer;
  int _countdownTime = 0;
  String _authStatus = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlugin().then((value) => _nextPage());
  }

  _nextPage() {
    const oneSec = Duration(seconds: 3);
    _timer = Timer.periodic(oneSec, (timer) {
      setState(() {
        if (_countdownTime < 1) {
          if (Global.isFirstStart()) {
            Global.selectSubjects(Global.getSelectSubject()).then((value) =>
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(guideScreen, (route) => false));
          } else {
            if (isMultiple) {
              if (Global.isSelectSubjects()) {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(homeScreen, (route) => false);
              } else {
                Global.selectSubjects(Global.getSelectSubject()).then((value) =>
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(subjectsSelectScreen, (route) => false));
              }
            } else {
              Global.selectSubjects(Global.getSelectSubject()).then((value) =>
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(homeScreen, (route) => false));
            }
          }
          _timer?.cancel();
        } else {
          _countdownTime = _countdownTime - 1;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    HYSizeFit.initialize(context);
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: [resColor.launcherTopColor, resColor.launcherBottomColor],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Expanded(
            child: SizedBox(),
            flex: 4,
          ),
          Expanded(
            child: Text(
              resStr.launcherText,
              style: const TextStyle(
                decoration: TextDecoration.none,
                fontStyle: FontStyle.italic,
                color: Colors.white,
                fontSize: 28,
              ),
            ),
            flex: 1,
          ),
          const Expanded(
            child: SizedBox(),
            flex: 5,
          ),
        ],
      ),
    );
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlugin() async {
    final TrackingStatus status =
        await AppTrackingTransparency.trackingAuthorizationStatus;
    setState(() => _authStatus = '$status');
    // If the system can show an authorization request dialog
    if (status == TrackingStatus.notDetermined) {
      // Show a custom explainer dialog before the system dialog
      await showCustomTrackingDialog(context);
      // Wait for dialog popping animation
      await Future.delayed(const Duration(milliseconds: 200));
      // Request system's tracking authorization dialog
      final TrackingStatus status =
          await AppTrackingTransparency.requestTrackingAuthorization();
      setState(() => _authStatus = '$status');
    }

    final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
    print("UUID: $uuid");
  }

  Future<void> showCustomTrackingDialog(BuildContext context) async =>
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Dear User'),
          content: const Text(
            'We care about your privacy and data security. We keep this app free by showing ads. '
            'Can we continue to use your data to tailor ads for you?\n\nYou can change your choice anytime in the app settings. '
            'Our partners will collect data and use a unique identifier on your device to show you ads.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Continue'),
            ),
          ],
        ),
      );
}
