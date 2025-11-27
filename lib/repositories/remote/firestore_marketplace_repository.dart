import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/constants/firestore_paths.dart';
import '../../models/marketplace_item_model.dart';
import '../interfaces/marketplace_repository.dart';

class FirestoreMarketplaceRepository implements MarketplaceRemoteRepository {
  FirestoreMarketplaceRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection {
    return _firestore.collection(FirestorePaths.marketplace);
  }

  @override
  Future<void> markAsSold(String itemId, {required String buyerId}) async {
    await _collection.doc(itemId).update({
      'isListed': false,
      'buyerId': buyerId,
      'soldAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> publishListing(MarketplaceItem item) async {
    await _collection.doc(item.id).set(item.toJson(), SetOptions(merge: true));
  }

  @override
  Future<void> removeListing(String itemId) async {
    await _collection.doc(itemId).delete();
  }

  @override
  Stream<List<MarketplaceItem>> watchGlobalListings() {
    return _collection
        .where('isListed', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MarketplaceItem.fromJson(<String, dynamic>{...doc.data(), 'id': doc.id}))
            .toList(growable: false));
  }
}

