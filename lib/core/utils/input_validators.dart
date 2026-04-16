class InputValidators {
  static String? requiredField(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return '$label wajib diisi';
    }
    return null;
  }

  static String? email(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Email wajib diisi';
    final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!regex.hasMatch(v)) return 'Format email tidak valid';
    return null;
  }

  static String? password(String? value) {
    final v = value ?? '';
    if (v.length < 6) return 'Password minimal 6 karakter';
    return null;
  }

  static String? price(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Harga wajib diisi';
    final parsed = double.tryParse(v);
    if (parsed == null || parsed <= 0) return 'Harga tidak valid';
    return null;
  }

  static String? qty(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Qty wajib diisi';
    final parsed = int.tryParse(v);
    if (parsed == null || parsed <= 0) return 'Qty tidak valid';
    return null;
  }
}
