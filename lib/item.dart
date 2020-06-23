
import 'package:reviewstest/review.dart';

class Item {

  String _id;
  String _name;
  List<Review> _reviews;

  String get id => _id;
  String get name => _name;
  List<Review> get reviews => _reviews;
  set categories(List<Review> reviews) => _reviews = reviews;

  Item.fromJson(String id, Map<String, dynamic> json){
    _id = id;
    _name = json['name'];
    if (json['reviews'] != null) {
      _reviews = new List<Review>();
      List _features2 = json['reviews'] as List;
      if(_features2.isNotEmpty){
        json['reviews'].forEach((v) {
          _reviews.add(new Review.fromFirestore(v));
        });
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this._name;
    if (this._reviews != null) {
      data['reviews'] = this._reviews.map((v) => v.toJson()).toList();
    }
    return data;
  }

}