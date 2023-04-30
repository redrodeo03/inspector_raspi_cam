class AppSettings {
  ImageQuality currentQuality = ImageQuality.high;
  bool isAppOfflineMode = false;
}

enum ImageQuality { high, medium, low }

final appSettings = AppSettings();
