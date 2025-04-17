import 'package:flutter/material.dart';
import 'package:food_manager/recipe_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({super.key});

  @override
  State<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  final TextEditingController _searchKey = TextEditingController();
  List<Recipe> _filteredRecipesList = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize the filtered list only once when the screen is loaded
    final recipeProvider = Provider.of<RecipeProvider>(context, listen: false);
    setState(() {
      _filteredRecipesList = List.from(recipeProvider.recipes);
    });
  }

  void _filtersRecipeBySearchTerm(String searchText) {
    // Only filter the list when necessary and directly modify the filtered list
    final recipeProvider = Provider.of<RecipeProvider>(context, listen: false);
    setState(() {
      _filteredRecipesList = recipeProvider.recipes
          .where((recipe) =>
          recipe.name.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Container(
          margin: const EdgeInsets.only(right: 30),
          height: 40,
          decoration: BoxDecoration(
              color: const Color(0xffF5F5F5),
              borderRadius: BorderRadius.circular(5)),
          child: TextField(
            controller: _searchKey,
            decoration: InputDecoration(
              prefixIcon: IconButton(
                icon: Icon(
                  Icons.search_rounded,
                  color: Theme.of(context).primaryColorDark,
                ),
                onPressed: () => FocusScope.of(context).unfocus(),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.clear_rounded,
                  color: Theme.of(context).primaryColorDark,
                ),
                onPressed: () {
                  _searchKey.clear();
                  _filtersRecipeBySearchTerm("");  // Clear the search
                },
              ),
              hintText: 'Search...',
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 10),
            ),
            onChanged: _filtersRecipeBySearchTerm,
          ),
        ),
        iconTheme: IconThemeData(color: Theme.of(context).primaryColorDark),
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () {
          // Prevent the screen from unfocusing when tapping outside
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Consumer<RecipeProvider>(
            builder: (context, recipeProvider, child) {
              // When no recipes match, show a message
              if (_filteredRecipesList.isEmpty) {
                return const Center(child: Text('No recipes found.'));
              }
              return ListView.builder(
                itemCount: _filteredRecipesList.length,
                itemBuilder: (context, index) {
                  final recipe = _filteredRecipesList[index];
                  return _buildRecipeCard(context, recipe);
                },
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/recipes/addRecipe'),
        tooltip: 'Add a recipe',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildRecipeCard(BuildContext context, Recipe recipe) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        title: Text(recipe.name, style: const TextStyle(fontSize: 20)),
        subtitle: Text("Servings: ${recipe.servings}", style: const TextStyle(fontSize: 15)),
        onTap: () {
          context.go('/recipes/recipeDetails/${recipe.name}');
        },
        trailing: IconButton(
          onPressed: () {
            context.go('/recipes/editRecipe');
            },
          icon: Icon(Icons.edit),
        ),
      )
    );
  }
}
