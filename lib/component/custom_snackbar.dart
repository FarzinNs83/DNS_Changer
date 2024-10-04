import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:netshift/theme/theme_provider.dart';
import 'package:netshift/component/animated_snackbar.dart';

void showCustomSnackBar(BuildContext context, String message) {
  final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
  final theme = themeProvider.theme;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: AnimatedSnackBar(
        message: message,
        backgroundColor: theme.snackBarTheme.backgroundColor ?? Colors.black,
      ),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}
