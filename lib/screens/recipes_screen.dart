import 'package:flutter/material.dart';
import 'package:food_manager/recipeProvider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({super.key});

  @override
  State<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  final TextEditingController _searchKey = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Recipe> _allRecipesList = [];
  List<Recipe> _filteredRecipesList = [];

  @override
  void initState() {
    super.initState();
    final recipeProvider = Provider.of<RecipeProvider>(context, listen: false);
    _allRecipesList = recipeProvider.recipes;
    _filteredRecipesList = recipeProvider.recipes;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final itemProvider = Provider.of<RecipeProvider>(context, listen: false);
    setState(() {
      _allRecipesList = List.from(itemProvider.recipes);
      _filteredRecipesList = List.from(itemProvider.recipes);
    });
  }

  void _filtersRecipeBySearchTerm(String searchText){
    setState(() {
      _filteredRecipesList = _allRecipesList
          .where((item) =>
          item.name.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                    _searchKey.text = "";
                    _filtersRecipeBySearchTerm("");
                  }),
              hintText: 'Search...',
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 10),
            ),
            onChanged: (value) => _filtersRecipeBySearchTerm(value),
            onSubmitted: (value) => _filtersRecipeBySearchTerm(value),
          ),
        ),
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColorDark,
        ), elevation: 0,
      ),
      body: GestureDetector(
        onTap: () {
          // Prevent the screen from unfocusing when tapping outside
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: _filteredRecipesList.length,
            itemBuilder: (context, index) {
              final recipe = _filteredRecipesList[index];

              return Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  title: Text(recipe.name, style: TextStyle(fontSize: 20)),
                  subtitle: Text("Servings: ${recipe.servings}", style: TextStyle(fontSize: 15)),
                  onTap: () {
                    context.go('/recipes/recipeDetails/${recipe.name}');
                  },
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/recipes/addRecipe'),
        tooltip: 'Add a recipe',
        child: const Icon(Icons.add),
      ), //
    );
  }
}