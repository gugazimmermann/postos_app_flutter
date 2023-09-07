import 'package:flutter/material.dart';

import 'colors.dart';

abstract class ApiConstants {
  static const String baseUrl = 'http://192.168.1.2:5000/app';
  // static const String baseUrl = 'https://postos-api.touchsistemas.com.br/app';
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
  static const EdgeInsets paddingHalf = EdgeInsets.all(6.0);
}

abstract class SignaturesConstants {
  static const String biometric = 'Biometric';
  static const String facialRecognition = 'Facial Recognition';
  static const String digitalSignature = 'Digital Signature';
  static const String code = 'Code';
}

enum WeekDay {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
}

const weekDayStrings = {
  "GASSTATIONS.CONFIGURATIONS.DAY.MONDAY": WeekDay.monday,
  "GASSTATIONS.CONFIGURATIONS.DAY.TUESDAY": WeekDay.tuesday,
  "GASSTATIONS.CONFIGURATIONS.DAY.WEDNESDAY": WeekDay.wednesday,
  "GASSTATIONS.CONFIGURATIONS.DAY.THURSDAY": WeekDay.thursday,
  "GASSTATIONS.CONFIGURATIONS.DAY.FRIDAY": WeekDay.friday,
  "GASSTATIONS.CONFIGURATIONS.DAY.SATURDAY": WeekDay.saturday,
  "GASSTATIONS.CONFIGURATIONS.DAY.SUNDAY": WeekDay.sunday,
};

const translatedWeekDays = {
  WeekDay.monday: 'Segunda-feira',
  WeekDay.tuesday: 'Terça-feira',
  WeekDay.wednesday: 'Quarta-feira',
  WeekDay.thursday: 'Quinta-feira',
  WeekDay.friday: 'Sexta-feira',
  WeekDay.saturday: 'Sábado',
  WeekDay.sunday: 'Domingo',
};
