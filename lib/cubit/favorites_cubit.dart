import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/favorite_city.dart';
import '../repository/favorites_repository.dart';
import 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final FavoritesRepository _repository;

  FavoritesCubit(this._repository) : super(const FavoritesState());

  Future<void> loadFavorites() async {
    emit(state.copyWith(status: FavoritesStatus.loading));

    try {
      final favorites = await _repository.getFavorites();

      emit(
        state.copyWith(status: FavoritesStatus.loaded, favorites: favorites),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: FavoritesStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> addFavorite(FavoriteCity city) async {
    print('FavoritesCubit.addFavorite called');
    await _repository.addFavorite(city);

    // reload list after insertion
    await loadFavorites();
  }
}
