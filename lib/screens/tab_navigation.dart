import 'package:feastful_fusion/providers/filters_provider.dart';
import 'package:feastful_fusion/screens/categories_screen.dart';
import 'package:feastful_fusion/screens/filters_screen.dart';
import 'package:feastful_fusion/screens/meals_screen.dart';
import 'package:feastful_fusion/widgets/main_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:feastful_fusion/providers/favorite_provider.dart';

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

  void _selectedScreen(int index) {
    setState(() {
      _selectedScreenIndex = index;
    });
  }

  void _setScreen(String indentifier) async {
    Navigator.of(context).pop();
    if (indentifier == "filters") {
      await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          builder: (context) => const FiltersScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableMeals = ref.watch(filteredMealsProvider);

    Widget activeScreen = CategoriesScreen(
      availableMeals: availableMeals,
    );
    var activeScreenTitle = "Categories";

    if (_selectedScreenIndex == 1) {
      final favoriteMeals = ref.watch(favoriteMealsProvider);
      activeScreen = MealsScreen(
        meals: favoriteMeals,
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
