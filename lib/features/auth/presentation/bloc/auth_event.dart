part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginRequested extends AuthEvent {
  const LoginRequested({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

class RegisterRequested extends AuthEvent {
  const RegisterRequested({
    required this.name,
    required this.lastNameP,
    required this.lastNameM,
    required this.email,
    required this.password,
  });

  final String name;
  final String lastNameP;
  final String lastNameM;
  final String email;
  final String password;

  @override
  List<Object?> get props => [name, email, password];
}

class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}

class CheckAuthStatus extends AuthEvent {
  const CheckAuthStatus();
}

class UpdateProfileRequested extends AuthEvent {
  const UpdateProfileRequested({
    required this.id,
    this.name,
    this.email,
    this.location,
    this.birthDate,
    this.profileImage,
  });

  final String id;
  final String? name;
  final String? email;
  final String? location;
  final String? birthDate;
  final Uint8List? profileImage;

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    location,
    birthDate,
    profileImage,
  ];
}
