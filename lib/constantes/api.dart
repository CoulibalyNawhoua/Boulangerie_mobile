class Api {
  static const url = 'https://boulangerie-api.distriforce.shop/api';
  static const urlImage = 'https://boulangerie-api.distriforce.shop/storage/';
  // static const url = 'http://192.168.1.69:8000/api';
  // static const urlImage = 'http://192.168.1.69:8000/storage/';

  static const login = '$url/mob-signin';
  static const product = '$url/deliveries-by-date';
  static const orderReturn = '$url/order-return-by-livreurs';
  static const deliveries = '$url/deliveries-by-livreurs';
  static const transactions = '$url/transactions-by-livreurs';
  static const transactionsRecents = '$url/transactions-livreurs-recent';
  static String reliquats(int id) {
    return '$url/reliquat-versements-by-livreurs/$id';
  }
  static const paiement = '$url/create-transaction-mobile';
  static const updateStatusTransaction = '$url/update-transaction-mobile';
  static const listBoulangerie = '$url/bakehouses-users-list';
}