import 'package:flutter/material.dart';
import 'package:food_manager/recipe_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({super.key});

  @override
  State<RecipesScreen> createState() => _RecipesScreenState();
}

enum SortBy { name, time }

_launchURLBrowser(String? url) async {
  var _url = Uri.parse(url!);
  if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
    throw Exception('Could not launch $_url');
  }
}

class _RecipesScreenState extends State<RecipesScreen> {
  final TextEditingController _searchKey = TextEditingController();
  List<Recipe> _filteredRecipesList = [];
  SortBy _currentSort = SortBy.name;

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
      _sortItems();
    });
  }

  void _sortItems() {
    _filteredRecipesList.sort((a, b) {
      switch (_currentSort) {
        case SortBy.name:
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        case SortBy.time:
          final aTime = a.time ?? 9999.0;
          final bTime = b.time ?? 9999.0;
          return aTime.compareTo(bTime);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final recipeProvider =  Provider.of<RecipeProvider>(context);
    final allRecipes = recipeProvider.recipes;

    if(_searchKey.text.isEmpty) {
      _filteredRecipesList = List.from(allRecipes);
      _sortItems();
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Row(
          children: [
            Expanded(
              flex: 5, // Adjust the flex if you want more space for the search bar
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xffF5F5F5),
                  borderRadius: BorderRadius.circular(5),
                ),
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
            ),
            const SizedBox(width: 10),
            PopupMenuButton<SortBy>(
              icon: const Icon(Icons.sort),
              onSelected: (SortBy selected) {
                setState(() {
                  _currentSort = selected;
                  _sortItems();
                });
              },
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem(value: SortBy.name, child: Text('Sort by name')),
                const PopupMenuItem(value: SortBy.time, child: Text('Sort by total time')),
              ],
            ),
          ],
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
      child: InkWell(
        onTap: () {
          context.go('/recipes/recipeDetails/${recipe.name}');
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left side: name and servings
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(recipe.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text("Servings: ${recipe.servings}", style: const TextStyle(fontSize: 15)),
                  ],
                ),
              ),

              // Right side: link + cook time
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (recipe.link != null && recipe.link!.trim().isNotEmpty)
                    TextButton(
                      onPressed: () {
                        _launchURLBrowser(recipe.link!);
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text(
                        "Link to recipe",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.lightBlueAccent,
                        ),
                      ),
                    ),
                  const SizedBox(height: 4),
                  Text("Cook time: ${recipe.time ?? "N/A"}", style: const TextStyle(fontSize: 14)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}
