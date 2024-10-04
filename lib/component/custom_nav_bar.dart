import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
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

    return Container(
      height: 70,
      decoration: BoxDecoration(
        gradient: theme.brightness == Brightness.light
            ? LinearGradient(
                colors: [Colors.blue.shade100, Colors.blue.shade300],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : const LinearGradient(
                colors: [Color(0xFF1B1B1F), Color(0xFF2A2A2D)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.bottomNavigationBarTheme.selectedItemColor!
                .withOpacity(0.3),
            blurRadius: 12,
            spreadRadius: 2,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: GNav(
            rippleColor: theme.bottomNavigationBarTheme.selectedItemColor!
                .withOpacity(0.2),
            hoverColor: theme.bottomNavigationBarTheme.selectedItemColor!
                .withOpacity(0.1),
            gap: 10,
            color: theme.bottomNavigationBarTheme.unselectedItemColor!,
            activeColor: theme.bottomNavigationBarTheme.selectedItemColor!,
            iconSize: 28,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            duration: const Duration(milliseconds: 300),
            tabBackgroundColor: theme
                .bottomNavigationBarTheme.selectedItemColor!
                .withOpacity(0.2),
            backgroundColor: Colors.transparent,
            tabs: [
              GButton(
                icon: Icons.home,
                text: 'Home',
                iconColor: theme.bottomNavigationBarTheme.unselectedItemColor!,
              ),
              GButton(
                icon: Icons.dns,
                text: 'DNS Selection',
                iconColor: theme.bottomNavigationBarTheme.unselectedItemColor!,
              ),
              GButton(
                icon: Icons.speed,
                text: 'Fastest DNS',
                iconColor: theme.bottomNavigationBarTheme.unselectedItemColor!,
              ),
              GButton(
                icon: Icons.settings,
                text: 'Settings',
                iconColor: theme.bottomNavigationBarTheme.unselectedItemColor!,
              ),
            ],
            selectedIndex: selectedIndex,
            onTabChange: onTabChange,
          ),
        ),
      ),
    );
  }
}
