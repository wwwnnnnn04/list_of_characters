import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../models/character.dart';

class CharactersProvider with ChangeNotifier {
  List<Character> _characters = [];
  List<Character> get characters => [..._characters];

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int _currentPage = 1;

  CharactersProvider() {
    _loadFromCache();
    fetchCharacters();
  }

  Future<void> _saveToCache() async {
    var box = await Hive.openBox<Character>('characters');
    await box.clear();
    final charactersCopy = List<Character>.from(_characters);
    for (var character in charactersCopy) {
      await box.put(character.id, character);
    }
  }

  Future<void> _loadFromCache() async {
    var box = await Hive.openBox<Character>('characters');
    _characters = box.values.toList();
    notifyListeners();
  }

  Future<void> fetchCharacters() async {
    if (_isLoading) return; 

    _isLoading = true; 
    notifyListeners();

    final url = Uri.parse(
        'https://rickandmortyapi.com/api/character?page=$_currentPage');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<Character> newCharacters =
            Character.fromJsonList(response.body);
        _characters.addAll(newCharacters);
        _currentPage++;
        await _saveToCache();
      } else {
        throw Exception('Ошибка загрузки данных');
      }
    } catch (error) {
      print('Ошибка: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}