
import 'package:dio/dio.dart';

class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String thumbnail;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.thumbnail,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      price: (json['price'] as num).toDouble(),
      description: json['description'],
      thumbnail: json['thumbnail'],
    );
  }
}

class ProductService {
  final Dio _dio = Dio();

  Future<List<Product>> fetchProducts() async {
    try {
      final response = await _dio.get('https://dummyjson.com/products');
      final data = response.data;
      List products = data['products'];
      return products.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Ошибка загрузки данных: $e');
    }
  }
}
