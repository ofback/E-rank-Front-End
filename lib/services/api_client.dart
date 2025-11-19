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

  /// Trata a resposta HTTP:
  /// - Sucesso (200-299): Retorna o JSON decodificado (dynamic) ou Map vazio.
  /// - Erro (>= 300): Lança ApiException com a mensagem vinda do backend.
  static dynamic handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      // Se não tiver corpo (204 No Content), retorna map vazio
      if (response.body.isEmpty) return {};
      // Decodifica UTF-8 para suportar acentuação corretamente
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      // Tenta extrair mensagem de erro do backend (GlobalExceptionHandler)
      String errorMsg = 'Erro desconhecido';
      try {
        final body = jsonDecode(utf8.decode(response.bodyBytes));
        // Procura campos comuns de erro: 'message' ou 'error'
        errorMsg = body['message'] ?? body['error'] ?? 'Erro na requisição';
      } catch (_) {
        errorMsg = 'Erro HTTP ${response.statusCode}';
      }
      throw ApiException(errorMsg, response.statusCode);
    }
  }
}
