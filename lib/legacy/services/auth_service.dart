@Deprecated('Use features/auth/data/datasources/auth_remote_datasource_impl.dart instead. '
    'This file will be removed in v2.0.0')
class AuthService {
  // TODO: Legacy implementation - will be removed in v2.0.0
  // This file is deprecated and will be removed in v2.0.0
  // Use the new Clean Architecture implementation in features/auth/
  
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();
}