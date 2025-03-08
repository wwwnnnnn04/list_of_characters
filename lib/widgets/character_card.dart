import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/character.dart';

import '../providers/favorite_provider.dart';

class CharacterCard extends StatelessWidget {
  final Character character;
  final VoidCallback? onFavoritePressed;

  const CharacterCard(
      {super.key, required this.character, this.onFavoritePressed});

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    final isFavorite =
        favoriteProvider.favorite.any((char) => char.id == character.id);

    return Card(
      key: ValueKey(character.id), 
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                character.imageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    character.name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${character.status} - ${character.species}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: Icon(
                        isFavorite ? Icons.star : Icons.star_border,
                      ),
                      onPressed: onFavoritePressed ??
                          () {
                            if (isFavorite) {
                              favoriteProvider.removeFavorite(character.id);
                            } else {
                              favoriteProvider.addFavorite(character);
                            }
                          },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
