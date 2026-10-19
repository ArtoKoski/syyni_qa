import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_settings_provider.dart';
import '../services/report_service.dart';
import '../services/settings_service.dart';
import '../theme/app_colors.dart';
import '../services/dashboard_refresh_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _urlController = TextEditingController();

  final SettingsService _settingsService = SettingsService();

  @override
  void initState() {
    super.initState();
    _loadBackendUrl();
  }

  Future<void> _loadBackendUrl() async {
    final url = await _settingsService.loadBackendUrl();

    if (mounted) {
      setState(() {
        _urlController.text = url;
      });
    }
  }

  Future<void> _saveBackendUrl() async {
    await _settingsService.saveBackendUrl(_urlController.text);

    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Backend URL saved')));
    }

    ReportService.baseUrl = _urlController.text;

    if (mounted) {
      DashboardRefreshService.refresh();

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettingsProvider>();

    return Scaffold(
      backgroundColor: AppColors.background(context),

      appBar: AppBar(
        backgroundColor: AppColors.card(context),
        title: const Text('Settings'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // APPEARANCE

            Text(
              'Appearance',
              style: TextStyle(
                color: AppColors.text(context),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Card(
              color: AppColors.card(context),

              child: SwitchListTile(
                title: Text(
                  'Dark Theme',
                  style: TextStyle(color: AppColors.text(context)),
                ),

                value: settings.darkTheme,

                onChanged: (value) async {
                  await settings.setDarkTheme(value);
                },
              ),
            ),

            const SizedBox(height: 30),

            // DASHBOARD
            Text(
              'Dashboard',
              style: TextStyle(
                color: AppColors.text(context),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Card(
              color: AppColors.card(context),

              child: Padding(
                padding: const EdgeInsets.all(16),

                child: Row(
                  children: [
                    Text(
                      'History Widget',
                      style: TextStyle(color: AppColors.text(context)),
                    ),

                    const Spacer(),

                    DropdownButton<String>(
                      value: settings.dashboardWidget,

                      dropdownColor: AppColors.card(context),

                      items: [
                        DropdownMenuItem(
                          value: 'history',
                          child: Text(
                            'History List',
                            style: TextStyle(color: AppColors.text(context)),
                          ),
                        ),

                        DropdownMenuItem(
                          value: 'lineChart',
                          child: Text(
                            'Line Chart',
                            style: TextStyle(color: AppColors.text(context)),
                          ),
                        ),
                      ],

                      onChanged: (value) async {
                        if (value == null) {
                          return;
                        }

                        await settings.setDashboardWidget(value);
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // CONNECTION
            Text(
              'Connection',
              style: TextStyle(
                color: AppColors.text(context),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Card(
              color: AppColors.card(context),

              child: Padding(
                padding: const EdgeInsets.all(16),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      'Backend URL',
                      style: TextStyle(color: AppColors.text(context)),
                    ),

                    const SizedBox(height: 12),

                    TextField(
                      controller: _urlController,

                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),

                        hintText: 'http://10.6.xxx.xxx:3000',
                      ),
                    ),

                    const SizedBox(height: 16),

                    ElevatedButton.icon(
                      onPressed: _saveBackendUrl,

                      icon: const Icon(Icons.save),

                      label: const Text('Save URL'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
