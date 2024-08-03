import 'dart:io';

import 'package:favorite_places/features/new_place/data/model/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqflite.dart';

const userPlacesTable = 'user_places';

class FavoritePlacesNotifier extends StateNotifier<List<Place>> {
  FavoritePlacesNotifier() : super(const []);

  Future<Database> getDatabase() async {
    final dbPath = await sql.getDatabasesPath();
    final db = await sql.openDatabase(
      path.join(dbPath, 'favorite_places.db'),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE $userPlacesTable (id TEXT PRIMARY KEY, title TEXT, image_path TEXT, lat REAL, lng REAL, address TEXT, location_image_preview TEXT)');
      },
      version: 1,
    );
    return db;
  }

  Future<void> loadPlaces() async {
    final db = await getDatabase();
    final data = await db.query(userPlacesTable);
    final places = data
        .map(
          (row) => Place(
            id: row['id'] as String,
            title: row['title'] as String,
            imageFile: File(row['image_path'] as String),
            location: PlaceLocation(
              lat: row['lat'] as double,
              long: row['lng'] as double,
              address: row['address'] as String,
              locationImagePreview: row['location_image_preview'] as String,
            ),
          ),
        )
        .toList();

    state = places;
  }

  void addNewFavoritePlace(
      String title, File image, PlaceLocation location) async {
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final filename = path.basename(image.path);
    final copiedImage = await image.copy('${appDir.path}/$filename');

    Place place =
        Place(title: title, imageFile: copiedImage, location: location);

    final db = await getDatabase();

    db.insert(userPlacesTable, {
      'id': place.id,
      'title': place.title,
      'image_path': place.imageFile.path,
      'lat': place.location.lat,
      'lng': place.location.long,
      'address': place.location.address,
      'location_image_preview': place.location.locationImagePreview
    });

    state = [place, ...state];
  }

}

final favoritePlacesProvider =
    StateNotifierProvider<FavoritePlacesNotifier, List<Place>>(
  (ref) => FavoritePlacesNotifier(),
);
