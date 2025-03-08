import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/characters_provider.dart';
import '../widgets/character_card.dart';

class CharactersPage extends StatefulWidget {
  const CharactersPage({super.key});
  static const routeName = '/characters';

  @override
  State<CharactersPage> createState() => _CharactersPageState();
}

class _CharactersPageState extends State<CharactersPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isFetching = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isFetching) {
      _isFetching = true;
      Provider.of<CharactersProvider>(context, listen: false)
          .fetchCharacters()
          .then((_) {
        _isFetching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final charactersData = Provider.of<CharactersProvider>(context);
    final characters = charactersData.characters;

    return charactersData.isLoading && characters.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            controller: _scrollController,
            itemCount: characters.length + (charactersData.isLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == characters.length && charactersData.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return CharacterCard(character: characters[index]);
            },
          );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}