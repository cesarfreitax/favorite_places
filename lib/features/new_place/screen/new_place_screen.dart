import 'dart:io';

import 'package:favorite_places/features/new_place/data/model/place.dart';
import 'package:favorite_places/features/place_details/widgets/image_input_widget.dart';
import 'package:favorite_places/features/place_details/widgets/location_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:favorite_places/providers/favorite_places_notifier.dart';

class NewPlaceScreen extends ConsumerStatefulWidget {
  const NewPlaceScreen({super.key});

  @override
  ConsumerState<NewPlaceScreen> createState() {
    return _NewPlaceScreenState();
  }
}

class _NewPlaceScreenState extends ConsumerState<NewPlaceScreen> {
  final titleController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  String newFavoritePlaceTitle = "";
  File? imageFile;
  PlaceLocation? userLocation;

  void setLocation(PlaceLocation location) {
    userLocation = location;
  }

  void addNewFavoritePlace() {
    final title = titleController.value.text;

    if (title.isEmpty ||
        imageFile == null ||
        userLocation == null) {
      return;
    }

    ref
        .read(favoritePlacesProvider.notifier)
        .addNewFavoritePlace(title, imageFile!, userLocation!);

    Navigator.of(context).pop();
  }

  void selectImage(File? selectedImageFile) {
    imageFile = selectedImageFile;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new place'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, top: 8, right: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Title'),
                controller: titleController,
                style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
              const SizedBox(
                height: 14,
              ),
              const SizedBox(
                height: 16,
              ),
              ImageInputWidget(onSelectImage: selectImage),
              const SizedBox(
                height: 16,
              ),
              LocationInputWidget(onSelectLocation: setLocation),
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                onPressed: () {
                  addNewFavoritePlace();
                },
                label: const Text('Add Place'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
