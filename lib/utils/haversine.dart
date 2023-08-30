import 'dart:math';

const R = 6371.0;

double haversineDistance(double lat1, double lon1, double lat2, double lon2) {
  var dLat = _degreesToRadians(lat2 - lat1);
  var dLon = _degreesToRadians(lon2 - lon1);

  lat1 = _degreesToRadians(lat1);
  lat2 = _degreesToRadians(lat2);

  var a = sin(dLat / 2) * sin(dLat / 2) +
      sin(dLon / 2) * sin(dLon / 2) * cos(lat1) * cos(lat2);
  var c = 2 * atan2(sqrt(a), sqrt(1 - a));

  return R * c;
}

double _degreesToRadians(double degrees) {
  return degrees * pi / 180;
}
