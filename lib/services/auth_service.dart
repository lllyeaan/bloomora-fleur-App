import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static const String baseUrl = 'task.itprojects.web.id';
  static const FlutterSecureStorage storage = FlutterSecureStorage();

  Future<bool> login(String nim, String password) async {
    final url = Uri.https(baseUrl, '/api/auth/login');

    final bodyData = {'username': nim.trim(), 'password': password.trim()};

    print('URL LOGIN: $url');
    print('BODY DIKIRIM: $bodyData');

    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(bodyData),
    );

    print('STATUS LOGIN: ${response.statusCode}');
    print('RESPONSE LOGIN: ${response.body}');

    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200 && responseData['success'] == true) {
      final token = responseData['data']['token'];
      await storage.write(key: 'token', value: token);
      return true;
    }

    return false;
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'token');
  }

  Future<void> logout() async {
    await storage.delete(key: 'token');
  }
}
