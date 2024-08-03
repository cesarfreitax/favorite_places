import 'dart:convert';
import 'package:http/http.dart' as http;

import 'constants.dart';

class LocationUtil {

  Future<String> getAddress(double lat, double lng) async {
    final url = Uri.parse(
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=${Constants
            .googleMapsApiKey}");
    final response = await http.get(url);
    final resData = jsonDecode(response.body);
    final address = resData["results"][0]["formatted_address"];

    return address;
  }

  String locationImagePreview(double lat, double lng, [int? zoom, String? size, String? type, String? markerColor]) {
    return "https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=${zoom ?? 16}&size=${size ?? "600x300"}&maptype=${type ?? "roadmap"}&markers=color:${markerColor ?? "red"}%7Clabel:S%7C$lat,$lng&key=${Constants.googleMapsApiKey}";
  }

}