
import '../data/product_service.dart';

enum PriceFilter { all, under100, between100And500, over500 }

class ProductController {
  final ProductService _service = ProductService();

  Future<List<Product>> getProducts(PriceFilter filter) async {
    List<Product> allProducts = await _service.fetchProducts();

    return switch (filter) {
      PriceFilter.all => allProducts,
      PriceFilter.under100 =>
        allProducts.where((p) => p.price < 100).toList(),
      PriceFilter.between100And500 =>
        allProducts.where((p) => p.price >= 100 && p.price <= 500).toList(),
      PriceFilter.over500 =>
        allProducts.where((p) => p.price > 500).toList(),
    };
  }
}
