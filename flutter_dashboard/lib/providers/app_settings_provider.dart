import 'package:flutter/material.dart';

import '../services/settings_service.dart';

class AppSettingsProvider extends ChangeNotifier {
  bool darkTheme = true;

  String dashboardWidget = 'history';

  Future<void> load() async {
    final settings = SettingsService();

    darkTheme = await settings.loadDarkTheme();

    dashboardWidget = await settings.loadDashboardWidget();

    notifyListeners();
  }

  Future<void> setDarkTheme(bool value) async {
    darkTheme = value;

    await SettingsService().saveDarkTheme(value);

    notifyListeners();
  }

  Future<void> setDashboardWidget(String value) async {
    dashboardWidget = value;

    await SettingsService().saveDashboardWidget(value);

    notifyListeners();
  }
}
