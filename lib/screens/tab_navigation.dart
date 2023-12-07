import 'package:feastful_fusion/data/dummy_data.dart';
import 'package:feastful_fusion/models/meal.dart';
import 'package:feastful_fusion/screens/categories_screen.dart';
import 'package:feastful_fusion/screens/filters_screen.dart';
import 'package:feastful_fusion/screens/meals_screen.dart';
import 'package:feastful_fusion/widgets/main_drawer.dart';
import 'package:flutter/material.dart';

const kInitialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegetarian: false,
  Filter.vegan: false,
};

class TabNavigation extends ConsumerStatefulWidget {
  const TabNavigation({super.key});

  @override
  ConsumerState<TabNavigation> createState() {
    return _TabNavigationState();
  }
}

class _TabNavigationState extends ConsumerState<TabNavigation> {
  int _selectedScreenIndex = 0;
  final List<Meal> _favoriteMeals = [];
  Map<Filter, bool> _selectedFilters = kInitialFilters;

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

  void _setScreen(String indentifier) async {
    Navigator.of(context).pop();
    if (indentifier == "filters") {
      final result = await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          builder: (context) => FiltersScreen(
            currentFilters: _selectedFilters,
          ),
        ),
      );

      setState(() {
        _selectedFilters = result ?? kInitialFilters;
        print(result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableMeals = dummyMeals.where((meal) {
      if (_selectedFilters[Filter.glutenFree]! && !meal.isGlutenFree) {
        return false;
      }
      if (_selectedFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
        return false;
      }
      if (_selectedFilters[Filter.vegetarian]! && !meal.isVegetarian) {
        return false;
      }
      if (_selectedFilters[Filter.vegan]! && !meal.isVegan) {
        return false;
      }
      return true;
    }).toList();
    
    Widget activeScreen =
        CategoriesScreen(onToggleFavorite: _toggleMealFavoritesStatus, availableMeals: availableMeals,);
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
      drawer: MainDrawer(
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
