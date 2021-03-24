import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:forageApp/widgets/defaultScaffold.dart';

///Screen to view the details of a post
class ViewDetailsScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {

    //Get the entry passed by pressing on the post in listview
    DocumentSnapshot post = ModalRoute.of(context).settings.arguments;

    //Get the url of the post from FireStore to load from Firebase
    final url = post['imageURL'];

    return DefaultScaffold(
      titleText: Text('Post details'),
      screenBody: SingleChildScrollView(
        child: Center(
          child: Column(children: [
            SizedBox(height: 20),
            Text(post['date'].toString(), style: TextStyle(fontSize: 25)),
            SizedBox(height: 20),
            Semantics(
              image: true,
              onLongPressHint: 'Image of post',
              child: FractionallySizedBox(
                widthFactor: 0.70, child: Image.network(url))),
            SizedBox(height: 20),
            Center(child: Text('Available:', style: TextStyle(fontSize: 25))),
            Center(
              child: Text(post['quantity'].toString(),
              style: TextStyle(fontSize: 25))),
            SizedBox(height: 20),
            Text('Location:', style: TextStyle(fontSize: 25)),
            Text(
              '(' + post['latitude'].toString() +
              ',' + post['longitude'].toString() + ')',
              style: TextStyle(fontSize: 25)),
            SizedBox(height: 20),
          ]))));
  }
}
