import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:erank_app/core/constants/api_constants.dart';
import 'package:erank_app/services/auth_storage.dart';

/// Exceção customizada para erros da API
class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException(this.message, this.statusCode);

  @override
  String toString() => message;
}

class ApiClient {
  static const String _baseUrl = ApiConstants.baseUrl;

  static Future<Map<String, String>> _getHeaders() async {
    final token = await AuthStorage.getToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<http.Response> get(String endpoint) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    final headers = await _getHeaders();
    return await http.get(url, headers: headers);
  }

  static Future<http.Response> post(String endpoint,
      {Map<String, dynamic>? body}) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    final headers = await _getHeaders();
    return await http.post(
      url,
      headers: headers,
      body: body != null ? jsonEncode(body) : null,
    );
  }

  static Future<http.Response> put(String endpoint,
      {Map<String, dynamic>? body}) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    final headers = await _getHeaders();
    return await http.put(
      url,
      headers: headers,
      body: body != null ? jsonEncode(body) : null,
    );
  }

  static Future<http.Response> patch(String endpoint,
      {Map<String, dynamic>? body}) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    final headers = await _getHeaders();
    return await http.patch(
      url,
      headers: headers,
      body: body != null ? jsonEncode(body) : null,
    );
  }

  static Future<http.Response> delete(String endpoint) async {
    final url = Uri.parse('$_baseUrl$endpoint');
    final headers = await _getHeaders();
    return await http.delete(url, headers: headers);
  }

  static dynamic handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return {};

      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      String errorMsg = 'Erro desconhecido';
      try {
        final body = jsonDecode(utf8.decode(response.bodyBytes));

        errorMsg = body['message'] ?? body['error'] ?? 'Erro na requisição';
      } catch (_) {
        errorMsg = 'Erro HTTP ${response.statusCode}';
      }
      throw ApiException(errorMsg, response.statusCode);
    }
  }
}
