import 'schedule_service_model.dart';
import 'schedule_service_options_model.dart';
import 'schedule_gas_station_modal.dart';

class ScheduleModel {
  final String id;
  final String date;
  final bool confirmed;
  final bool done;
  final ScheduleServiceModel scheduleService;
  final List<ScheduleServiceOptionsModel> scheduleServiceOptions;
  final SchedulGasStationModal gasStation;

  ScheduleModel({
    required this.id,
    required this.date,
    required this.confirmed,
    required this.done,
    required this.scheduleService,
    required this.scheduleServiceOptions,
    required this.gasStation,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    List<ScheduleServiceOptionsModel> scheduleServiceOptionsList =
        (json['ScheduleServiceOptions'] as List)
            .map((item) => ScheduleServiceOptionsModel.fromJson(item))
            .toList();

    return ScheduleModel(
      id: json['id'],
      date: json['date'],
      confirmed: json['confirmed'] is bool ? json['confirmed'] : false,
      done: json['done'] is bool ? json['done'] : false,
      scheduleService: ScheduleServiceModel.fromJson(json['ScheduleService']),
      scheduleServiceOptions: scheduleServiceOptionsList,
      gasStation: SchedulGasStationModal.fromJson(json['GasStation']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'confirmed': confirmed,
      'done': done,
      'ScheduleService': scheduleService.toJson(),
      'ScheduleServiceOptions':
          scheduleServiceOptions.map((item) => item.toJson()).toList(),
      'GasStation': gasStation.toJson(),
    };
  }
}
