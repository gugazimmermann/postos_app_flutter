import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

void launchMapsUrl(BuildContext context, double lat, double lng, String type) {
  String urlString = '';
  if (type == 'google') {
    if (defaultTargetPlatform == TargetPlatform.android) {
      urlString = 'geo:$lat,$lng?q=$lat,$lng';
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      urlString = 'comgooglemaps://?q=$lat,$lng';
    }
  } else if (type == 'waze') {
    urlString = 'waze://?ll=$lat,$lng&navigate=yes';
  }
  Uri url = Uri.parse(urlString);
  launchUrl(url);
}
