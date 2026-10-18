import 'package:docket/features/documents/screens/documents_screen.dart';
import 'package:docket/features/home/screens/home_screen.dart';
import 'package:docket/features/settings/screens/settings_screen.dart';
import 'package:docket/shared/glass_nav.dart';
import 'package:flutter/material.dart';

class AppShellScope extends InheritedWidget {
  const AppShellScope({super.key, required this.goToTab, required super.child});

  final void Function(int index) goToTab;

  static AppShellScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppShellScope>();

  @override
  bool updateShouldNotify(AppShellScope oldWidget) => false;
}

class AppShell extends StatefulWidget {
  const AppShell({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  static const List<Widget> _screens = [
    HomeScreen(),
    DocumentsScreen(),
    SettingsScreen(),
  ];

  late int _index = widget.initialIndex;
  late final Set<int> _built = {widget.initialIndex};

  void _onSelect(int index) {
    if (index == _index) return;
    setState(() {
      _index = index;
      _built.add(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          AppShellScope(
            goToTab: _onSelect,
            child: IndexedStack(
              index: _index,
              children: [
                for (var i = 0; i < _screens.length; i++)
                  _built.contains(i) ? _screens[i] : const SizedBox.shrink(),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: GlassNav(currentIndex: _index, onSelect: _onSelect),
          ),
        ],
      ),
    );
  }
}
