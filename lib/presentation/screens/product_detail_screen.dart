import 'package:flutter/material.dart';
import '../../data/models/product.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  const ProductDetailScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: ListView(
        children: [
          Hero(tag: 'product-${product.id}', child: Image.network(product.thumbnail)),
          Text(product.title, style: const TextStyle(fontSize: 24)),
          Text('\$${product.price.toStringAsFixed(2)}'),
          Text('Rating: ${product.rating}'),
          Text(product.description),
          Text('Availability: ${product.availabilityStatus}'),
        ],
      ),
    );
  }
}
