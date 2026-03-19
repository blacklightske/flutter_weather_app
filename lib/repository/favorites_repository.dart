import '../database/favorites_database.dart';
import '../models/favorite_city.dart';

class FavoritesRepository {
  final FavoritesDatabase _db = FavoritesDatabase.instance;

  Future<int> addFavorite(FavoriteCity city) {
    print('FavoritesRepository.addFavorite repo called');
    return _db.insertFavorite(city);
  }

  Future<List<FavoriteCity>> getFavorites() async {
    final rows = await _db.getAllFavorites();

    return rows.map((row) => FavoriteCity.fromMap(row)).toList();
  }
}
