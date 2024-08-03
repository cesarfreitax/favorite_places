import 'package:favorite_places/features/new_place/data/model/place.dart';
import 'package:favorite_places/features/your_places/widgets/place_widget.dart';
import 'package:favorite_places/providers/favorite_places_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../new_place/screen/new_place_screen.dart';

class YourPlacesScreen extends ConsumerStatefulWidget {
  const YourPlacesScreen({super.key});

  @override
  ConsumerState<YourPlacesScreen> createState() {
    return _YourPlacesScreenState();
  }
}

class _YourPlacesScreenState extends ConsumerState<YourPlacesScreen> {
  late Future<void> futurePlaces;

  @override
  void initState() {
    super.initState();
    futurePlaces = ref.read(favoritePlacesProvider.notifier).loadPlaces();
  }

  void goToNewPlaceScreen() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => const NewPlaceScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final List<Place> favoritePlaces = ref.watch(favoritePlacesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Places'),
        actions: [
          IconButton(
            onPressed: goToNewPlaceScreen,
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: FutureBuilder(
          future: futurePlaces,
          builder: (ctx, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : favoritePlaces.isNotEmpty
                  ? ListView.builder(
                      itemCount: favoritePlaces.length,
                      itemBuilder: (ctx, idx) => PlaceWidget(
                        place: favoritePlaces[idx],
                      ),
                    )
                  : Center(
                      child: Text(
                        'No Favorite Place Added Yet...',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                      ),
                    ),
        ),
      ),
    );
  }
}
