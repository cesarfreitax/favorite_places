import 'dart:io';

import 'package:uuid/uuid.dart';

const uuid = Uuid();

class PlaceLocation {
  PlaceLocation({
    required this.lat,
    required this.long,
    required this.address,
    this.locationImagePreview,
  });

  final double lat;
  final double long;
  String address;
  String? locationImagePreview;
}

class Place {
  Place({
    required this.title,
    required this.imageFile,
    required this.location,
    id,
  }) : id = id ?? uuid.v4();

  final String id;
  final String title;
  final File imageFile;
  final PlaceLocation location;
}
