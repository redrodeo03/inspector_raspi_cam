class AppSettings {
  ImageQuality currentQuality = ImageQuality.high;
  bool isAppOfflineMode = false;
  bool isInvasiveMode = false;
}

enum ImageQuality { high, medium, low }

final appSettings = AppSettings();
