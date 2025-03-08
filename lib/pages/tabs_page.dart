import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/characters_page.dart';
import '../pages/favorite_page.dart';

import '../providers/favorite_provider.dart';
import '../providers/theme_provider.dart';

class TabsPage extends StatefulWidget {
  const TabsPage({super.key});

  @override
  State<TabsPage> createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  final List<Map<String, Object>> _pages = [
    {'page': CharactersPage(), 'title': 'Characters "Rick and Morty"'},
    {'page': FavoritePage(), 'title': 'Favorite characters'},
  ];

  int _selectedIndexPage = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedIndexPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(_pages[_selectedIndexPage]['title'] as String),
        actions: [
          IconButton(
            icon: Icon(
                themeProvider.isDark ? Icons.wb_sunny : Icons.nightlight_round),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
          if (_selectedIndexPage == 1)
            PopupMenuButton<SortType>(
              onSelected: (sortType) {
                favoriteProvider.sortFavorite(newSortType: sortType);
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: SortType.name,
                  child: Text('Sort by name'),
                ),
                PopupMenuItem(
                  value: SortType.status,
                  child: Text('Sort by status'),
                )
              ],
            )
        ],
      ),
      body: _pages[_selectedIndexPage]['page'] as Widget,
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Characters',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorite',
          ),
        ],
        onTap: _selectPage,
        currentIndex: _selectedIndexPage,
      ),
    );
  }
}
