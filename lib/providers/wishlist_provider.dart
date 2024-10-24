import 'package:flutter/material.dart';

class WishListProvider with ChangeNotifier {
  final List<String> _wishlist = [];

  List<String> get wishlist => _wishlist;

  bool isInWishlist(String documentId) {
    return _wishlist.contains(documentId);
  }

  void addProduct(String documentId) {
    _wishlist.add(documentId);
    notifyListeners();
  }

  void removeProduct(String documentId) {
    _wishlist.remove(documentId);
    notifyListeners();
  }
}
