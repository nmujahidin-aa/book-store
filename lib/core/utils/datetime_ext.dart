extension GreetingExt on DateTime {
  String get indoGreeting {
    final h = hour;
    if (h >= 4 && h < 11) return 'Selamat Pagi';
    if (h >= 11 && h < 15) return 'Selamat Siang';
    if (h >= 15 && h < 18) return 'Selamat Sore';
    return 'Selamat Malam';
  }
}

extension RentExpiryExt on DateTime {
  bool get isExpired => isBefore(DateTime.now());
}