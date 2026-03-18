import 'dart:convert';

import 'package:application_login/services/api_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  tearDown(() {
    ApiService.clearSession();
  });

  test('login stores auth token when response is successful', () async {
    final MockClient client = MockClient((http.Request request) async {
      expect(request.method, 'POST');
      expect(request.url.toString(), 'http://test/apiUserLogin');

      return http.Response(
        jsonEncode({
          'success': true,
          'message': 'Login successful',
          'token': 'token-123',
          'user': {'id': 1, 'username': 'admin'},
        }),
        200,
      );
    });

    final Map<String, dynamic> result = await ApiService.login(
      'admin',
      'secret123',
      client: client,
      baseUrlOverride: 'http://test',
    );

    expect(result['success'], true);
    expect(result['token'], 'token-123');
    expect(ApiService.authToken, 'token-123');
  });

  test('fetchUserStatuses sends bearer token and parses data', () async {
    final MockClient loginClient = MockClient((http.Request request) async {
      return http.Response(
        jsonEncode({
          'success': true,
          'message': 'Login successful',
          'token': 'token-456',
        }),
        200,
      );
    });

    await ApiService.login(
      'admin',
      'secret123',
      client: loginClient,
      baseUrlOverride: 'http://test',
    );

    final MockClient statusesClient = MockClient((http.Request request) async {
      expect(request.method, 'GET');
      expect(request.headers['Authorization'], 'Bearer token-456');

      return http.Response(
        jsonEncode({
          'success': true,
          'data': [
            {
              'User_status_id': 1,
              'User_status_name': 'Active',
              'User_status_description': 'Active',
              'create_at': '2024-05-18 00:44:01',
              'update_at': null,
            },
          ],
        }),
        200,
      );
    });

    final Map<String, dynamic> result = await ApiService.fetchUserStatuses(
      client: statusesClient,
      baseUrlOverride: 'http://test',
    );

    expect(result['success'], true);
    expect((result['data'] as List<dynamic>).length, 1);
    expect(result['data'][0]['User_status_name'], 'Active');
  });

  test('fetchUserStatuses also parses raw list responses', () async {
    final MockClient loginClient = MockClient((http.Request request) async {
      return http.Response(
        jsonEncode({
          'success': true,
          'message': 'Login successful',
          'token': 'token-789',
        }),
        200,
      );
    });

    await ApiService.login(
      'admin',
      'secret123',
      client: loginClient,
      baseUrlOverride: 'http://test',
    );

    final MockClient statusesClient = MockClient((http.Request request) async {
      return http.Response(
        jsonEncode([
          {
            'User_status_id': 1,
            'User_status_name': 'Active',
            'User_status_description': 'Active',
            'create_at': '2024-05-18 00:44:01',
            'update_at': null,
          },
          {
            'User_status_id': 2,
            'User_status_name': 'Inactive',
            'User_status_description': 'Inactive',
            'create_at': '2024-05-18 00:44:01',
            'update_at': null,
          },
        ]),
        200,
      );
    });

    final Map<String, dynamic> result = await ApiService.fetchUserStatuses(
      client: statusesClient,
      baseUrlOverride: 'http://test',
    );

    expect(result['success'], true);
    expect((result['data'] as List<dynamic>).length, 2);
    expect(result['data'][1]['User_status_name'], 'Inactive');
  });

  test('createUserStatus validates required fields before calling API', () async {
    final Map<String, dynamic> result = await ApiService.createUserStatus(
      '',
      '',
      baseUrlOverride: 'http://test',
    );

    expect(result['success'], false);
    expect(result['message'], 'Nombre y descripcion son obligatorios');
  });
}
