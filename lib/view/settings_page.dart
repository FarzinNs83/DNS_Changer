// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:netshift/theme/theme_provider.dart';
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
            icon: theme.brightness == Brightness.dark
                ? Icons.nightlight_round
                : Icons.wb_sunny,
            iconColor: theme.brightness == Brightness.dark
                ? Colors.yellow
                : Colors.orange,
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
              contactUs(context);
            },
          ),
          _buildSettingTile(
            context,
            title: 'Privacy Policy',
            icon: Icons.lock_outline,
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Privacy Policy'),
                    content: const SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Last updated: October 6, 2024\n',
                            style: TextStyle(
                                fontSize: 14, fontStyle: FontStyle.italic),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '1. Introduction',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'NetShift ("we", "our", or "us") respects your privacy and is committed to protecting your personal data. '
                            'This Privacy Policy outlines how we collect, use, and safeguard your information when you use our application.\n',
                          ),
                          SizedBox(height: 16),
                          Text(
                            '2. Information We Collect',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'We do not collect any personal data directly through NetShift. However, third-party services used in the application '
                            'may collect certain types of information as per their privacy policies.\n',
                          ),
                          SizedBox(height: 16),
                          Text(
                            '3. Use of Information',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Any data collected by third-party services will be used in accordance with their respective privacy policies. '
                            'NetShift itself does not collect or use your personal information for any marketing or tracking purposes.\n',
                          ),
                          SizedBox(height: 16),
                          Text(
                            '4. Data Security',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'We take reasonable measures to protect your data from unauthorized access or disclosure. However, we cannot guarantee '
                            'absolute security as no method of transmission over the Internet is completely secure.\n',
                          ),
                          SizedBox(height: 16),
                          Text(
                            '5. Third-Party Links',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Our application may contain links to third-party websites or services. We are not responsible for the privacy practices '
                            'or content of these third-party services. Please review their privacy policies before providing them with any personal information.\n',
                          ),
                          SizedBox(height: 16),
                          Text(
                            '6. Changes to Privacy Policy',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'We may update this Privacy Policy from time to time. Any changes will be posted in the application, and your continued use '
                            'of the application signifies your acceptance of the updated terms.\n',
                          ),
                          SizedBox(height: 16),
                          Text(
                            '7. Contact Us',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'If you have any questions or concerns about this Privacy Policy, please contact us at: farzinns83@gmail.com\n',
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Close'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          _buildSettingTile(
            context,
            title: 'Terms of Service',
            icon: Icons.description_outlined,
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Terms of Service'),
                    content: const SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Last updated: October 6, 2024\n',
                            style: TextStyle(
                                fontSize: 14, fontStyle: FontStyle.italic),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '1. Introduction',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Welcome to NetShift! By using this application, you agree to comply with '
                            'and be bound by the following terms and conditions. If you disagree with any part of these terms, '
                            'please do not use our application.\n',
                          ),
                          SizedBox(height: 16),
                          Text(
                            '2. Use of the Application',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'NetShift is a DNS changer application that helps improve your browsing experience by allowing you to change your DNS. '
                            'By using NetShift, you agree to use the app only for lawful purposes and not to misuse the service in any way.\n',
                          ),
                          SizedBox(height: 16),
                          Text(
                            '3. Privacy Policy',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'We take your privacy seriously. Please review our Privacy Policy to understand how we collect, use, and protect '
                            'your personal data while using the application.\n',
                          ),
                          SizedBox(height: 16),
                          Text(
                            '4. Intellectual Property',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'All intellectual property rights in the content of this application, including but not limited to logos, images, and code, '
                            'are owned by NetShift. Unauthorized use of these materials is prohibited.\n',
                          ),
                          SizedBox(height: 16),
                          Text(
                            '5. Termination',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'We reserve the right to terminate or suspend your access to the application at any time for violating these terms, '
                            'or for any illegal activity or misuse of the application.\n',
                          ),
                          SizedBox(height: 16),
                          Text(
                            '6. Limitation of Liability',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'NetShift and its developers are not liable for any damages or data loss resulting from the use of this application. '
                            'Use NetShift at your own risk.\n',
                          ),
                          SizedBox(height: 16),
                          Text(
                            '7. Changes to the Terms',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'We may update these Terms of Service from time to time. Any changes will be posted in the application, '
                            'and continued use of the application means you accept the updated terms.\n',
                          ),
                          SizedBox(height: 16),
                          Text(
                            '8. Contact Us',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'If you have any questions or concerns regarding these terms, please contact us at: farzinns83@gmail.com\n',
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Close'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.favorite_border_outlined,
                color: Theme.of(context).iconTheme.color,
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                "Made By Feri",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ],
          )
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
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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

    const url =
        'https://api.github.com/repos/$repoOwner/$repoName/releases/latest';
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

  void showUpdateDialog(BuildContext context, String currentVersion,
      String latestVersion, String releaseUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('New Update : $latestVersion'),
          content: Text(
              'Current Version : $currentVersion\n New Version : $latestVersion\n Do you want to download the new update ?'),
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

  mylaunchUrl(String url) async {
    var uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint("Could not launch");
    }
  }

  Future<dynamic> contactUs(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.25,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(24),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    child: IconButton(
                      splashRadius: 6,
                      icon: const FaIcon(FontAwesomeIcons.telegram),
                      iconSize: 42,
                      color: Theme.of(context).colorScheme.primary,
                      onPressed: () {
                        mylaunchUrl('https://t.me/flutterstuff');
                      },
                    ),
                  ),
                  Text("Telegram",
                      style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
              // const SizedBox(width: 16),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    child: IconButton(
                      splashRadius: 6,
                      icon: const FaIcon(FontAwesomeIcons.github),
                      iconSize: 42,
                      color: Theme.of(context).colorScheme.primary,
                      onPressed: () {
                        mylaunchUrl('https://github.com/FarzinNs83/NetShift');
                      },
                    ),
                  ),
                  Text("GitHub",
                      style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
              // const SizedBox(width: 16),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    child: IconButton(
                      splashRadius: 6,
                      icon: const Icon(Icons.support_agent),
                      iconSize: 42,
                      color: Theme.of(context).colorScheme.primary,
                      onPressed: () {
                        mylaunchUrl('https://t.me/feri_ns83');
                      },
                    ),
                  ),
                  Text("Support",
                      style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
