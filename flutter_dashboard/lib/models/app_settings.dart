class AppSettings {
  final bool darkTheme;
  final String dashboardWidget;

  AppSettings({required this.darkTheme, required this.dashboardWidget});

  AppSettings copyWith({bool? darkTheme, String? dashboardWidget}) {
    return AppSettings(
      darkTheme: darkTheme ?? this.darkTheme,
      dashboardWidget: dashboardWidget ?? this.dashboardWidget,
    );
  }
}
