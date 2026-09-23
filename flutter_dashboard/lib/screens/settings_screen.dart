import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_settings_provider.dart';
import '../theme/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettingsProvider>();

    return Scaffold(
      backgroundColor: AppColors.background(context),

      appBar: AppBar(
        backgroundColor: AppColors.card(context),
        title: const Text('Settings'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
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
          ],
        ),
      ),
    );
  }
}
