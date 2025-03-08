import 'package:hive/hive.dart';
import 'dart:convert';

part 'character.g.dart';

@HiveType(typeId: 0)
class Character {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String status;

  @HiveField(3)
  final String species;

  @HiveField(4)
  final String imageUrl;

  Character({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.imageUrl,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
        id: json['id'],
        name: json['name'],
        status: json['status'],
        species: json['species'],
        imageUrl: json['image']);
  }

  static List<Character> fromJsonList(String jsonStr) {
    final jsonData = json.decode(jsonStr);
    return (jsonData['results'] as List)
        .map((char) => Character.fromJson(char))
        .toList();
  }
}
