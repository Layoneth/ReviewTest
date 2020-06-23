import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reviewstest/item.dart';
import 'package:reviewstest/review.dart';
import 'package:rxdart/rxdart.dart';

class Reviewtest {
  //Firestore Instance
  final _db =  Firestore.instance;
  final pages = 2; // n pages of reviews
  List<DocumentSnapshot> documentList;
  List<Review> reviews = [];
  BehaviorSubject<List<Review>> reviewsController
    = BehaviorSubject<List<Review>>();

  Stream<List<Review>> get movieStream 
    => reviewsController.stream;

  Future<bool> setReview( Review rev, String itemId ) async {
    try {
      await _db.collection('Items')
        .document(itemId)
        .collection('reviews')
        .document(rev.uid)
        .setData(rev.toJson());
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  // Item getReviewinItem(Item item, String uid, int value, {String comment}){

  //   Item myItem = item;
  //   bool changed = false;

  //   for (var rev in myItem.reviews) {
  //     if(rev.uid == uid){
  //       rev.valoracion = value;
  //       rev.comentario = comment;
  //       changed = true;
  //     }
  //   }
  //   if(changed){return myItem;}
  //   else{
  //     myItem.reviews.add(
  //       Review(
  //         comment,
  //         value,
  //         uid,
  //         DateTime.now()
  //       )
  //     );
  //     return myItem;
  //   }
  // }

  Future<List<Item>> getItems() async {
    final ab = await _db.collection('Items').getDocuments();
    final ac = ab.documents.map((snap) =>
        Item.fromJson(snap.documentID, snap.data)).toList();
    return ac;
  }

  getReviews(String itemId) async {
    documentList = (await _db.collection('Items/$itemId/reviews')
      .orderBy('date').limit(pages).getDocuments()).documents;
    reviews.addAll(documentList.map((e) => Review.fromFirestore(e.data)));

    reviewsController.sink.add(reviews);
  }

  loadMoreReviews(String itemId) async {
    final newDocumentList = (await _db.collection('Items/$itemId/reviews')
      .orderBy('date')
      .startAfterDocument(documentList[documentList.length - 1])
      .limit(pages)
      .getDocuments()).documents;

      documentList.addAll(newDocumentList);
      reviews.addAll(newDocumentList.map((e) => Review.fromFirestore(e.data)));
      reviewsController.sink.add(reviews);
  }

  void dispose() {
    reviewsController.close();
  }

}