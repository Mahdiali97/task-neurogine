import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/models/product.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final hasImages = p.images.isNotEmpty;
    final displayImages = hasImages ? p.images : [p.thumbnail];

    return Scaffold(
      appBar: AppBar(title: Text(p.title)),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          // Image Carousel
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              SizedBox(
                height: 300,
                child: Hero(
                  tag: 'product-${p.id}',
                  child: PageView.builder(
                    itemCount: displayImages.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentImageIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return CachedNetworkImage(
                        imageUrl: displayImages[index],
                        fit: BoxFit.contain,
                      );
                    },
                  ),
                ),
              ),
              if (displayImages.length > 1)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      displayImages.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        width: 8.0,
                        height: 8.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentImageIndex == index
                              ? Colors.blue
                              : Colors.grey.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header & Badges
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        p.title,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    if (p.brand != null && p.brand!.isNotEmpty)
                      Chip(
                        label: Text(p.brand!),
                        backgroundColor: Colors.grey.shade200,
                      ),
                    if (p.category != null && p.category!.isNotEmpty)
                      Chip(
                        label: Text(p.category!),
                        backgroundColor: Colors.blue.shade50,
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Price & Discount
                Row(
                  children: [
                    Text(
                      '\$${p.price.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 24, color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                    if (p.discountPercentage != null && p.discountPercentage! > 0)
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          '(-${p.discountPercentage!.toStringAsFixed(2)}%)',
                          style: const TextStyle(fontSize: 16, color: Colors.red),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),

                // Stock & Availability
                Row(
                  children: [
                    Icon(
                      p.stock != null && p.stock! > 0 ? Icons.check_circle : Icons.cancel,
                      color: p.stock != null && p.stock! > 0 ? Colors.green : Colors.red,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${p.availabilityStatus ?? "Unknown"} ${p.stock != null ? "(${p.stock} left)" : ""}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // Description
                const Text(
                  'Description',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  p.description,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),

                const SizedBox(height: 24),

                // Product Specifications
                const Text(
                  'Specifications',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Card(
                  elevation: 0,
                  color: Colors.grey.shade50,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: [
                        _buildSpecRow('SKU', p.sku ?? 'N/A'),
                        const Divider(),
                        _buildSpecRow(
                          'Dimensions',
                          p.dimensions != null
                              ? '${p.dimensions!.width} × ${p.dimensions!.height} × ${p.dimensions!.depth} cm'
                              : 'N/A',
                        ),
                        const Divider(),
                        _buildSpecRow('Weight', p.weight != null ? '${p.weight} units' : 'N/A'),
                        const Divider(),
                        _buildSpecRow('Shipping', p.shippingInformation ?? 'N/A'),
                        const Divider(),
                        _buildSpecRow('Warranty', p.warrantyInformation ?? 'N/A'),
                        const Divider(),
                        _buildSpecRow('Return Policy', p.returnPolicy ?? 'N/A'),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Customer Reviews
                Row(
                  children: [
                    const Text(
                      'Customer Reviews',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '(${p.reviews.length})',
                      style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                if (p.reviews.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      'No reviews yet',
                      style: TextStyle(fontSize: 16, color: Colors.grey.shade500, fontStyle: FontStyle.italic),
                    ),
                  )
                else
                  ...p.reviews.map((review) => Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                review.reviewerName,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                review.date.split('T').first,
                                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 16),
                              const SizedBox(width: 4),
                              Text('${review.rating}/5', style: const TextStyle(fontWeight: FontWeight.w500)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '"${review.comment}"',
                            style: const TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ),
                  )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey.shade700),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
