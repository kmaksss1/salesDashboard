import 'package:flutter/material.dart';
import '../data/product_service.dart';
import '../logic/product_controller.dart';
import 'product_detail_page.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final ProductController controller = ProductController();
  PriceFilter selectedFilter = PriceFilter.all;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Dashboard'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: DropdownButton<PriceFilter>(
              value: selectedFilter,
              underline: const SizedBox(),
              icon: const Icon(Icons.filter_list, color: Colors.white),
              dropdownColor: Colors.white,
              onChanged: (value) {
                if (value != null) {
                  setState(() => selectedFilter = value);
                }
              },
              items: const [
                DropdownMenuItem(value: PriceFilter.all, child: Text('Все')),
                DropdownMenuItem(
                  value: PriceFilter.under100,
                  child: Text('До 100'),
                ),
                DropdownMenuItem(
                  value: PriceFilter.between100And500,
                  child: Text('100–500'),
                ),
                DropdownMenuItem(
                  value: PriceFilter.over500,
                  child: Text('Свыше 500'),
                ),
              ],
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: controller.getProducts(selectedFilter),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Нет товаров'));
          }

          final products = snapshot.data!;
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (_, index) {
              final product = products[index];
              return ListTile(
                leading: Image.network(
                  product.thumbnail,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const SizedBox(
                      width: 50,
                      height: 50,
                      child: Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.error),
                ),
                title: Text(product.title),
                subtitle: Text('${product.price} \$'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailPage(product: product),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
