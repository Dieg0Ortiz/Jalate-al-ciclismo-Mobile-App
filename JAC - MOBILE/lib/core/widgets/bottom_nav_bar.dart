import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).matchedLocation;

    int currentIndex = 0;
    if (currentLocation.startsWith('/home')) {
      currentIndex = 0;
    } else if (currentLocation.startsWith('/planner')) {
      currentIndex = 1;
    } else if (currentLocation.startsWith('/navigation')) {
      currentIndex = 2;
    } else if (currentLocation.startsWith('/activity')) {
      currentIndex = 3;
    } else if (currentLocation.startsWith('/profile')) {
      currentIndex = 4;
    }

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        switch (index) {
          case 0:
            context.go('/home');
            break;
          case 1:
            context.go('/planner');
            break;
          case 2:
            context.go('/navigation');
            break;
          case 3:
            context.go('/activity');
            break;
          case 4:
            context.go('/profile');
            break;
        }
      },
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.smart_toy_outlined),
          activeIcon: Icon(Icons.smart_toy),
          label: 'Planear',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.navigation_outlined),
          activeIcon: Icon(Icons.navigation),
          label: 'Grabar',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.directions_bike_outlined),
          activeIcon: Icon(Icons.directions_bike),
          label: 'Actividades',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Perfil',
        ),
      ],
    );
  }
}
