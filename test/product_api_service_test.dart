import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:product_catalog/data/models/product.dart';
import 'package:product_catalog/data/services/product_api_service.dart';

void main() {
  group('ProductApiService', () {
    test('fetchProducts returns ProductResponse on 200', () async {
      final mockClient = MockClient((request) async {
        return http.Response(json.encode({
          'products': [{
            'id': 101,
            'title': 'Apple AirPods Max Silver',
            'description': 'Description',
            'price': 549.99,
            'rating': 3.47,
            'tags': ['electronics'],
            'reviews': [],
            'images': [],
            'thumbnail': 'thumb.webp'
          }],
          'total': 1,
          'skip': 0,
          'limit': 20
        }), 200);
      });

      final service = ProductApiService(client: mockClient);
      final response = await service.fetchProducts();

      expect(response.products.first.title, 'Apple AirPods Max Silver');
      expect(response.products.first.id, 101);
    });

    test('fetchProducts throws exception on non-200', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Not Found', 404);
      });

      final service = ProductApiService(client: mockClient);
      expect(service.fetchProducts(), throwsException);
    });
  });
}
