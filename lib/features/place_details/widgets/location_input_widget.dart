import 'package:favorite_places/features/maps/screens/map_screen.dart';
import 'package:favorite_places/features/new_place/data/model/place.dart';
import 'package:favorite_places/util/location_util.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationInputWidget extends StatefulWidget {
  const LocationInputWidget({
    super.key,
    required this.onSelectLocation,
  });

  final void Function(PlaceLocation location) onSelectLocation;

  @override
  State<LocationInputWidget> createState() {
    return _LocationInputWidget();
  }
}

class _LocationInputWidget extends State<LocationInputWidget> {
  PlaceLocation? userLocation;

  var isFetchingLocation = false;

  void getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      isFetchingLocation = true;
    });

    locationData = await location.getLocation();

    if (locationData.latitude == null || locationData.longitude == null) {
      return;
    }

    saveLocation(locationData.latitude!, locationData.longitude!);
  }

  void saveLocation(double lat, double lng) async {
    final address = await LocationUtil().getAddress(lat, lng);

    userLocation = PlaceLocation(
      lat: lat,
      long: lng,
      address: address,
    );

    userLocation!.locationImagePreview = LocationUtil().locationImagePreview(lat, lng);

    widget.onSelectLocation(userLocation!);

    setState(() {
      isFetchingLocation = false;
    });
  }

  void setLocationOnMap() async {
    final location = await Navigator.of(context).push<LatLng?>(
      MaterialPageRoute(
        builder: (ctx) => MapScreen(
          isSelecting: true,
          location: userLocation,
        ),
      ),
    );

    if (location == null) {
      return;
    }

    saveLocation(location.latitude, location.longitude);
  }

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text(
      'Location is empty',
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
    );

    if (isFetchingLocation) {
      previewContent = const CircularProgressIndicator();
    }

    if (userLocation != null) {
      previewContent = Image.network(
        userLocation!.locationImagePreview!,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      );
    }

    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          height: 120,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              width: 2,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            ),
          ),
          child: previewContent,
        ),
        TextButton.icon(
          onPressed: () {
            setLocationOnMap();
          },
          icon: const Icon(Icons.map),
          label: const Text('Select On Map'),
        )
      ],
    );
  }
}
