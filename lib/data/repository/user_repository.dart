import 'package:cloud_firestore/cloud_firestore.dart';

class UsersRepository {
  final FirebaseFirestore fireStore;

  UsersRepository({
    required this.fireStore,
  });

  Future<QuerySnapshot> loadUsers(
    QueryDocumentSnapshot? lastDocs,
  ) async {
    var collection = fireStore.collection('main');
    if (lastDocs == null) {
      ///It mean it is the first page
      Query query = collection.limit(15);
      return await query.get();
    } else {
      Query query = collection.startAfterDocument(lastDocs).limit(15);
      return await query.get();
    }
  }
}
