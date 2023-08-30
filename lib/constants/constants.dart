abstract class ApiConstants {
  static const String baseUrl = 'http://192.168.1.2:5000/app';
  static const String errorNetwork =
      'Erro de rede. Por favor, verifique sua conexão com a internet.';
  static const String errorApi = 'Ocorreu um erro. Por favor, tente novamente.';
}

abstract class LocationConstants {
  static const String disabled = '"O serviço de localização está desativado."';
  static const String permissionDenied = 'Permissão de localização negada.';
  static const String error = ' Ocorreu um erro ao obter a localização';
}
