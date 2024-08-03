import 'package:favorite_places/features/new_place/data/model/place.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
    required this.isSelecting,
    this.location,
  });

  final bool isSelecting;
  final PlaceLocation? location;

  @override
  State<MapScreen> createState() {
    return _MapScreenState();
  }
}

class _MapScreenState extends State<MapScreen> {
  LatLng? pickedLocation;

  void setLocation(LatLng location) {
    setState(() {
      pickedLocation = location;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double lat = widget.location != null ? widget.location!.lat : -13.200;
    final double lng = widget.location != null ? widget.location!.long : 18.000;

    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.isSelecting ? 'Pick Your Location' : 'Your Location'),
        actions: widget.isSelecting
            ? [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop(pickedLocation);
                  },
                  icon: const Icon(Icons.check),
                )
              ]
            : null,
      ),
      body: GoogleMap(
        onTap: (location) {
          widget.isSelecting ? setLocation(location) : null;
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(lat, lng),
          zoom: 16,
        ),
        markers: {
          Marker(
            markerId: const MarkerId('m1'),
            position: pickedLocation ?? LatLng(lat, lng),
          )
        },
      ),
    );
  }
}
