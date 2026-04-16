import 'package:flutter/material.dart';
import '../core/services/product_service.dart';
import '../models/product.dart';

class ProductProvider extends ChangeNotifier {
  final ProductService _service = ProductService();
  List<Product> products = [];
  bool isLoading = false;
  String? error;

  Future<void> loadProducts({bool onlyActive = false}) async {
    _setLoading(true);
    error = null;
    try {
      products = await _service.fetchProducts(onlyActive: onlyActive);
    } catch (e) {
      error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addProduct(Product product) async {
    error = null;
    await _service.createProduct(product);
    await loadProducts(onlyActive: false);
  }

  Future<void> updateProduct(Product product) async {
    error = null;
    await _service.updateProduct(product);
    await loadProducts(onlyActive: false);
  }

  Future<void> deleteProduct(String id) async {
    error = null;
    await _service.deleteProduct(id);
    await loadProducts(onlyActive: false);
  }

  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
