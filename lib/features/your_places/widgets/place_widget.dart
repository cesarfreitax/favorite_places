import 'package:favorite_places/features/new_place/data/model/place.dart';
import 'package:favorite_places/features/place_details/screen/place_details_screen.dart';
import 'package:flutter/material.dart';

class PlaceWidget extends StatefulWidget {
  const PlaceWidget({
    super.key,
    required this.place,
  });

  final Place place;

  @override
  State<PlaceWidget> createState() {
    return _PlaceWidgetState();
  }
}

class _PlaceWidgetState extends State<PlaceWidget> {

  void goToFavoritePlaceDetails() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PlaceDetailsScreen(
          place: widget.place,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: goToFavoritePlaceDetails,
      child: ListTile(
        leading: CircleAvatar(
          radius: 26,
          backgroundImage: FileImage(widget.place.imageFile),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.place.title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer),
            ),
            Text(
              widget.place.location.address,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer),
            ),
          ],
        ),
      ),
    );
  }
}
