class ScheduleServiceOptionsModel {
  final String name;

  ScheduleServiceOptionsModel({required this.name});

  factory ScheduleServiceOptionsModel.fromJson(Map<String, dynamic> json) {
    return ScheduleServiceOptionsModel(
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}
