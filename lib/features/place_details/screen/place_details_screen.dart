import 'package:favorite_places/features/maps/screens/map_screen.dart';
import 'package:favorite_places/features/new_place/data/model/place.dart';
import 'package:favorite_places/util/location_util.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceDetailsScreen extends StatefulWidget {
  const PlaceDetailsScreen({
    super.key,
    required this.place,
  });

  final Place place;

  @override
  State<PlaceDetailsScreen> createState() {
    return _PlaceDetailsScreenState();
  }
}

class _PlaceDetailsScreenState extends State<PlaceDetailsScreen> {
  void setLocationOnMap() async {
    final location = await Navigator.of(context).push<LatLng?>(
      MaterialPageRoute(
        builder: (ctx) => MapScreen(
          isSelecting: false,
          location: widget.place.location,
        ),
      ),
    );

    if (location == null) {
      return;
    }

    final newAddress = await LocationUtil().getAddress(location.latitude, location.longitude);
    final newLocationImagePreview = LocationUtil().locationImagePreview(location.latitude, location.longitude);

    setState(() {
      widget.place.location.address = newAddress;
      widget.place.location.locationImagePreview = newLocationImagePreview;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.place.title),
      ),
      body: Stack(
        children: [
          Image.file(
            widget.place.imageFile,
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setLocationOnMap();
                    },
                    child: CircleAvatar(
                      radius: 70,
                      backgroundImage: NetworkImage(
                          widget.place.location.locationImagePreview ?? ""),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.transparent, Colors.black54],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        )),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        widget.place.location.address,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                            color: Theme.of(context).colorScheme.onSurface),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ],
              ))
        ],
      ),
    );
  }
}
