import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final String _baseUrl = 'http://your-backend-api-url.com'; // Replace with your actual backend URL
  final _storage = const FlutterSecureStorage();

  // Callback to be set by the UI to handle unauthorized errors
  VoidCallback? onUnauthorized;

  Future<String?> _getAccessToken() async {
    return await _storage.read(key: 'accessToken');
  }

  Future<String?> _getRefreshToken() async {
    return await _storage.read(key: 'refreshToken');
  }

  Future<void> _saveTokens(String accessToken, String refreshToken) async {
    await _storage.write(key: 'accessToken', value: accessToken);
    await _storage.write(key: 'refreshToken', value: refreshToken);
  }

  Future<void> deleteAllTokens() async {
    await _storage.delete(key: 'accessToken');
    await _storage.delete(key: 'refreshToken');
  }

  Future<http.Response> _handleRequest(
    Future<http.Response> Function() request,
  ) async {
    var response = await request();

    if (response.statusCode == 401) {
      // Access token might have expired, try to refresh it
      final newTokens = await _refreshToken();
      if (newTokens != null) {
        // Retry the original request with the new access token
        response = await request();
      } else {
        // If refresh fails, the user needs to log in again.
        if (onUnauthorized != null) {
          onUnauthorized!();
        }
      }
    }
    return response;
  }

  Future<Map<String, dynamic>?> _refreshToken() async {
    final refreshToken = await _getRefreshToken();
    if (refreshToken == null) return null;

    final response = await http.post(
      Uri.parse('$_baseUrl/auth/refresh'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'refreshToken': refreshToken}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final newAccessToken = data['accessToken'];
      final newRefreshToken = data['refreshToken'];
      await _saveTokens(newAccessToken, newRefreshToken);
      return data;
    } else {
      // If refresh token is invalid, delete all tokens
      await deleteAllTokens();
      return null;
    }
  }

  // Generic request methods
  Future<http.Response> getData(String endpoint) async {
    return _handleRequest(() async {
      final accessToken = await _getAccessToken();
      return http.get(
        Uri.parse('$_baseUrl/$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
    });
  }

  Future<http.Response> postData(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    return _handleRequest(() async {
      final accessToken = await _getAccessToken();
      return http.post(
        Uri.parse('$_baseUrl/$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode(data),
      );
    });
  }

  Future<http.Response> patchData(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    return _handleRequest(() async {
      final accessToken = await _getAccessToken();
      return http.patch(
        Uri.parse('$_baseUrl/$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: json.encode(data),
      );
    });
  }

  Future<http.Response> deleteData(String endpoint) async {
    return _handleRequest(() async {
      final accessToken = await _getAccessToken();
      return http.delete(
        Uri.parse('$_baseUrl/$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );
    });
  }

  // Auth endpoints
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      await _saveTokens(data['accessToken'], data['refreshToken']);
      return data;
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<Map<String, dynamic>> register(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to register');
    }
  }

  // Task endpoints
  Future<List<dynamic>> getTasks(
      {int page = 1, String? search, bool? isCompleted}) async {
    String query = 'page=$page';
    if (search != null && search.isNotEmpty) {
      query += '&search=$search';
    }
    if (isCompleted != null) {
      query += '&isCompleted=$isCompleted';
    }

    final response = await getData('tasks?$query');
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to get tasks');
    }
  }

  Future<Map<String, dynamic>> createTask(String title, String description) async {
    final response =
        await postData('tasks', {'title': title, 'description': description});
    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create task');
    }
  }

  Future<void> updateTask(String id, String title, String description, bool isCompleted) async {
    final response = await patchData('tasks/$id', {
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
    });
    if (response.statusCode != 200) {
      throw Exception('Failed to update task');
    }
  }

  Future<void> deleteTask(String id) async {
    final response = await deleteData('tasks/$id');
    if (response.statusCode != 200) {
      throw Exception('Failed to delete task');
    }
  }
}
