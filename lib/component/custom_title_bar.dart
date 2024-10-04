import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:netshift/theme/theme_provider.dart';

class CustomTitleBar extends StatelessWidget {
  const CustomTitleBar({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = themeProvider.theme;

    return WindowTitleBarBox(
      child: Container(
        color: theme.brightness == Brightness.dark
            ? const Color(0xFF1B1B1F) 
            : theme.appBarTheme.backgroundColor, 
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: MoveWindow(),
            ),
            const Row(
              children: [
                MinimizeWindowButton(),
                CloseWindowButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MinimizeWindowButton extends StatelessWidget {
  const MinimizeWindowButton({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = themeProvider.theme;

    return IconButton(
      icon: Icon(Icons.remove,
          color: theme.brightness == Brightness.dark
              ? Colors.greenAccent
              : Colors.white),
      onPressed: () {
        appWindow.minimize();
      },
      tooltip: 'Minimize',
    );
  }
}

class CloseWindowButton extends StatelessWidget {
  const CloseWindowButton({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = themeProvider.theme;

    return IconButton(
      icon: Icon(Icons.close,
          color: theme.brightness == Brightness.dark
              ? Colors.greenAccent
              : Colors.white),
      onPressed: () {
        appWindow.close();
      },
      tooltip: 'Close',
    );
  }
}
