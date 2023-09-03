enum GeofenceEvent { init, enter, exit }

class GeofenceEventWithId {
  final GeofenceEvent event;
  final String id;

  GeofenceEventWithId(this.event, this.id);
}

class GeofencePoint {
  final double latitude;
  final double longitude;
  final double radius;

  GeofencePoint(this.latitude, this.longitude, this.radius);
}
