import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Perfil',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.supervised_user_circle),
          label: 'Cliente',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Configuración',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Notificaciones',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.help),
          label: 'Ayuda',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.info),
          label: 'Acerca de',
        ),
      ],
    );
  }
}