import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/character.dart';

enum SortType { name, status }

class FavoriteProvider with ChangeNotifier {
  List<Character> _favorite = [];
  List<Character> get favorite => [..._favorite];
  SortType _sortType = SortType.name;
  SortType get sortType => _sortType;

  FavoriteProvider() {
    _loadFavorites();
  }

  void _loadFavorites() async {
    var box = await Hive.openBox<Character>('favorite');
    _favorite = box.values.toList();
    sortFavorite();
    notifyListeners();
  }

  void addFavorite(Character character) async {
    var box = await Hive.openBox<Character>('favorite');
    await box.put(character.id, character);
    _favorite = box.values.toList();
    notifyListeners();
    sortFavorite();
  }

  void sortFavorite({SortType? newSortType}) {
    if (newSortType != null) {
      _sortType = newSortType;
    }
    if (_sortType == SortType.name) {
      _favorite.sort((a, b) => a.name.compareTo(b.name));
    } else if (_sortType == SortType.status) {
      _favorite.sort((a, b) => a.status.compareTo(b.status));
    }
    notifyListeners();
  }

  void removeFavorite(int id) async {
    var box = await Hive.openBox<Character>('favorite');
    await box.delete(id);
    _favorite = box.values.toList();
    notifyListeners();
  }
}
