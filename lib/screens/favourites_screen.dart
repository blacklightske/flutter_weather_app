import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/favorites_cubit.dart';
import '../cubit/favorites_state.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FavoritesCubit>().loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) {
          if (state.status == FavoritesStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == FavoritesStatus.loaded) {
            if (state.favorites.isEmpty) {
              return const Center(child: Text('No favorites yet'));
            }

            return ListView.builder(
              itemCount: state.favorites.length,
              itemBuilder: (context, index) {
                final city = state.favorites[index];
                return ListTile(
                  title: Text(city.cityName),
                  subtitle: Text(city.country),
                );
              },
            );
          }

          if (state.status == FavoritesStatus.error) {
            return Center(
              child: Text(state.errorMessage ?? 'Error loading favorites'),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
