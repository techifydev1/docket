import 'package:docket/features/documents/screens/documents_screen.dart';
import 'package:docket/features/home/screens/home_screen.dart';
import 'package:docket/features/settings/screens/settings_screen.dart';
import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  const BottomNav({super.key, required this.currentIndex});

  static const List<NavigationDestination> destinations = [
    NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: "Home",
    ),
    NavigationDestination(
      icon: Icon(Icons.folder_outlined),
      selectedIcon: Icon(Icons.folder),
      label: "Documents",
    ),
    NavigationDestination(
      icon: Icon(Icons.settings_outlined),
      selectedIcon: Icon(Icons.settings),
      label: "Settings",
    ),
  ];

  static Widget screenFor(int index) {
    return switch (index) {
      0 => const HomeScreen(),
      1 => const DocumentsScreen(),
      _ => const SettingsScreen(),
    };
  }

  void _onDestinationSelected(BuildContext context, int index) {
    if (index == currentIndex) return;
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => screenFor(index)));
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: (index) => _onDestinationSelected(context, index),
      destinations: destinations,
    );
  }
}
