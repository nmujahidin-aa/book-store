class Validators {
  static String? email(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return 'Email wajib diisi';
    final ok = RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value);
    if (!ok) return 'Format email tidak valid';
    return null;
  }

  static String? password(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return 'Password wajib diisi';
    if (value.length < 8) return 'Password minimal 8 karakter';
    final hasLetter = RegExp(r'[A-Za-z]').hasMatch(value);
    final hasNumber = RegExp(r'\d').hasMatch(value);
    if (!hasLetter || !hasNumber) return 'Password harus mengandung huruf dan angka';
    return null;
  }

  static String? required(String? v, {String label = 'Field'}) {
    if ((v ?? '').trim().isEmpty) return '$label wajib diisi';
    return null;
  }
}