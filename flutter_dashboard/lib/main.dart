import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/app_settings_provider.dart';
import 'screens/dashboard_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppSettingsProvider()..load(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettingsProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Playwright Dashboard',

      theme: ThemeData(
        brightness: Brightness.light,

        scaffoldBackgroundColor: Colors.grey.shade100,

        cardColor: Colors.white,

        colorScheme: ColorScheme.light(
          primary: Colors.teal,
          surface: Colors.white,
          onSurface: Colors.black87,
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
        ),
      ),

      darkTheme: ThemeData(
        brightness: Brightness.dark,

        scaffoldBackgroundColor: const Color(0xFF111827),

        cardColor: const Color(0xFF1F2937),

        colorScheme: const ColorScheme.dark(
          primary: Colors.teal,
          surface: Color(0xFF1F2937),
          onSurface: Colors.white,
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1F2937),
          foregroundColor: Colors.white,
        ),
      ),

      themeMode: settings.darkTheme ? ThemeMode.dark : ThemeMode.light,

      home: const DashboardScreen(),
    );
  }
}
