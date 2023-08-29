bool isValidCPF(String? cpf) {
  cpf = cpf?.replaceAll(RegExp(r'\.|-'), '');
  if (cpf == null || cpf.isEmpty) {
    return false;
  }
  if (cpf.length != 11) {
    return false;
  }
  for (int i = 0; i < 10; i++) {
    if (cpf == '$i' * 11) {
      return false;
    }
  }
  int sum = 0;
  for (int i = 0; i < 9; i++) {
    sum += int.parse(cpf[i]) * (10 - i);
  }
  int mod = (sum % 11);
  int firstVerifierDigit = (mod < 2) ? 0 : 11 - mod;
  sum = 0;
  for (int i = 0; i < 10; i++) {
    sum += int.parse(cpf[i]) * (11 - i);
  }
  mod = (sum % 11);
  int secondVerifierDigit = (mod < 2) ? 0 : 11 - mod;
  return cpf[9] == firstVerifierDigit.toString() &&
      cpf[10] == secondVerifierDigit.toString();
}
