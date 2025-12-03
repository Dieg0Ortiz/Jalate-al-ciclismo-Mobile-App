import 'package:equatable/equatable.dart';
import '../../../auth/domain/entities/user.dart';

class HomeData extends Equatable {
  final User user;
  final String welcomeMessage;
  final List<dynamic>
  suggestedRoutes; // Using dynamic for now as Route entity might not exist or be complex

  const HomeData({
    required this.user,
    required this.welcomeMessage,
    required this.suggestedRoutes,
  });

  @override
  List<Object?> get props => [user, welcomeMessage, suggestedRoutes];
}
