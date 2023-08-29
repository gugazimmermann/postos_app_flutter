abstract class ApiConstants {
  static const String baseUrl = 'http://192.168.1.2:5000/app';
  static const String errorNetwork =
      'Erro de rede. Por favor, verifique sua conexão com a internet.';
  static const String errorApi = 'Ocorreu um erro. Por favor, tente novamente.';
  static const String errorDocumentNull = 'CPF Inválido.';
  static const String errorDocument = 'Erro ao buscar dados do CPF.';
  static const String errorDriverNotFound = "Motorista não encontrado.";
  static const String errorVehicle = 'Erro ao buscar veículos.';
}

abstract class AppConstants {
  static const String title = 'Touch Sistemas Postos';
  static const String welcome = 'Bem vindo ao';
}
