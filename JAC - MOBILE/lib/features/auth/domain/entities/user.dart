import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    this.location,
    this.birthDate,
  });

  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final String? location;
  final String? birthDate;

  @override
  List<Object?> get props => [id, name, email, photoUrl, location, birthDate];
}

