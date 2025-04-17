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
  void initState() {
    super.initState();
    _searchKey.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchKey.removeListener(_onSearchChanged);
    _searchKey.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final searchText = _searchKey.text.toLowerCase();
    final allItems = context.read<RecipeProvider>().recipes;
    setState(() {
      _filteredRecipesList = allItems
          .where((item) => item.name.toLowerCase().contains(searchText))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final recipeProvider =  Provider.of<RecipeProvider>(context);
    final allRecipes = recipeProvider.recipes;

    if(_searchKey.text.isEmpty) {
      _filteredRecipesList = List.from(allRecipes);
    }

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
              prefixIcon: Icon(Icons.search, color: Theme.of(context).primaryColorDark),
              suffixIcon: IconButton(
                icon: Icon(Icons.clear, color: Theme.of(context).primaryColorDark),
                onPressed: () {
                  _searchKey.clear();
                  FocusScope.of(context).unfocus();
                },
              ),
              hintText: 'Search...',
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
        iconTheme: IconThemeData(color: Theme.of(context).primaryColorDark),
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () {
          // Prevent the screen from unfocusing when tapping outside
          FocusScope.of(context).unfocus;
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _filteredRecipesList.isEmpty
              ? const Center(child: Text('No items found.'))
              : ListView.builder(
            itemCount: _filteredRecipesList.length,
            itemBuilder: (context, index) {
              final item = _filteredRecipesList[index];
              return _buildRecipeCard(context, item);
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
