import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants/constants.dart';
import '../models/gas_station_open_hours.dart';

DateTime toDateTime(TimeOfDay time) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day, time.hour, time.minute);
}

bool isGasStationOpen(GasStationOpenHoursModel openHours) {
  final now = DateTime.now();
  final currentWeekDay = WeekDay.values[now.weekday - 1];
  final currentTime = TimeOfDay(hour: now.hour, minute: now.minute);
  final startTime =
      TimeOfDay.fromDateTime(DateFormat("HH:mm:ss").parse(openHours.startTime));
  final endTime =
      TimeOfDay.fromDateTime(DateFormat("HH:mm:ss").parse(openHours.endTime));
  return currentWeekDay == openHours.weekDay &&
      toDateTime(currentTime).isAfter(toDateTime(startTime)) &&
      toDateTime(currentTime).isBefore(toDateTime(endTime));
}
