import 'package:flutter/material.dart';

import 'colors.dart';

abstract class ApiConstants {
  // static const String baseUrl = 'http://192.168.1.2:5000/app';
  static const String baseUrl = 'https://postos-api.touchsistemas.com.br/app';
  static const String errorNetwork =
      'Erro de rede. Por favor, verifique sua conexão com a internet.';
  static const String errorApi = 'Ocorreu um erro. Por favor, tente novamente.';
  static const String noApp = 'Aplicativo não instalado!';
}

abstract class LocationConstants {
  static const String disabled = 'O serviço de localização está desativado.';
  static const String permissionDenied = 'Permissão de localização negada.';
  static const String error = ' Ocorreu um erro ao obter a localização';
}

abstract class Lists {
  static const EdgeInsets edgeInsets =
      EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0);
  static const Color color = ColorsConstants.cardWhite;
  static const double elevation = 2.0;
  static RoundedRectangleBorder shape =
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0));
  static const EdgeInsets padding = EdgeInsets.all(12.0);
}

abstract class SignaturesConstants {
  static const String biometric = 'Biometric';
  static const String facialRecognition = 'Facial Recognition';
  static const String digitalSignature = 'Digital Signature';
  static const String code = 'Code';
}
