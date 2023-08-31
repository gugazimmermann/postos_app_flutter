class ScheduleServiceModel {
  final String name;
  final String duration;

  ScheduleServiceModel({required this.name, required this.duration});

  factory ScheduleServiceModel.fromJson(Map<String, dynamic> json) {
    return ScheduleServiceModel(
      name: json['name'],
      duration: json['duration'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'duration': duration,
    };
  }
}
