mixin MixinValidations {
  
  // CAMPO VAZIO \\
  String? isEmpty(String? value, [String? message]) {
    if (value!.isEmpty) return message ?? "Este campo é obrigatório!";
    return null;
  }

  // EMAIL \\
  String? validateEmail(String? value, [String? message]) {
    if (value == null || value.isEmpty) {
      return message ?? "Este campo é obrigatório!";
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
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
    if (!RegExp(r'^\d{3}\.\d{3}\.\d{3}-\d{2}$').hasMatch(value)) {
      return message ?? "Insira um CPF válido!";
    }
    return null;
  }

  // CNPJ \\
  String? validateCNPJ(String? value, [String? message]) {
    if (value == null || value.isEmpty) return null;
    if (!RegExp(r'^\d{2}\.\d{3}\.\d{3}/\d{4}-\d{2}$').hasMatch(value)) {
      return message ?? "Insira um CNPJ válido!";
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