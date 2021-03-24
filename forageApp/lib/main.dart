import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:forageApp/app.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

Future<void> main() async {

  // Set bindings and allow device orientation change
  WidgetsFlutterBinding.ensureInitialized();

  //Connect to Firebase
  await Firebase.initializeApp();

  //Instantiate Firebase Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  //Allow the program to rotate left or right in landscape mode
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.portraitUp
  ]);

  runApp(App());
}
