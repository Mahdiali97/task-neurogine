import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductApiService {
  static const String baseUrl = 'https://dummyjson.com/products';
  final http.Client client;

  ProductApiService({http.Client? client}) : client = client ?? http.Client();

  Future<ProductResponse> fetchProducts({int limit = 20, int skip = 0}) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl?limit=$limit&skip=$skip'),
      );
      if (response.statusCode == 200) {
        return ProductResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load products. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<Product> fetchProductDetail(int id) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/$id'),
      );
      if (response.statusCode == 200) {
        return Product.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load product. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<ProductResponse> searchProducts(String query, {int limit = 20, int skip = 0}) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/search?q=$query&limit=$limit&skip=$skip'),
      );
      if (response.statusCode == 200) {
        return ProductResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to search products. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
