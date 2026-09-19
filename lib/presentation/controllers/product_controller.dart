import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/models/product.dart';
import '../../data/services/product_api_service.dart';

enum ViewState { loading, success, empty, error }

class ProductController extends ChangeNotifier {
  final ProductApiService apiService;
  
  List<Product> products = [];
  ViewState state = ViewState.loading;
  String errorMessage = '';
  
  int limit = 20;
  int skip = 0;
  int total = 0;
  bool hasMore = true;
  bool isLoadingMore = false;
  
  String currentQuery = '';
  Timer? _debounce;

  ProductController({required this.apiService}) {
    loadProducts();
  }

  Future<void> loadProducts({bool isSearch = false}) async {
    if (!isSearch) {
      state = ViewState.loading;
      skip = 0;
      products.clear();
      notifyListeners();
    }

    try {
      final response = currentQuery.isEmpty
          ? await apiService.fetchProducts(limit: limit, skip: skip)
          : await apiService.searchProducts(currentQuery, limit: limit, skip: skip);
      
      products = response.products;
      total = response.total;
      hasMore = products.length < total;
      state = products.isEmpty ? ViewState.empty : ViewState.success;
    } catch (e) {
      state = ViewState.error;
      errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<void> loadMoreProducts() async {
    if (isLoadingMore || !hasMore) return;
    isLoadingMore = true;
    skip += limit;
    
    try {
      final response = currentQuery.isEmpty
          ? await apiService.fetchProducts(limit: limit, skip: skip)
          : await apiService.searchProducts(currentQuery, limit: limit, skip: skip);
      
      products.addAll(response.products);
      hasMore = products.length < response.total;
    } catch (e) {
      skip -= limit;
    } finally {
      isLoadingMore = false;
      notifyListeners();
    }
  }

  void onSearchQueryChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      currentQuery = query;
      skip = 0;
      loadProducts(isSearch: true);
    });
  }

  Future<void> refresh() async {
    skip = 0;
    await loadProducts();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
