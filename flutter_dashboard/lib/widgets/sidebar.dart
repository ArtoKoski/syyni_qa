import 'package:flutter/material.dart';

import '../screens/settings_screen.dart';
import '../screens/api_test_screen.dart';
import '../screens/reports_screen.dart';
import '../screens/ui_tests_screen.dart';

class DashboardSidebar extends StatelessWidget {
  const DashboardSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: const Color(0xFF111827),
      child: Column(
        children: [
          const SizedBox(height: 40),

          const Text(
            'Syyni QA Dashboard',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 40),

          ListTile(
            leading: const Icon(Icons.dashboard, color: Colors.white),
            title: const Text(
              'Dashboard',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),

          ListTile(
            leading: const Icon(Icons.api, color: Colors.white),
            title: const Text(
              'API Tests',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ApiTestsScreen()),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.bug_report, color: Colors.white),
            title: const Text(
              'UI Tests',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UiTestsScreen()),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.bar_chart, color: Colors.white),
            title: const Text('Reports', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TestHistoryScreen(),
                ),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.settings, color: Colors.white),
            title: const Text(
              'Settings',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
          const Spacer(),

          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Version 1.0', style: TextStyle(color: Colors.white54)),
          ),
        ],
      ),
    );
  }
}
