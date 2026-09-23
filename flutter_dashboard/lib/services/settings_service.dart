import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const String themeKey = 'dark_theme';

  static const String dashboardKey = 'dashboard_widget';

  Future<bool> loadDarkTheme() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(themeKey) ?? true;
  }

  Future<void> saveDarkTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(themeKey, value);
  }

  Future<String> loadDashboardWidget() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(dashboardKey) ?? 'history';
  }

  Future<void> saveDashboardWidget(String value) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(dashboardKey, value);
  }
}
