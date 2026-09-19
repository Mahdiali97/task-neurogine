import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/product_controller.dart';
import '../widgets/product_item_card.dart';
import '../widgets/error_state_widget.dart';
import '../widgets/empty_state_widget.dart';
import 'product_detail_screen.dart';

class ProductListScreen extends StatefulWidget {
  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      context.read<ProductController>().loadMoreProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ProductController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Catalog')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: controller.onSearchQueryChanged,
              decoration: const InputDecoration(hintText: 'Search...'),
            ),
          ),
          Expanded(
            child: _buildBody(controller),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(ProductController controller) {
    switch (controller.state) {
      case ViewState.loading: return const Center(child: CircularProgressIndicator());
      case ViewState.error: return ErrorStateWidget(message: controller.errorMessage, onRetry: controller.loadProducts);
      case ViewState.empty: return EmptyStateWidget();
      case ViewState.success:
        return RefreshIndicator(
          onRefresh: controller.refresh,
          child: ListView.builder(
            controller: _scrollController,
            itemCount: controller.products.length + (controller.isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == controller.products.length) return const Center(child: CircularProgressIndicator());
              return ProductItemCard(
                product: controller.products[index],
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailScreen(product: controller.products[index]))),
              );
            },
          ),
        );
    }
  }
}
