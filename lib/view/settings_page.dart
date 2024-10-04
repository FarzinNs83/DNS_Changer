// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dns_changer/theme/theme_provider.dart';
import 'package:http/http.dart' as http; 
import 'dart:convert'; 
import 'package:url_launcher/url_launcher.dart'; 

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = themeProvider.theme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Settings'),
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          _buildSettingTile(
            context,
            title: 'Dark Mode',
            icon: theme.brightness == Brightness.dark ? Icons.nightlight_round : Icons.wb_sunny,
            iconColor: theme.brightness == Brightness.dark ? Colors.yellow : Colors.orange,
            onTap: () {
              themeProvider.toggleTheme();
            },
          ),
          _buildSettingTile(
            context,
            title: 'Version Info',
            subtitle: '1.0.3',
            icon: Icons.info_outline,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('App version 1.0.3')),
              );
            },
          ),
          _buildSettingTile(
            context,
            title: 'Check for Updates', 
            icon: Icons.update,
            onTap: () async {
              await _checkForUpdate(context);
            },
          ),
          _buildSettingTile(
            context,
            title: 'Contact Us',
            icon: Icons.email_outlined,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Contacts will be available soon.')),
              );
            },
          ),
          _buildSettingTile(
            context,
            title: 'Privacy Policy',
            icon: Icons.lock_outline,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Privacy policy link will be available soon.')),
              );
            },
          ),
          _buildSettingTile(
            context,
            title: 'Terms of Service',
            icon: Icons.description_outlined,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Terms of service link will be available soon.')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile(
    BuildContext context, {
    required String title,
    String? subtitle,
    required IconData icon,
    Color? iconColor,
    required VoidCallback onTap,
  }) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = themeProvider.theme;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: theme.textTheme.bodyLarge?.color,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: theme.textTheme.titleMedium?.color,
                ),
              )
            : null,
        trailing: Icon(
          icon,
          color: iconColor ?? theme.iconTheme.color,
        ),
        onTap: onTap,
      ),
    );
  }

  Future<void> _checkForUpdate(BuildContext context) async {
    const String repoOwner = 'FarzinNs83'; 
    const String repoName = 'NetShift'; 
    const String currentVersion = 'V.1.0.3';

    const url = 'https://api.github.com/repos/$repoOwner/$repoName/releases/latest';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final latestRelease = json.decode(response.body);
      final latestVersion = latestRelease['tag_name'].replaceAll('v', ''); 
      final releaseUrl = latestRelease['html_url'];

      if (isNewVersionAvailable(currentVersion, latestVersion)) {
        showUpdateDialog(context, currentVersion, latestVersion, releaseUrl);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("App is Up-To-Date")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error checking for the update")),
      );
    }
  }

  bool isNewVersionAvailable(String current, String latest) {
    return latest.compareTo(current) > 0;
  }

  void showUpdateDialog(BuildContext context, String currentVersion, String latestVersion, String releaseUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('New Update : $latestVersion'),
          content: Text('Current Version : $currentVersion\n New Version : $latestVersion\n Do you want to download the new update ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final Uri uri = Uri.parse(releaseUrl);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri);
                } else {
                  throw 'Could not launch $releaseUrl';
                }
              },
              child: const Text('Download'),
              
            ),
          ],
        );
      },
    );
  }
}
