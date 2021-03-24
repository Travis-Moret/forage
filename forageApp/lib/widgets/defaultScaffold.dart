import 'package:flutter/material.dart';

///A default scaffold with no floating action button
class DefaultScaffold extends StatelessWidget {
  
  final Widget titleText;
  final Widget screenBody;

  DefaultScaffold({this.titleText, this.screenBody});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        centerTitle: true,
        title: titleText,
      ),
      body: screenBody);
  }
}
