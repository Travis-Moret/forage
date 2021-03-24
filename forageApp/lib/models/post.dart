
///Model to temporarily store post data until it is passed on to Firebase
class Post {
  
  String title;
  DateTime date;
  int quantity;
  String url;
  double latitude;
  double longitude;

  Post({this.title, this.date, this.quantity, this.url, this.latitude, this.longitude});
}
