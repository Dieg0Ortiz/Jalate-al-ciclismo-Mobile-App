class RouteModel {
  final int? idEvento;
  final int? idUsuario;
  final String nombre;
  final String? descripcion;
  final String? origen;
  final String? destino;
  final double? distancia;
  final double? duracion;
  final String? polyline;
  final String? urlMapa;
  final String? latInicio;
  final String? lngInicio;
  final String? latFin;
  final String? lngFin;

  RouteModel({
    this.idEvento,
    this.idUsuario,
    required this.nombre,
    this.descripcion,
    this.origen,
    this.destino,
    this.distancia,
    this.duracion,
    this.polyline,
    this.urlMapa,
    this.latInicio,
    this.lngInicio,
    this.latFin,
    this.lngFin,
  });

  // Convertir desde JSON (respuesta de la API)
  factory RouteModel.fromJson(Map<String, dynamic> json) {
    return RouteModel(
      idEvento: json['id_evento'],
      idUsuario: json['id_usuario'],
      nombre: json['nombre'] ?? '',
      descripcion: json['descripcion'],
      origen: json['origen'],
      destino: json['destino'],
      distancia: json['distancia']?.toDouble(),
      duracion: json['duracion']?.toDouble(),
      polyline: json['polyline'],
      urlMapa: json['url_mapa'],
      latInicio: json['lat_inicio'],
      lngInicio: json['lng_inicio'],
      latFin: json['lat_fin'],
      lngFin: json['lng_fin'],
    );
  }

  // Convertir a JSON (para enviar a la API)
  Map<String, dynamic> toJson() {
    return {
      if (idEvento != null) 'id_evento': idEvento,
      if (idUsuario != null) 'id_usuario': idUsuario,
      'nombre': nombre,
      if (descripcion != null) 'descripcion': descripcion,
      if (origen != null) 'origen': origen,
      if (destino != null) 'destino': destino,
      if (distancia != null) 'distancia': distancia,
      if (duracion != null) 'duracion': duracion,
      if (polyline != null) 'polyline': polyline,
      if (urlMapa != null) 'url_mapa': urlMapa,
      if (latInicio != null) 'lat_inicio': latInicio,
      if (lngInicio != null) 'lng_inicio': lngInicio,
      if (latFin != null) 'lat_fin': latFin,
      if (lngFin != null) 'lng_fin': lngFin,
    };
  }

  RouteModel copyWith({
    int? idEvento,
    int? idUsuario,
    String? nombre,
    String? descripcion,
    String? origen,
    String? destino,
    double? distancia,
    double? duracion,
    String? polyline,
    String? urlMapa,
    String? latInicio,
    String? lngInicio,
    String? latFin,
    String? lngFin,
  }) {
    return RouteModel(
      idEvento: idEvento ?? this.idEvento,
      idUsuario: idUsuario ?? this.idUsuario,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      origen: origen ?? this.origen,
      destino: destino ?? this.destino,
      distancia: distancia ?? this.distancia,
      duracion: duracion ?? this.duracion,
      polyline: polyline ?? this.polyline,
      urlMapa: urlMapa ?? this.urlMapa,
      latInicio: latInicio ?? this.latInicio,
      lngInicio: lngInicio ?? this.lngInicio,
      latFin: latFin ?? this.latFin,
      lngFin: lngFin ?? this.lngFin,
    );
  }
}