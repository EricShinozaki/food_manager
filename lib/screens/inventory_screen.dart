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

    // Update filtered list when search text changes or items change
    if (_searchKey.text.isEmpty) {
      _filteredItemsList = List.from(allItems);
    }

    return Scaffold(
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
        title: Text(item.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        subtitle: Text("Quantity: ${item.quantity} ${item.unit}"),
        trailing: item.expirationDate != null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Expires", style: TextStyle(fontSize: 14)),
            Text(DateFormat('MM/dd/yyyy').format(item.expirationDate!), style: const TextStyle(fontSize: 14)),
          ],
        )
            : const Text("Expires\nN/A", textAlign: TextAlign.center, style: TextStyle(fontSize: 14)),
        onTap: () => _showItemActionsBottomSheet(context, item),
      ),
    );
  }

  void _showItemActionsBottomSheet(BuildContext context, Item item) {
    final itemProvider = Provider.of<ItemProvider>(context, listen: false);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.4,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Wrap(
                children: [
                  ListTile(
                    title: Text(item.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text("Quantity: ${item.quantity} ${item.unit}"),
                        if (item.note.isNotEmpty) Text("Note: ${item.note}"),
                        if (item.expirationDate != null)
                          Text("Expires on: ${DateFormat('MM/dd/yyyy').format(item.expirationDate!)}"),
                      ],
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.add_circle_outline),
                    title: const Text('Add quantity'),
                    onTap: () {
                      Navigator.pop(context);
                      _showAddQuantityDialog(context, item, itemProvider);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.remove_circle_outline),
                    title: const Text('Use item'),
                    onTap: () {
                      Navigator.pop(context);
                      _showUseQuantityDialog(context, item, itemProvider);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.delete),
                    title: const Text('Delete'),
                    onTap: () {
                      Navigator.pop(context);
                      _showDeleteConfirmation(context, item, itemProvider);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


  void _showUseQuantityDialog(BuildContext context, Item item, ItemProvider provider) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Use ${item.name}"),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Enter quantity to use'),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            TextButton(
              onPressed: () {
                final amount = double.tryParse(controller.text);
                String result = "Used $amount ${item.name}";
                if (amount != null && amount > 0 && item.quantity >= amount) {
                  final newQty = (item.quantity - amount).clamp(0, double.infinity);
                  final updatedItem = Item(
                    name: item.name,
                    quantity: newQty.toDouble(),
                    unit: item.unit,
                    note: item.note,
                    expirationDate: item.expirationDate,
                    nutrition: item.nutrition,
                  );
                  provider.updateItem(updatedItem);
                } else {
                  result = "Not enough ${item.name}";
                }
                Navigator.pop(context);
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(result),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
                        ]
                      );
                    },
                );
              },
              child: const Text('Use'),
            ),
          ],
        );
      },
    );
  }

  void _showAddQuantityDialog(BuildContext context, Item item, ItemProvider provider) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add ${item.name}"),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Enter quantity to add'),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            TextButton(
              onPressed: () {
                final amount = double.tryParse(controller.text);
                if (amount != null && amount > 0) {
                  final newQty = (item.quantity + amount).clamp(0, double.infinity);
                  final updatedItem = Item(
                    name: item.name,
                    quantity: newQty.toDouble(),
                    unit: item.unit,
                    note: item.note,
                    expirationDate: item.expirationDate,
                    nutrition: item.nutrition,
                  );
                  provider.updateItem(updatedItem);
                }
                Navigator.pop(context);
              },
              child: const Text('Use'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, Item item, ItemProvider provider) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Item"),
          content: Text("Are you sure you want to delete '${item.name}'?"),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            TextButton(
              onPressed: () {
                provider.removeItem(item.name);
                Navigator.pop(context);
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
