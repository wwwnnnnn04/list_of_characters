import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/favorite_provider.dart';

import '../widgets/character_card.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});
  static const routeName = '/favorite';

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  void _removeItem(FavoriteProvider provider, int index) {
    final character = provider.favorite[index];
    _listKey.currentState!.removeItem(
      index,
      (context, animation) => FadeTransition(
        opacity: animation,
        child: SizeTransition(
          sizeFactor: animation,
          child: CharacterCard(character: character),
        ),
      ),
      duration: const Duration(milliseconds: 300),
    );

    provider.removeFavorite(character.id);
  }

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);

    return Column(
      children: [
        Expanded(
          child: AnimatedList(
            key: _listKey,
            initialItemCount: favoriteProvider.favorite.length,
            itemBuilder: (context, index, animation) {
              final character = favoriteProvider.favorite[index];

              return FadeTransition(
                opacity: animation,
                child: SizeTransition(
                  sizeFactor: animation,
                  child: CharacterCard(
                    character: character,
                    onFavoritePressed: () =>
                        _removeItem(favoriteProvider, index),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
