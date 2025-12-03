import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Servicio para integrar Gemini (Google) con generación de rutas (limitado a Tuxtla Gutiérrez)
class RouteGeminiService {
  // IMPORTANTE: no dejes keys en código en producción.
  // Reemplaza por una variable de entorno o secure storage en tu app.
  static const String _geminiApiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: 'AIzaSyD_WHu0nuV8VOspAIa7UwVVZDd_GVB92vI',
  );

  static const String _listModelsUrl =
      'https://generativelanguage.googleapis.com/v1/models?key=';

  // Prompt estricto: obliga al modelo a solo devolver JSON válido en el formato pedido.
  static const String _systemPrompt = '''
Eres un generador de rutas ciclísticas EXCLUSIVAMENTE dentro de Tuxtla Gutiérrez, Chiapas. 

INSTRUCCIONES IMPORTANTES:
- DEBES responder SOLO con JSON válido.
- NO agregues explicaciones, saludos, comentarios NI texto fuera del JSON.
- NO uses comas finales, paréntesis incorrectos, ni dejes llaves sin cerrar.
- Si no puedes generar la ruta, devuelve exactamente:
  {"message": "No se pudo generar ruta en Tuxtla.", "route": null}

FORMATO ESTRICTO DE RESPUESTA:
{
  "message": "Descripción breve de la ruta",
  "route": {
    "name": "Nombre de la ruta",
    "origin": {"lat": 16.75, "lng": -93.12},
    "destination": {"lat": 16.77, "lng": -93.13},
    "waypoints": [
      {"lat": 16.76, "lng": -93.12}
    ],
    "distance": "XX km",
    "elevation": "XX m",
    "terrain": "pavimento|terracería|mixto",
    "difficulty": "fácil|intermedio|difícil",
    "warnings": []
  }
}

TODAS las coordenadas deben ser dentro de Tuxtla Gutiérrez.
''';

  // Bounding box aproximada para Tuxtla Gutiérrez (lat, lng)
  // Ajusta si necesitas más precisión.
  static const double _minLat = 16.65;
  static const double _maxLat = 16.82;
  static const double _minLng = -93.18;
  static const double _maxLng = -93.05;

  /// Detectar modelo válido automáticamente (busca modelos que soporten generateContent)
  Future<String> _getValidModel() async {
    try {
      final response = await http.get(
        Uri.parse('$_listModelsUrl$_geminiApiKey'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final models = data['models'] as List<dynamic>? ?? [];

        // Preferir modelos gemini; fallback al primero que soporte generateContent
        final geminiModel = models.firstWhere(
          (m) =>
              (m['name'] as String?)?.toLowerCase().contains('gemini') ==
                  true &&
              (m['supportedGenerationMethods'] as List<dynamic>?)?.contains(
                    'generateContent',
                  ) ==
                  true,
          orElse: () => null,
        );

        final valid =
            geminiModel ??
            models.firstWhere(
              (m) =>
                  (m['supportedGenerationMethods'] as List<dynamic>?)?.contains(
                    'generateContent',
                  ) ==
                  true,
              orElse: () => null,
            );

        if (valid != null) {
          final name = valid['name'] as String;
          print('Modelo válido encontrado: $name');
          return name;
        } else {
          throw Exception(
            'No hay modelos válidos disponibles para esta API key.',
          );
        }
      } else {
        throw Exception('Error al obtener modelos: ${response.statusCode}');
      }
    } catch (e) {
      print('Excepción al obtener modelos: $e');
      rethrow;
    }
  }

  /// Generar ruta con modelo válido (entrada: texto del usuario)
  Future<RouteAIResponse> generateRoute(String userMessage) async {
    try {
      if (_geminiApiKey == 'YOUR_API_KEY_HERE' || _geminiApiKey.isEmpty) {
        throw Exception(
          'API key no configurada. Define GEMINI_API_KEY en variables de entorno.',
        );
      }

      final modelName = await _getValidModel();
      final fullPrompt =
          '$_systemPrompt\n\nSolicitud del usuario: $userMessage';

      final response = await http.post(
        Uri.parse(
          'https://generativelanguage.googleapis.com/v1/$modelName:generateContent?key=$_geminiApiKey',
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': fullPrompt},
              ],
            },
          ],
          'generationConfig': {
            'temperature': 0.2,
            'topK': 40,
            'topP': 0.95,
            'maxOutputTokens': 2048,
          },
        }),
      );

      if (response.statusCode != 200) {
        // Intentar parsear mensaje de error si viene en JSON
        try {
          final errorBody = jsonDecode(response.body);
          final errorMessage = errorBody['error']?['message'] ?? response.body;
          throw Exception(
            'Error en Gemini API (${response.statusCode}): $errorMessage',
          );
        } catch (_) {
          throw Exception('Error inesperado en Gemini API: ${response.body}');
        }
      }

      final data = jsonDecode(response.body);

      final content = _extractTextFromResponse(data);

      // Logs útiles para debug (quítalos en producción)
      print('=== RESPUESTA CRUDA DE GEMINI ===');
      print(content);
      print('=== FIN RESPUESTA ===');

      // Extraer JSON dentro del contenido
      final jsonText = _extractJson(content);

      final decoded = jsonDecode(jsonText) as Map<String, dynamic>;

      // Si viene error desde el modelo
      if (decoded.containsKey('error')) {
        final err = decoded['error'];
        return RouteAIResponse(message: err.toString(), route: null);
      }

      // Validar coordenadas dentro de Tuxtla
      final routeMap = decoded['route'] as Map<String, dynamic>?;
      if (routeMap == null) {
        return RouteAIResponse(
          message: decoded['message'] ?? 'Sin ruta',
          route: null,
        );
      }

      // Validate origin & destination coordinates
      final origin = routeMap['origin'] as Map<String, dynamic>?;
      final destination = routeMap['destination'] as Map<String, dynamic>?;

      if (!_isWithinTuxtla(origin) || !_isWithinTuxtla(destination)) {
        return RouteAIResponse(
          message: 'La ruta generada está fuera de Tuxtla Gutiérrez.',
          route: null,
        );
      }

      final routeData = RouteData.fromJson(routeMap);
      return RouteAIResponse(
        message: decoded['message'] ?? 'Ruta generada',
        route: routeData,
      );
    } catch (e) {
      print('Error general al generar ruta: $e');
      rethrow;
    }
  }

  String _extractTextFromResponse(Map<String, dynamic> data) {
    // La estructura típica contiene candidates -> content -> parts -> text
    try {
      final candidates = data['candidates'] as List<dynamic>?;
      if (candidates != null && candidates.isNotEmpty) {
        final first = candidates[0] as Map<String, dynamic>;
        final content = first['content'] as Map<String, dynamic>?;
        final parts = content?['parts'] as List<dynamic>?;
        if (parts != null && parts.isNotEmpty) {
          final part0 = parts[0] as Map<String, dynamic>?;
          final text = part0?['text'] as String?;
          if (text != null) return text;
        }
      }

      // Fallback a 'outputs' u otros campos si cambió la forma
      if (data.containsKey('output')) {
        return data['output'].toString();
      }

      return jsonEncode(data);
    } catch (e) {
      print('No pude extraer texto de la respuesta: $e');
      return jsonEncode(data);
    }
  }

  String _extractJson(String text) {
    // remover bloques de código y triple backticks
    var t = text.replaceAll('```json', '').replaceAll('```', '');

    // buscar primer { y último }
    final start = t.indexOf('{');
    final end = t.lastIndexOf('}');

    if (start == -1 || end == -1 || end <= start) {
      throw FormatException('No se encontró JSON válido en la respuesta.');
    }

    final jsonText = t.substring(start, end + 1).trim();
    return jsonText;
  }

  bool _isWithinTuxtla(Map<String, dynamic>? coord) {
    if (coord == null) return false;
    try {
      final lat = (coord['lat'] ?? 0).toDouble();
      final lng = (coord['lng'] ?? 0).toDouble();
      return lat >= _minLat &&
          lat <= _maxLat &&
          lng >= _minLng &&
          lng <= _maxLng;
    } catch (_) {
      return false;
    }
  }
}

/// Modelo de respuesta de la IA
class RouteAIResponse {
  final String message;
  final RouteData? route;

  RouteAIResponse({required this.message, this.route});

  factory RouteAIResponse.fromJson(Map<String, dynamic> json) {
    return RouteAIResponse(
      message: json['message'] ?? 'No se recibió mensaje.',
      route: json['route'] != null ? RouteData.fromJson(json['route']) : null,
    );
  }
}

/// Datos de la ruta generada por la IA
class RouteData {
  final String name;
  final LatLng origin;
  final LatLng destination;
  final List<LatLng> waypoints;
  final String distance;
  final String elevation;
  final String terrain;
  final String difficulty;
  final List<String> warnings;

  RouteData({
    required this.name,
    required this.origin,
    required this.destination,
    required this.waypoints,
    required this.distance,
    required this.elevation,
    required this.terrain,
    required this.difficulty,
    required this.warnings,
  });

  factory RouteData.fromJson(Map<String, dynamic> json) {
    List<LatLng> parseWaypoints(dynamic maybeList) {
      if (maybeList is List) {
        return maybeList.map((w) {
          final lat = (w['lat'] ?? 0.0).toDouble();
          final lng = (w['lng'] ?? 0.0).toDouble();
          return LatLng(lat, lng);
        }).toList();
      }
      return [];
    }

    double _toDouble(dynamic v) {
      if (v == null) return 0.0;
      if (v is double) return v;
      if (v is int) return v.toDouble();
      if (v is String) return double.tryParse(v) ?? 0.0;
      return 0.0;
    }

    final originMap = json['origin'] as Map<String, dynamic>? ?? {};
    final destMap = json['destination'] as Map<String, dynamic>? ?? {};

    return RouteData(
      name: json['name'] ?? 'Ruta sin nombre',
      origin: LatLng(_toDouble(originMap['lat']), _toDouble(originMap['lng'])),
      destination: LatLng(_toDouble(destMap['lat']), _toDouble(destMap['lng'])),
      waypoints: parseWaypoints(json['waypoints']),
      distance: json['distance'] ?? 'Distancia no especificada',
      elevation: json['elevation'] ?? 'Elevación no especificada',
      terrain: json['terrain'] ?? 'Terreno no especificado',
      difficulty: json['difficulty'] ?? 'Dificultad no especificada',
      warnings: (json['warnings'] as List?)?.cast<String>() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'origin': {'lat': origin.latitude, 'lng': origin.longitude},
      'destination': {
        'lat': destination.latitude,
        'lng': destination.longitude,
      },
      'waypoints': waypoints
          .map((w) => {'lat': w.latitude, 'lng': w.longitude})
          .toList(),
      'distance': distance,
      'elevation': elevation,
      'terrain': terrain,
      'difficulty': difficulty,
      'warnings': warnings,
    };
  }
}
