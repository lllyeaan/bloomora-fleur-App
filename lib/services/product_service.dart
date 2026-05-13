import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/product_model.dart';
import 'auth_service.dart';

class ProductService {
  static const String baseUrl = 'https://task.itprojects.web.id';

  final AuthService authService = AuthService();

  Future<List<ProductModel>> getProducts() async {
    final token = await authService.getToken();

    if (token == null || token.isEmpty) {
      throw Exception('Token kosong. Silakan login ulang.');
    }

    final url = Uri.parse('$baseUrl/api/products');

    print('URL GET PRODUCTS: $url');
    print('TOKEN GET PRODUCTS: $token');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    print('STATUS GET PRODUCTS: ${response.statusCode}');
    print('RESPONSE GET PRODUCTS: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final dynamic rawProducts = data['data'] is Map
          ? data['data']['products']
          : data['data'];

      if (rawProducts == null) {
        return [];
      }

      if (rawProducts is! List) {
        throw Exception('Format data products tidak sesuai: $rawProducts');
      }

      return rawProducts.map((item) {
        return ProductModel.fromJson(item);
      }).toList();
    }

    throw Exception('Gagal mengambil data produk: ${response.body}');
  }

  Future<bool> addProduct(ProductModel product) async {
    final token = await authService.getToken();

    if (token == null || token.isEmpty) {
      throw Exception('Token kosong. Silakan login ulang.');
    }

    final url = Uri.parse('$baseUrl/api/products');

    final body = {
      'name': product.name,
      'price': product.price,
      'description': product.description,
    };

    print('URL ADD PRODUCT: $url');
    print('TOKEN ADD PRODUCT: $token');
    print('BODY ADD PRODUCT: ${jsonEncode(body)}');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(body),
    );

    print('STATUS ADD PRODUCT: ${response.statusCode}');
    print('RESPONSE ADD PRODUCT: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    }

    throw Exception('Gagal menambahkan produk: ${response.body}');
  }

  Future<bool> deleteProduct(int productId) async {
    final token = await authService.getToken();

    if (token == null || token.isEmpty) {
      throw Exception('Token kosong. Silakan login ulang.');
    }

    final url = Uri.parse('$baseUrl/api/products/$productId');

    print('URL DELETE PRODUCT: $url');

    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    // print('STATUS DELETE PRODUCT: ${response.statusCode}');
    // print('RESPONSE DELETE PRODUCT: ${response.body}');

    return response.statusCode == 200 || response.statusCode == 204;
  }

  Future<bool> submitProduct({
    required String name,
    required int price,
    required String description,
    required String githubUrl,
  }) async {
    final token = await authService.getToken();

    if (token == null || token.isEmpty) {
      throw Exception('Token kosong. Silakan login ulang.');
    }

    final url = Uri.parse('$baseUrl/api/products/submit');

    final body = {
      'name': name,
      'price': price,
      'description': description,
      'github_url': githubUrl,
    };

    print('URL SUBMIT PRODUCT: $url');
    print('BODY SUBMIT PRODUCT: ${jsonEncode(body)}');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(body),
    );

    print('STATUS SUBMIT PRODUCT: ${response.statusCode}');
    print('RESPONSE SUBMIT PRODUCT: ${response.body}');

    return response.statusCode == 200 || response.statusCode == 201;
  }
}