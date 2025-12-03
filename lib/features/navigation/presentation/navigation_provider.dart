import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import '../data/route_api_service.dart';
import '../domain/route_model.dart';

class NavigationProvider extends ChangeNotifier {
  final RouteApiService _apiService = RouteApiService();

  // Estado de la navegación
  bool _isActive = false;
  bool _isPaused = false;
  bool _showWarning = false;

  // Métricas en tiempo real
  double _currentSpeed = 0.0;
  double _distance = 0.0;
  String _time = '00:00:00';
  int _elevation = 0;

  // Mapa y ubicación
  GoogleMapController? _mapController;
  LatLng? _currentLocation;
  LatLng? _destination;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  List<LatLng> _routePoints = [];

  // Ruta guardada
  RouteModel? _currentRoute;
  List<RouteModel> _userRoutes = [];

  // Estado de carga
  bool _isLoading = false;
  String? _errorMessage;

  // Timer para tracking
  DateTime? _startTime;
  LatLng? _lastPosition;

  // Getters
  bool get isActive => _isActive;
  bool get isPaused => _isPaused;
  bool get showWarning => _showWarning;
  double get currentSpeed => _currentSpeed;
  double get distance => _distance;
  String get time => _time;
  int get elevation => _elevation;
  GoogleMapController? get mapController => _mapController;
  LatLng? get currentLocation => _currentLocation;
  LatLng? get destination => _destination;
  Set<Marker> get markers => _markers;
  Set<Polyline> get polylines => _polylines;
  RouteModel? get currentRoute => _currentRoute;
  List<RouteModel> get userRoutes => _userRoutes;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Inicializar el mapa
  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    notifyListeners();
  }

  // Obtener ubicación actual
  Future<void> getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _errorMessage = 'Permisos de ubicación denegados';
          notifyListeners();
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      _currentLocation = LatLng(position.latitude, position.longitude);
      _elevation = position.altitude.toInt();

      // Actualizar marcador de ubicación actual
      _updateCurrentLocationMarker();

      // Mover cámara a ubicación actual
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(_currentLocation!, 15),
      );

      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error al obtener ubicación: $e';
      notifyListeners();
    }
  }

  // Establecer destino y calcular ruta
  Future<void> setDestination(LatLng destination, {String? destinationName}) async {
    _destination = destination;
    _isLoading = true;
    notifyListeners();

    try {
      if (_currentLocation == null) {
        await getCurrentLocation();
      }

      if (_currentLocation != null) {
        await _calculateRoute(_currentLocation!, destination);

        // Agregar marcador de destino
        _markers.add(
          Marker(
            markerId: const MarkerId('destination'),
            position: destination,
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            infoWindow: InfoWindow(
              title: 'Destino',
              snippet: destinationName ?? 'Punto de llegada',
            ),
          ),
        );
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error al calcular ruta: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Calcular ruta usando Google Directions API
  Future<void> _calculateRoute(LatLng origin, LatLng destination) async {
    try {
      PolylinePoints polylinePoints = PolylinePoints();

      // API KEY de Google Maps
      const String googleAPIKey = 'AIzaSyDEH8aKGH5WtDunUAyyBs_XrggHi2kd6Hc';

      // Nueva API de flutter_polyline_points (versión 2.x)
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        request: PolylineRequest(
          origin: PointLatLng(origin.latitude, origin.longitude),
          destination: PointLatLng(destination.latitude, destination.longitude),
          mode: TravelMode.bicycling, // Opciones: driving, walking, bicycling, transit
        ),
        googleApiKey: googleAPIKey,
      );

      if (result.points.isNotEmpty) {
        _routePoints = result.points
            .map((point) => LatLng(point.latitude, point.longitude))
            .toList();

        // Crear polyline
        _polylines.clear(); // Limpiar polylines anteriores
        _polylines.add(
          Polyline(
            polylineId: const PolylineId('route'),
            points: _routePoints,
            color: Colors.blue,
            width: 5,
            patterns: [PatternItem.dash(20), PatternItem.gap(10)],
          ),
        );

        // Calcular distancia aproximada
        _calculateDistance();
      } else if (result.errorMessage != null) {
        _errorMessage = 'Error de Directions API: ${result.errorMessage}';
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Error al calcular la ruta: $e';
      notifyListeners();
    }
  }

  // Calcular distancia total de la ruta
  void _calculateDistance() {
    double totalDistance = 0.0;
    for (int i = 0; i < _routePoints.length - 1; i++) {
      totalDistance += Geolocator.distanceBetween(
        _routePoints[i].latitude,
        _routePoints[i].longitude,
        _routePoints[i + 1].latitude,
        _routePoints[i + 1].longitude,
      );
    }
    _distance = totalDistance / 1000; // Convertir a km
  }

  // Actualizar marcador de ubicación actual
  void _updateCurrentLocationMarker() {
    if (_currentLocation == null) return;

    _markers.removeWhere((m) => m.markerId.value == 'current');
    _markers.add(
      Marker(
        markerId: const MarkerId('current'),
        position: _currentLocation!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: const InfoWindow(title: 'Mi ubicación'),
      ),
    );
  }

  // Iniciar navegación
  Future<void> startNavigation({String? routeName, int? eventId, int? userId}) async {
    _isActive = true;
    _startTime = DateTime.now();
    _lastPosition = _currentLocation;
    notifyListeners();

    // Simular advertencia después de 3 segundos
    Future.delayed(const Duration(seconds: 3), () {
      if (_isActive) {
        _showWarning = true;
        notifyListeners();

        Future.delayed(const Duration(seconds: 5), () {
          _showWarning = false;
          notifyListeners();
        });
      }
    });

    // Iniciar seguimiento de ubicación
    _startLocationTracking();
  }

  // Tracking de ubicación en tiempo real
  void _startLocationTracking() {
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5, // Actualizar cada 5 metros
      ),
    ).listen((Position position) {
      if (!_isActive || _isPaused) return;

      LatLng newLocation = LatLng(position.latitude, position.longitude);

      // Actualizar velocidad
      _currentSpeed = position.speed * 3.6; // m/s a km/h

      // Actualizar distancia
      if (_lastPosition != null) {
        double increment = Geolocator.distanceBetween(
          _lastPosition!.latitude,
          _lastPosition!.longitude,
          newLocation.latitude,
          newLocation.longitude,
        ) / 1000;
        _distance += increment;
      }

      // Actualizar tiempo
      if (_startTime != null) {
        Duration elapsed = DateTime.now().difference(_startTime!);
        _time = _formatDuration(elapsed);
      }

      // Actualizar elevación
      _elevation = position.altitude.toInt();

      _currentLocation = newLocation;
      _lastPosition = newLocation;
      _updateCurrentLocationMarker();

      notifyListeners();
    });
  }

  // Formatear duración
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  // Pausar/reanudar navegación
  void togglePause() {
    _isPaused = !_isPaused;
    notifyListeners();
  }

  // Finalizar navegación y guardar ruta
  Future<void> stopNavigation({
    required String routeName,
    String? description,
    int? eventId,
    int? userId,
  }) async {
    _isActive = false;
    _isPaused = false;

    // Codificar polyline
    String encodedPolyline = _encodePolyline(_routePoints);

    // Crear objeto de ruta
    RouteModel route = RouteModel(
      idEvento: eventId,
      idUsuario: userId,
      nombre: routeName,
      descripcion: description,
      origen: 'Ubicación inicial', // TODO: Geocodificar
      destino: 'Destino', // TODO: Geocodificar
      distancia: _distance,
      duracion: _startTime != null
          ? DateTime.now().difference(_startTime!).inMinutes.toDouble()
          : 0,
      polyline: encodedPolyline,
      latInicio: _routePoints.isNotEmpty ? _routePoints.first.latitude.toString() : null,
      lngInicio: _routePoints.isNotEmpty ? _routePoints.first.longitude.toString() : null,
      latFin: _routePoints.isNotEmpty ? _routePoints.last.latitude.toString() : null,
      lngFin: _routePoints.isNotEmpty ? _routePoints.last.longitude.toString() : null,
    );

    // Guardar en la API
    await saveRoute(route);

    // Reset
    _startTime = null;
    _lastPosition = null;

    notifyListeners();
  }

  // Codificar polyline (implementación simple)
  String _encodePolyline(List<LatLng> points) {
    // Aquí puedes usar el paquete google_polyline_algorithm
    // o implementar el algoritmo de codificación de Google
    // Por ahora retornamos un string con los puntos
    return points.map((p) => '${p.latitude},${p.longitude}').join('|');
  }

  // Guardar ruta en la API
  Future<void> saveRoute(RouteModel route) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final savedRoute = await _apiService.createRoute(route);
      _currentRoute = savedRoute;
      _userRoutes.add(savedRoute);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Cargar rutas del usuario
  Future<void> loadUserRoutes(int userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _userRoutes = await _apiService.getUserRoutes(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Limpiar error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}