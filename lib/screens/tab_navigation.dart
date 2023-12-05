import 'package:feastful_fusion/models/meal.dart';
import 'package:feastful_fusion/screens/categories_screen.dart';
import 'package:feastful_fusion/screens/filters_screen.dart';
import 'package:feastful_fusion/screens/meals_screen.dart';
import 'package:feastful_fusion/widgets/main_drawer.dart';
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
  final List<Meal> _favoriteMeals = [];

  void _showSnackBarMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _toggleMealFavoritesStatus(Meal meal) {
    final isExisting = _favoriteMeals.contains(meal);

    if (isExisting) {
      setState(() {
        _favoriteMeals.remove(meal);
        _showSnackBarMessage("Meal removed from favorites");
      });
    } else {
      setState(() {
        _favoriteMeals.add(meal);
        _showSnackBarMessage("Meal added to favorites");
      });
    }
  }

  void _selectedScreen(int index) {
    setState(() {
      _selectedScreenIndex = index;
    });
  }

  void _setScreen(String indentifier) {
    Navigator.of(context).pop();
    if(indentifier == "filters") {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const FiltersScreen())
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget activeScreen =
        CategoriesScreen(onToggleFavorite: _toggleMealFavoritesStatus);
    var activeScreenTitle = "Categories";

    if (_selectedScreenIndex == 1) {
      activeScreen = MealsScreen(
        meals: _favoriteMeals,
        onToggleFavorite: _toggleMealFavoritesStatus,
      );
      activeScreenTitle = "Your Favorites";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activeScreenTitle),
      ),
      drawer:  MainDrawer(
        onSelectedScreen: _setScreen,
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
