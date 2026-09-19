import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../data/models/product.dart';

class ProductItemCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductItemCard({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        onTap: onTap,
        leading: Hero(
          tag: 'product-${product.id}',
          child: CachedNetworkImage(
            imageUrl: product.thumbnail,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(product.title),
        subtitle: Text(product.category ?? ''),
        trailing: Text('\$${product.price.toStringAsFixed(2)}'),
      ),
    );
  }
}
