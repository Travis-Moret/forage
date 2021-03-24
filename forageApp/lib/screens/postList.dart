import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:forageApp/widgets/fabScaffold.dart';

///Screen to view all posts 
class PostListScreen extends StatefulWidget {
  @override
  _PostListScreenState createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  
  // Navigate to new post page
  void pushNewPostScreen(BuildContext context) {
    Navigator.of(context).pushNamed('newPostScreen');
  }

  // Navigate to details page
  void pushViewDetailsScreen(BuildContext context, DocumentSnapshot post) {
    Navigator.of(context).pushNamed('viewDetailsScreen', arguments: post);
  }

  @override
  Widget build(BuildContext context) {
    return FabScaffold(
        titleText: Text('Forage'),
        screenBody: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('posts').orderBy('date', descending: false).snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData &&
                snapshot.data.docs != null &&
                snapshot.data.docs.length > 0) {
              return ListView.builder(
                itemExtent: 80.0,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (contect, index) {
                  DocumentSnapshot post = snapshot.data.docs[index];
                  return Semantics(
                    button: true, 
                    enabled: true,
                    onLongPressHint: 'View post details',
                    child: ListTile(
                      title: Text(post['title'], style: TextStyle(fontSize: 25)),
                      subtitle: Text(post['date'].toString(), style: TextStyle(fontSize: 18)),
                      trailing: Text(post['quantity'].toString(), style: TextStyle(fontSize: 25)),
                      onTap: () {pushViewDetailsScreen(context, post);}));
                  });
            } else {
              return SingleChildScrollView(child: Center(
                child: Column(children: [
                    SizedBox(height: 20),
                    Text('No posts in your area', style: TextStyle(fontSize: 25)),
                    SizedBox(height: 70),
                    CircularProgressIndicator(),
                    SizedBox(height: 20), 
                    FractionallySizedBox(
                      widthFactor: .90,
                      child: Icon(Icons.notes, size: 300)),
                    SizedBox(height: 20),
                    Text('Be the first to post!', style: TextStyle(fontSize: 25)),
                    SizedBox(height: 20)
                      ])));
            }
          }),
        fab: Semantics(
          button: true, 
          enabled: true,
          onLongPressHint: 'Add new post',
          child: FloatingActionButton(
            onPressed: () {
              pushNewPostScreen(context);
            },
            tooltip: 'Add new post',
            child: Icon(Icons.post_add))),
        location: FloatingActionButtonLocation.centerFloat);
  }
}
