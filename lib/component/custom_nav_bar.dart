import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:provider/provider.dart';
import 'package:netshift/theme/theme_provider.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabChange;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = themeProvider.theme;
    final isLightTheme = theme.brightness == Brightness.light;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: isLightTheme
              ? Colors.white.withOpacity(0.95)
              : Colors.grey.shade900.withOpacity(0.9),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: isLightTheme
                  ? Colors.grey.shade300
                  : Colors.black.withOpacity(0.5),
              blurRadius: 8,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
          child: SalomonBottomBar(
            currentIndex: selectedIndex,
            onTap: onTabChange,
            selectedItemColor: theme.bottomNavigationBarTheme.selectedItemColor,
            unselectedItemColor:
                theme.bottomNavigationBarTheme.unselectedItemColor,
            items: [
              SalomonBottomBarItem(
                icon: const Icon(Icons.home_outlined),
                title: const Text("Home"),
                selectedColor: Colors.blueAccent,
                unselectedColor:
                    theme.bottomNavigationBarTheme.unselectedItemColor,
              ),
              SalomonBottomBarItem(
                icon: const Icon(Icons.dns_outlined),
                title: const Text("DNS"),
                selectedColor: Colors.greenAccent,
                unselectedColor:
                    theme.bottomNavigationBarTheme.unselectedItemColor,
              ),
              SalomonBottomBarItem(
                icon: const Icon(Icons.speed_outlined),
                title: const Text("Speed"),
                selectedColor: Colors.orangeAccent,
                unselectedColor:
                    theme.bottomNavigationBarTheme.unselectedItemColor,
              ),
              SalomonBottomBarItem(
                icon: const Icon(Icons.settings_outlined),
                title: const Text("Settings"),
                selectedColor: Colors.purpleAccent,
                unselectedColor:
                    theme.bottomNavigationBarTheme.unselectedItemColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
