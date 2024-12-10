class Helpers {
  // Valida se o CEP tem 8 dígitos numéricos
  static bool isValidCep(String cep) {
    final regex = RegExp(r'^\d{8}$');
    return regex.hasMatch(cep);
  }
}
