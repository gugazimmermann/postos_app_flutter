class SchedulGasStationModal {
  final String id;
  final String name;

  SchedulGasStationModal({required this.id, required this.name});

  factory SchedulGasStationModal.fromJson(Map<String, dynamic> json) {
    return SchedulGasStationModal(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
