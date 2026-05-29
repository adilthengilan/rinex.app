import 'package:cloud_firestore/cloud_firestore.dart';

Future<QuerySnapshot> searchProviders({String? city, String? category}) async {
  Query query = FirebaseFirestore.instance
      .collection("service_providers")
      .where("status", isEqualTo: "active");

  if (city != null) {
    query = query.where("city", isEqualTo: city);
  }

  if (category != null) {
    query = query.where("categories", arrayContains: category);
  }

  return await query.get();
}
