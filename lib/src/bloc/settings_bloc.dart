class AppSettings {
  ImageQuality currentQuality = ImageQuality.high;
  bool isAppOfflineMode = false;
  bool isInvasiveMode = false;
  String companyName = 'deckInspectors';
  int reportImageQuality = 100;
  int imageinRowCount = 4;
}

enum ImageQuality { high, medium, low }

final appSettings = AppSettings();
