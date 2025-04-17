import 'package:flutter/material.dart';
import 'package:food_manager/item_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final TextEditingController _searchKey = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Item> _filteredItemsList = [];

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
    final allItems = context.read<ItemProvider>().items;

    setState(() {
      _filteredItemsList = allItems
          .where((item) => item.name.toLowerCase().contains(searchText))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final itemProvider = Provider.of<ItemProvider>(context);
    final allItems = itemProvider.items;

    // Update list if search is empty or initial load
    if (_searchKey.text.isEmpty && _filteredItemsList.length != allItems.length) {
      _filteredItemsList = List.from(allItems);
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Container(
          margin: const EdgeInsets.only(right: 30),
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xffF5F5F5),
            borderRadius: BorderRadius.circular(5),
          ),
          child: TextField(
            controller: _searchKey,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search_rounded, color: Theme.of(context).primaryColorDark),
              suffixIcon: IconButton(
                icon: Icon(Icons.clear_rounded, color: Theme.of(context).primaryColorDark),
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
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _filteredItemsList.isEmpty
              ? const Center(child: Text('No items found.'))
              : ListView.builder(
            itemCount: _filteredItemsList.length,
            itemBuilder: (context, index) {
              final item = _filteredItemsList[index];
              return _buildItemCard(context, item);
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/inventory/addItem'),
        tooltip: 'Add item',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildItemCard(BuildContext context, Item item) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        title: Text(
          item.name,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Quantity: ${item.quantity} ${item.unit}", style: const TextStyle(fontSize: 15)),
          ],
        ),
        trailing: item.expirationDate != null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                "Expires",
                style: const TextStyle(fontSize: 14),
            ),
            Text(
              DateFormat('MM/dd/yyyy').format(item.expirationDate!),
              style: const TextStyle(fontSize: 14),
            ),
          ],
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Expires",
              style: const TextStyle(fontSize: 14),
            ),
            Text(
              "N/A",
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
        onTap: () => _showItemDetailsBottomSheet(context, item),
      ),
    );
  }

  void _showItemDetailsBottomSheet(BuildContext context, Item item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      builder: (context) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.35,
          ),
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildItemDetailsHeader(context, item),
                const SizedBox(height: 10),
                _buildItemDetails(item),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildItemDetailsHeader(BuildContext context, Item item) {
    return Row(
      children: [
        Expanded(
          child: Text(
            item.name,
            style: const TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.expand_circle_down_sharp),
          ),
        ),
      ],
    );
  }

  Widget _buildItemDetails(Item item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Quantity: ${item.quantity} ${item.unit}", style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 10),
        Text("Notes: ${item.note}", style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 10),
        Text("Nutrition: ${getNutritionString(item)}", style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  String getNutritionString(Item item) {
    return item.nutrition.isEmpty ? "N/A" : item.nutrition.join(", ");
  }
}
