import 'package:flutter/material.dart';

///A scaffold that includes a floating action button
class FabScaffold extends StatelessWidget {

  final Widget titleText;
  final Widget screenBody;
  final Widget fab;
  final FloatingActionButtonLocation location; 

  FabScaffold({this.titleText, this.screenBody, this.fab, this.location});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        centerTitle: true,
        title: titleText,
      ),
      body: screenBody,
      floatingActionButton: fab,
      floatingActionButtonLocation: location);
  }
}
