import '../constants/constants.dart';

class GasStationOpenHoursModel {
  final WeekDay weekDay;
  final String startTime;
  final String endTime;

  GasStationOpenHoursModel({
    required this.weekDay,
    required this.startTime,
    required this.endTime,
  });

  factory GasStationOpenHoursModel.fromJson(Map<String, dynamic> json) {
    return GasStationOpenHoursModel(
      weekDay: weekDayStrings[json['weekDay']]!,
      startTime: json['startTime'],
      endTime: json['endTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'weekDay':
          weekDayStrings.entries.firstWhere((e) => e.value == weekDay).key,
      'startTime': startTime,
      'endTime': endTime,
    };
  }
}
