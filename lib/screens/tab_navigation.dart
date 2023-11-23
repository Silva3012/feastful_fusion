import 'package:feastful_fusion/screens/categories_screen.dart';
import 'package:feastful_fusion/screens/meals_screen.dart';
import 'package:flutter/material.dart';

class TabNavigation extends StatefulWidget {
  const TabNavigation({super.key});

  @override
  State<TabNavigation> createState() {
    return _TabNavigationState();
  }
}

class _TabNavigationState extends State<TabNavigation> {
  int _selectedScreenIndex = 0;

  void _selectedScreen(int index) {
    setState(() {
      _selectedScreenIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activeScreen = const CategoriesScreen();
    var activeScreenTitle = "Categories";

    if (_selectedScreenIndex == 1) {
      activeScreen = const MealsScreen(meals: []);
      activeScreenTitle = "Your Favorites";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activeScreenTitle),
      ),
      body: activeScreen,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectedScreen,
        currentIndex: _selectedScreenIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: "Categories",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: "Favorites",
          ),
        ],
      ),
    );
  }
}
