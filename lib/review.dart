import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  int _value;
  String _comment;
  String _uid;
  DateTime _date;

  Review( this._comment, this._value, this._uid, this._date);

  DateTime get fecha => _date;
  set fecha(DateTime fecha) => _date = fecha;
  String get uid => _uid;
  int get valoracion => _value;
  set valoracion(int val) => _value = val;
  String get comentario => _comment;
  set comentario(String comment) => _comment = comment;

  DateTime readTimestamp(Timestamp timestamp) {
    return timestamp.toDate();
  }

  Review.fromFirestore(Map<String, dynamic> json){
    print(json);
    _comment = json['comment'];
    _value = json['value'];
    _uid = json['uid'];
    _date = readTimestamp(json['date']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this._value;
    data['comment'] = this._comment;
    data['uid'] = this._uid;
    data['date'] = this._date;
    
    return data;
  }

}