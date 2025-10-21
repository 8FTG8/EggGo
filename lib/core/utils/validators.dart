mixin MixinValidations {
  
  // CAMPO VAZIO \\
  String? isEmpty(String? value, [String? message]) {
    if (value == null || value.isEmpty) return message ?? "Este campo é obrigatório!";
    return null;
  }

  // EMAIL \\
  String? validateEmail(String? value, [String? message]) {
    // Permite que o campo seja opcional. Use em conjunto com `isEmpty` se for obrigatório.
    if (value == null || value.isEmpty) return null;
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value)) {
      return message ?? "Insira um email válido!";
    }
    return null;
  }

  // SENHA \\
  String? validatePassword(String? value, [String? message]) {
    if (value == null || value.isEmpty) {
      return message ?? "Este campo é obrigatório!";
    }
    if (value.length < 8) {
      return message ?? "A senha deve possuir no mínimo 8 caracteres.";
    }
    return null;
  }

  // CPF \\
  String? validateCPF(String? value, [String? message]) {
    if (value == null || value.isEmpty) return null; 

    final cleaned = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleaned.length != 11) {
      return message ?? "CPF deve conter 11 dígitos.";
    }
    // Evita CPFs com todos os dígitos iguais (ex: 111.111.111-11)
    if (RegExp(r'^(\d)\1*$').hasMatch(cleaned)) {
      return message ?? "CPF inválido.";
    }
    return null;
  }

  // CNPJ \\
  String? validateCNPJ(String? value, [String? message]) {
    if (value == null || value.isEmpty) return null;
    final cleaned = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleaned.length != 14) {
      return message ?? "CNPJ deve conter 14 dígitos.";
    }
    return null;
  }

  // LISTA DE VALIDADORES \\
  String? combineValidators(List<String? Function()> validators) {
    for (final validator in validators) {
      final result = validator();
      if (result != null) return result;
    }
    return null;
  }
}