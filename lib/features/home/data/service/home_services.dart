import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/place_model.dart';

class HomeServices {
  final FirebaseFirestore firestore;

  HomeServices(this.firestore);

  Stream<List<PlaceModel>> watchPlaces() {
    return firestore.collection('places').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => PlaceModel.fromJson(doc.id, doc.data()))
          .toList();
    });
  }
}
