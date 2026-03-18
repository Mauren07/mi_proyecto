import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:3000/api_v1';
  static String? _authToken;

  static String? get authToken => _authToken;
  static bool get isAuthenticated =>
      _authToken != null && _authToken!.trim().isNotEmpty;

  static void clearSession() {
    _authToken = null;
  }

  static Future<Map<String, dynamic>> login(
    String user,
    String password, {
    http.Client? client,
    String? baseUrlOverride,
  }) async {
    final http.Client httpClient = client ?? http.Client();
    final bool shouldCloseClient = client == null;

    try {
      final response = await httpClient.post(
        Uri.parse('${baseUrlOverride ?? baseUrl}/apiUserLogin'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'api_user': user.trim(),
          'api_password': password.trim(),
        }),
      );

      final dynamic decodedResponse = _decodeJsonResponse(response);
      final Map<String, dynamic> responseData =
          decodedResponse is Map<String, dynamic>
              ? decodedResponse
              : <String, dynamic>{};

      if (response.statusCode == 200) {
        _authToken = responseData['token'] as String?;

        return {
          'success': true,
          'token': responseData['token'],
          'message': responseData['message'] ?? 'Login exitoso',
          'user': responseData['user'],
        };
      }

      return {
        'success': false,
        'message': _extractErrorMessage(
          responseData,
          fallback: 'No fue posible iniciar sesion',
        ),
        'statusCode': response.statusCode,
      };
    } catch (error) {
      return {
        'success': false,
        'message': 'Error de conexion: $error',
      };
    } finally {
      if (shouldCloseClient) {
        httpClient.close();
      }
    }
  }

  static Future<Map<String, dynamic>> fetchUserStatuses({
    http.Client? client,
    String? baseUrlOverride,
  }) async {
    if (!isAuthenticated) {
      return {
        'success': false,
        'message': 'Debes iniciar sesion para consultar estados',
      };
    }

    final http.Client httpClient = client ?? http.Client();
    final bool shouldCloseClient = client == null;

    try {
      final response = await httpClient.get(
        Uri.parse('${baseUrlOverride ?? baseUrl}/userStatus'),
        headers: _buildAuthHeaders(),
      );

      final dynamic decodedResponse = _decodeJsonResponse(response);
      final Map<String, dynamic> responseData =
          decodedResponse is Map<String, dynamic>
              ? decodedResponse
              : <String, dynamic>{};

      if (response.statusCode == 200) {
        final dynamic rawData =
            decodedResponse is List ? decodedResponse : responseData['data'];
        final List<Map<String, dynamic>> statuses =
            rawData is List
                ? rawData
                    .whereType<Map>()
                    .map((item) => Map<String, dynamic>.from(item))
                    .toList()
                : <Map<String, dynamic>>[];

        return {
          'success': true,
          'data': statuses,
        };
      }

      return {
        'success': false,
        'message': _extractErrorMessage(
          responseData,
          fallback: 'No fue posible consultar los estados',
        ),
        'statusCode': response.statusCode,
      };
    } catch (error) {
      return {
        'success': false,
        'message': 'Error de conexion: $error',
      };
    } finally {
      if (shouldCloseClient) {
        httpClient.close();
      }
    }
  }

  static Future<Map<String, dynamic>> createUserStatus(
    String name,
    String description, {
    http.Client? client,
    String? baseUrlOverride,
  }) async {
    final String normalizedName = name.trim();
    final String normalizedDescription = description.trim();

    if (normalizedName.isEmpty || normalizedDescription.isEmpty) {
      return {
        'success': false,
        'message': 'Nombre y descripcion son obligatorios',
      };
    }

    if (!isAuthenticated) {
      return {
        'success': false,
        'message': 'Debes iniciar sesion para crear estados',
      };
    }

    final http.Client httpClient = client ?? http.Client();
    final bool shouldCloseClient = client == null;

    try {
      final response = await httpClient.post(
        Uri.parse('${baseUrlOverride ?? baseUrl}/userStatus'),
        headers: _buildAuthHeaders(),
        body: jsonEncode({
          'name': normalizedName,
          'description': normalizedDescription,
        }),
      );

      final dynamic decodedResponse = _decodeJsonResponse(response);
      final Map<String, dynamic> responseData =
          decodedResponse is Map<String, dynamic>
              ? decodedResponse
              : <String, dynamic>{};

      if (response.statusCode == 201) {
        return {
          'success': true,
          'message':
              responseData['message'] ??
              'Nuevo estado de usuario registrado correctamente',
          'data': responseData['data'],
        };
      }

      return {
        'success': false,
        'message': _extractErrorMessage(
          responseData,
          fallback: 'No fue posible crear el estado',
        ),
        'statusCode': response.statusCode,
      };
    } catch (error) {
      return {
        'success': false,
        'message': 'Error de conexion: $error',
      };
    } finally {
      if (shouldCloseClient) {
        httpClient.close();
      }
    }
  }

  static Map<String, String> _buildAuthHeaders() {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${_authToken ?? ''}',
    };
  }

  static dynamic _decodeJsonResponse(http.Response response) {
    if (response.body.trim().isEmpty) {
      return null;
    }

    return jsonDecode(response.body);
  }

  static String _extractErrorMessage(
    Map<String, dynamic> responseData, {
    required String fallback,
  }) {
    return responseData['error'] as String? ??
        responseData['message'] as String? ??
        fallback;
  }
}
