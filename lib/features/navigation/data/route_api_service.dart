import 'dart:convert';
import 'package:http/http.dart' as http;
import '../domain/route_model.dart';

class RouteApiService {
  // TODO: Reemplaza con la URL de tu microservicio
  static const String baseUrl = 'https://tu-api.com/api';

  // Headers comunes
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// Crear una nueva ruta en la API
  Future<RouteModel> createRoute(RouteModel route) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/routes'),
        headers: _headers,
        body: jsonEncode(route.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return RouteModel.fromJson(data);
      } else {
        throw Exception('Error al crear la ruta: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error de conexión al crear la ruta: $e');
    }
  }

  /// Obtener una ruta por ID
  Future<RouteModel> getRoute(int routeId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/routes/$routeId'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return RouteModel.fromJson(data);
      } else {
        throw Exception('Error al obtener la ruta: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión al obtener la ruta: $e');
    }
  }

  /// Obtener todas las rutas de un usuario
  Future<List<RouteModel>> getUserRoutes(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/routes?userId=$userId'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => RouteModel.fromJson(json)).toList();
      } else {
        throw Exception('Error al obtener las rutas: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión al obtener las rutas: $e');
    }
  }

  /// Obtener todas las rutas de un evento
  Future<List<RouteModel>> getEventRoutes(int eventId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/routes?eventId=$eventId'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => RouteModel.fromJson(json)).toList();
      } else {
        throw Exception('Error al obtener las rutas del evento: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión al obtener las rutas: $e');
    }
  }

  /// Actualizar una ruta existente
  Future<RouteModel> updateRoute(int routeId, RouteModel route) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/routes/$routeId'),
        headers: _headers,
        body: jsonEncode(route.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return RouteModel.fromJson(data);
      } else {
        throw Exception('Error al actualizar la ruta: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión al actualizar la ruta: $e');
    }
  }

  /// Eliminar una ruta
  Future<void> deleteRoute(int routeId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/routes/$routeId'),
        headers: _headers,
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Error al eliminar la ruta: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión al eliminar la ruta: $e');
    }
  }
}