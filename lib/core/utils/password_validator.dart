String? validatePassword(String password) {
  if (password.isEmpty) {
    return 'Password tidak boleh kosong';
  }

  if (password.length < 8) {
    return 'Password minimal 8 karakter';
  }

  final hasLetter = RegExp(r'[A-Za-z]').hasMatch(password);
  final hasNumber = RegExp(r'\d').hasMatch(password);

  if (!hasLetter || !hasNumber) {
    return 'Password harus mengandung huruf dan angka';
  }

  return null;
}
