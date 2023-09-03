library geofence_touch_sitemas;

import 'dart:async';
import 'package:geolocator/geolocator.dart';

enum GeofenceEvent { init, enter, exit }

class LocationGeofenceProvider {
  static StreamSubscription<Position>? _positionStream;
  static final StreamController<GeofenceEventWithId> _controller =
      StreamController<GeofenceEventWithId>.broadcast();
  static final Map<String, GeofencePoint> _geofencePoints = {};

  static Stream<GeofenceEventWithId>? getGeofenceStream() {
    return _controller.stream;
  }

  static startGeofenceService(
      {required String id,
      required double pointedLatitude,
      required double pointedLongitude,
      required double radiusMeter,
      required int eventPeriodInSeconds}) async {
    _geofencePoints[id] =
        GeofencePoint(pointedLatitude, pointedLongitude, radiusMeter);

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    if (permission == LocationPermission.deniedForever) return;

    if (_positionStream == null) {
      _positionStream = Geolocator.getPositionStream(
              locationSettings:
                  const LocationSettings(accuracy: LocationAccuracy.high))
          .listen((Position? position) {
        if (position != null) {
          _checkGeofence(position);
          _positionStream!
              .pause(Future.delayed(Duration(seconds: eventPeriodInSeconds)));
        }
      });
      _controller.add(GeofenceEventWithId(GeofenceEvent.init, ''));
    }
  }

  static void clearGeofencePoints() {
    _geofencePoints.clear();
  }

  static _checkGeofence(Position position) {
    for (var id in _geofencePoints.keys) {
      double distanceInMeters = Geolocator.distanceBetween(
          _geofencePoints[id]!.latitude,
          _geofencePoints[id]!.longitude,
          position.latitude,
          position.longitude);
      if (distanceInMeters <= _geofencePoints[id]!.radius) {
        _controller.add(GeofenceEventWithId(GeofenceEvent.enter, id));
      }
    }
  }

  static stopGeofenceService() {
    if (_positionStream != null) {
      _positionStream!.cancel();
    }
  }
}

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
