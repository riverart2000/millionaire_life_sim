class FirestorePaths {
  FirestorePaths._();

  static String userDocument(String userId) => 'users/$userId';
  static String userJarsCollection(String userId) => 'users/$userId/jars';
  static String userTransactionsCollection(String userId) => 'users/$userId/transactions';
  static String userOwnedItemsCollection(String userId) => 'users/$userId/owned_items';
  static const marketplace = 'marketplace';
  static const transactions = 'transactions';
  static const items = 'items';

  static String marketplaceDocument(String itemId) => '$marketplace/$itemId';
  static String transactionDocument(String id) => '$transactions/$id';
  static String itemDocument(String itemId) => '$items/$itemId';
}

