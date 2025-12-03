class AppConstants {
  AppConstants._();

  static const String appName = 'Jalate al ciclismo Mobile App';
  static const String appVersion = '1.0.0';
  static const String appTagline = 'Tu copiloto de IA en la ruta';

  // API - Comentado hasta que tengamos backend
  // static const String baseUrl = 'https://api.jalatealciclismo.com';
  // static const Duration connectionTimeout = Duration(seconds: 30);
  // static const Duration receiveTimeout = Duration(seconds: 30);

  // Storage Keys
  static const String keyAuthToken = 'auth_token';
  static const String keyUserId = 'user_id';
  static const String keyUserEmail = 'user_email';
  static const String keyUserName = 'user_name';
  static const String keyIsLoggedIn = 'is_logged_in';

  // Routes
  static const String routeLogin = '/login';
  static const String routeRegister = '/register';
  static const String routeHome = '/home';
  static const String routePlanner = '/planner';
  static const String routeNavigation = '/navigation';
  static const String routeActivity = '/activity';
  static const String routeActivityDetail = '/activity/:id';
  static const String routeProfile = '/profile';
  static const String routeEditProfile = '/profile/edit';
  static const String routeMyBikes = '/profile/bikes';
  static const String routeMySensors = '/profile/sensors';
  static const String routeOfflineMaps = '/profile/maps';
  static const String routeNotifications = '/profile/notifications';
  static const String routeNavigationSettings = '/profile/navigation-settings';
  static const String routeHelpSupport = '/profile/help';
  static const String routeConnections = '/profile/connections/:type';
  static const String routeTerms = '/profile/terms';
  static const String routePrivacy = '/profile/privacy';
}