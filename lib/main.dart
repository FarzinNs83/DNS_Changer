import 'package:dns_changer/service/dns_provider.dart';
import 'package:dns_changer/service/system_tray.dart';
import 'package:dns_changer/theme/theme_provider.dart';
import 'package:dns_changer/view/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'package:windows_single_instance/windows_single_instance.dart';

Future<void> main(List<String> arguments) async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    backgroundColor: Colors.transparent,
    size: Size(440, 660),
    center: true,
    title: "DNS Changer",
  );

  await windowManager.waitUntilReadyToShow(windowOptions).then((_) async {
    await windowManager.setTitleBarStyle(TitleBarStyle.hidden);
    await windowManager.show();
    await windowManager.focus();
  });

  ThemeProvider themeProvider = ThemeProvider(isDarkMode: false);
  await themeProvider.loadTheme();

  await WindowsSingleInstance.ensureSingleInstance(
    arguments,
    "NetShift_instance_checker",
    // ignore: avoid_print
    onSecondWindow: (arguments) => print(arguments),
  );

  await initTray();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DNSProvider()),
        ChangeNotifierProvider(create: (context) => themeProvider),

      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          theme: themeProvider.theme,
          debugShowCheckedModeBanner: false,
          home: const HomePage(),
        );
      },
    );
  }
}
