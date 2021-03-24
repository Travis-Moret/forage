import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:forageApp/screens/newPost.dart';
import 'package:forageApp/screens/viewDetails.dart';
import 'package:forageApp/screens/postList.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

/// App sets the application theme and the page routes
class App extends StatelessWidget {
  
  static final routes = {
    '/': (context) => PostListScreen(),
    'newPostScreen': (context) => NewPostScreen(),
    'viewDetailsScreen': (context) => ViewDetailsScreen()
  };

  //Instantiate the Analytics and observer for Firebase Analytics
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context) {
    // FirebaseCrashlytics.instance.crash();  
    return MaterialApp(
        title: 'Forage App',
        theme: ThemeData(brightness: Brightness.dark),
        debugShowCheckedModeBanner: false,
        navigatorObservers: <NavigatorObserver>[observer], //Set observer
        routes: routes);
  }
}
