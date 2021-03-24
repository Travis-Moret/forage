import 'package:flutter_test/flutter_test.dart';
import 'Package:forageApp/models/post.dart';

void main() {
  test('Model instantiation based on constructor', () {
    String title = 'post';
    DateTime date = DateTime.now();
    int quantity = 5;
    String url = 'exampleURL';
    double latitude = 99.00005;
    double longitude = -42.00006;

    final post = Post(
      title: title,
      date: date,
      url: url,
      quantity: quantity,
      latitude: latitude,
      longitude: longitude,
    );

    expect(post.title, title);
    expect(post.date, date);
    expect(post.url, url);
    expect(post.quantity, quantity);
    expect(post.latitude, latitude);
    expect(post.longitude, longitude);
  });

  test('Model accessible based on assignments', () {
    String passedTitle = 'post';
    DateTime passedDate = DateTime.now();
    int passedQuantity = 5;
    String passedUrl = 'exampleURL';
    double passedLatitude = 00.00000;
    double passedLongitude = -00.00006;

    final post = Post();

    post.title = passedTitle;
    post.date = passedDate;
    post.quantity = passedQuantity;
    post.url = passedUrl;
    post.latitude = passedLatitude;
    post.longitude = passedLongitude;

    expect(post.title, passedTitle);
    expect(post.date, passedDate);
    expect(post.url, passedUrl);
    expect(post.quantity, passedQuantity);
    expect(post.latitude, passedLatitude);
    expect(post.longitude, passedLongitude);
  });
}
