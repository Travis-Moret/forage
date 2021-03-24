import 'package:flutter/material.dart';
import 'package:forageApp/widgets/defaultScaffold.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:forageApp/widgets/fabScaffold.dart';
import 'Package:forageApp/models/post.dart';

///Screen View to add a new entry 
class NewPostScreen extends StatefulWidget {
  @override
  NewPostScreenState createState() => NewPostScreenState();
}

class NewPostScreenState extends State<NewPostScreen> {
  
  //Instantiate a post from the model
  Post post = Post(date: DateTime.now()); 
  File image;
  LocationData location;  
  
  //Get the device location
  var locationService = Location();

  //Get an image picker
  final picker = ImagePicker();

  //Create a key for the form
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    retrieveLocation();
  }

  //Ask for permission and recieve the device location to enter into db
  void retrieveLocation() async {
    try {
      var _locationServiceEnabled = await locationService.serviceEnabled();

      if (!_locationServiceEnabled) {
        _locationServiceEnabled = await locationService.requestService();

        if (!_locationServiceEnabled) {
          print('Location services not enabled.');
          return;
        }
      }

      var _locationPermissionGranted = await locationService.hasPermission();

      if (_locationPermissionGranted == PermissionStatus.denied) {
        _locationPermissionGranted = await locationService.requestPermission();

        if (_locationPermissionGranted != PermissionStatus.granted) {
          print('Location services not granted');
          return;
        }
      }

      location = await locationService.getLocation();
    } on PlatformException catch (exception) {
      print(
          'Error code: ${exception.code} returned error: ${exception.toString()}');
      location = null;
    }

    location = await locationService.getLocation();
    setState(() {});
  }

  //Save form field and provide error message if not validated
  //If validated, send post to Firestore and return to post list screen
  void validateForm() {
    if (formKey.currentState.validate()) {  
      formKey.currentState.save();
      addPostToFirestore(post);
      returnToPostsScreen(context);
    }
  }

  //Get an image from the camera or gallery and give it a reference
  retrieveImage(bool takePhoto) async { 
    
    final pickedFile = takePhoto ? 
    await picker.getImage(source: ImageSource.camera) : 
    await picker.getImage(source: ImageSource.gallery);
    if(pickedFile == null){
      return; 
    }
    image = File(pickedFile.path);
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child('image' + DateTime.now().toString());
    UploadTask uploadTask = ref.putFile(image);
    uploadTask.then((result) async {
      post.url = await result.ref.getDownloadURL();
    });
    setState(() {});
  }

  void returnToPostsScreen(BuildContext context) {
    Navigator.of(context).pop();
  }

  //Add a completed post object to firestore
  void addPostToFirestore(Post post) {
    post.latitude = location.latitude; 
    post.longitude = location.longitude; 
    FirebaseFirestore.instance.collection('posts').add({
      'title': post.title,
      'date': DateFormat('E MMM d, yyyy').format(post.date),
      'imageURL': post.url,
      'quantity': post.quantity,
      'latitude': post.latitude,
      'longitude': post.longitude,
    });
  }

  //Widget to create a form once an image is taken or chosen from gallery
  Widget postForm() {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 20, left: 60, right: 60),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Title your Post', style: TextStyle(fontSize: 25)),
              SizedBox(height: 10),
              Semantics(
                textField: true,
                onLongPressHint: 'Enter a title for the post',
                child:TextFormField(
                  autocorrect: true,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: 'Post Title (Max 30 chars)'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a title for the post';
                    } else {
                      return null;
                    }
                  },
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(30),
                  ],
                  onSaved: (value) {
                    post.title = value;
                  })),
              SizedBox(height: 20),
              Text('How many do you have?',
                  style: TextStyle(fontSize: 25)),
              SizedBox(height: 10),
              Semantics(
                textField: true,
                onLongPressHint: 'Enter a quantity between 1 and 999',
                child:TextFormField(
                  autocorrect: true,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  decoration:InputDecoration(labelText: 'Quantity (1-999)'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a quantity between 1 and 999';
                    } else {
                      return null;
                    }
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(3),
                    FilteringTextInputFormatter.allow(RegExp('[1-9]'))
                  ],
                  onSaved: (value) {
                    post.quantity = int.parse(value);
                  })),
              SizedBox(height: 20),
              Text('Image preview: ', style: TextStyle(fontSize: 25)),
              SizedBox(height: 20),
            ]))));
  }


  @override
  Widget build(BuildContext context) {
    if (location == null) {
      return DefaultScaffold(
          titleText: Text('Create Post'),
          screenBody: Semantics(
            image: true, 
            onLongPressHint: 'Loading...',
            child: Center(child: CircularProgressIndicator())));
    } else {
      if (image == null) {
        return FabScaffold(
            titleText: Text('Create Post'),
            screenBody: SingleChildScrollView(child: Center(child: Column(
              children: [
                SizedBox(height: 20),
                Text('Take a photo or choose from gallery', style: TextStyle(fontSize: 25)),
                SizedBox(height: 20),
                FractionallySizedBox(
                  widthFactor: .90,
                  child: Icon(Icons.image_search, size: 400)),           
                SizedBox(height: 50),
                Semantics(
                  button: true, 
                  enabled: true, 
                  onLongPressHint: 'Choose a photo from the gallery',
                  child: Container(height: 50, width: 200, 
                    child: ElevatedButton(
                      child: Text('Choose Photo', style: TextStyle(fontSize: 25)),
                      onPressed: () {retrieveImage(false);}))),
                SizedBox(height: 20)
              ]))),
            fab: Semantics(
              button: true, 
              enabled: true,
              onLongPressHint: 'Use the Camera to take a photo',
              child: FloatingActionButton(
                onPressed: () {retrieveImage(true);},
                tooltip: 'Take a photo',
                child: Icon(Icons.photo_camera))));
      } else {
        return DefaultScaffold(
            titleText: Text('Create Post'),
            screenBody: Center(
                child: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                  postForm(),
                  Semantics(
                    image: true, 
                    onLongPressHint: 'Post image chosen',
                    child:FractionallySizedBox(
                      widthFactor: 0.70, child: Image.file(image))),
                  SizedBox(height: 30),
                  Container(height: 50, width: 150,
                    child: ElevatedButton(
                      child: Text('Post it!', style: TextStyle(fontSize: 25)),
                      onPressed: () {validateForm();})),
                  SizedBox(height: 30)
                ]))));
      }
    }
  }
}
