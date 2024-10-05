import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/user_model.dart';

class UserRepository {
  final FirebaseFirestore firestore;

  UserRepository({required this.firestore});

  Future<Map<String, dynamic>> getItems() async {
    var collection = firestore.collection('main');
    Query query = collection.limit(10);

    QuerySnapshot querySnapshot = await query.get();

    if (querySnapshot.docs.isNotEmpty) {
      List<UserModel> items = querySnapshot.docs
          .map((e) => UserModel(
                id: e.id,
                name: e.get('name'),
              ))
          .toList();
      return {'users': items, 'lastDoc': querySnapshot.docs.last};
    }

    return {};
  }

  Future<Map<String, dynamic>> getMoreData(
    QueryDocumentSnapshot lastDocs,
  ) async {
    var collection = firestore.collection('main');

    Query query = collection.startAfterDocument(lastDocs).limit(10);

    QuerySnapshot querySnapshot = await query.get();

    if (querySnapshot.docs.isNotEmpty) {
      List<UserModel> items = querySnapshot.docs
          .map((e) => UserModel(
                id: e.id,
                name: e.get('name'),
              ))
          .toList();
      return {'users': items, 'lastDoc': querySnapshot.docs.last};
    }

    return {};
  }
}
