abstract class AppStrings {
  static const String title = 'Touch Sistemas Postos';
  static const String noAppInstalled = 'Aplicativo não instalado!';
}

abstract class GeneralStrings {
  static const optionNo = 'NÃO';
  static const optionYes = 'SIM';
  static const buttonSend = 'Enviar';
  static const buttonBack = 'Voltar';
  static const buttonClose = 'Fechar';
}

abstract class SignInStrings {
  static const String welcome = 'Bem vindo ao';
  static const labelDocument = 'Digite seu CPF:';
  static const placeholderDocument = 'CPF';
  static const String errorDocumentNull = 'CPF Inválido.';
  static const String errorDocument = 'Erro ao buscar dados do CPF.';
  static const String errorDriverNotFound = "Motorista não encontrado.";
  static const dialogDriverTitle = 'Você é:';
  static const inputHintCompany = 'Selecione a Empresa';
  static const String errorVehicle = 'Erro ao buscar veículos.';
  static const inputHintVehicle = 'Selecione o Veículo';
}

abstract class HomeTabsStrings {
  static const tabGasStations = 'Postos';
  static const tabSchedules = 'Agendamentos';
}

abstract class GasStationStrings {
  static const String errorGasStations = 'Erro ao buscar postos.';
  static const String noGasStations = 'Nenhum Posto para mostrar.';
  static const String gasStationsMap = 'Mapa dos Postos';
  static const String fuelTypes = 'Combustíveis Autorizados';
  static const String fuelTypesAll = 'Veículo sem Restrições';
  static const String products = 'Produtos';
  static const String productsZero = 'Nenhum Produto Autorizado';
  static const String productsPlural = 'Produtos Autorizados';
  static const String productsSingular = 'Produto Autorizado';
  static const String productsIn = 'Produtos em';
  static const String signatures = 'Assinaturas';
  static const String transactionsZero = 'Nenhum Abastecimento Realizado';
  static const String transactionsPlural = 'Abastecimentos Realizados';
  static const String transactionsSingular = 'Abastecimento Realizado';
  static const String transactionsIn = 'Abastecimentos em';
}

abstract class SchedulesStrings {
  static const String errorSchedule = 'Erro ao buscar agendamentos.';
  static const String noSchedule = 'Nenhum Agendamento para mostrar.';
  static const String title = 'Agendamentos';
}
