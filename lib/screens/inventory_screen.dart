import 'package:flutter/material.dart';
import 'package:food_manager/ItemProvider.dart';
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

  List<Item> _allItemsList = [];
  List<Item> _filteredItemsList = [];

  @override
  void initState() {
    super.initState();
    final itemProvider = Provider.of<ItemProvider>(context, listen: false);
    _allItemsList = itemProvider.items;
    _filteredItemsList = itemProvider.items;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final itemProvider = Provider.of<ItemProvider>(context, listen: false);
    setState(() {
      _allItemsList = List.from(itemProvider.items);
      _filteredItemsList = List.from(itemProvider.items);
    });
  }

  void _filterItemsListBySearchText(String searchText) {
    setState(() {
      _filteredItemsList = _allItemsList
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
            borderRadius: BorderRadius.circular(5),
          ),
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
                  _filterItemsListBySearchText('');
                },
              ),
              hintText: 'Search...',
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 10),
            ),
            onChanged: _filterItemsListBySearchText,
            onSubmitted: _filterItemsListBySearchText,
          ),
        ),
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColorDark,
        ),
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () {
          // Prevent the screen from unfocusing when tapping outside
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
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
            Text(
              "Quantity: ${item.quantity} ${item.unit}",
              style: const TextStyle(fontSize: 15),
            ),
          ],
        ),
        trailing: item.expirationDate != null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.calendar_today, size: 18),
            const SizedBox(height: 4),
            Text(
              DateFormat('MM/dd/yyyy').format(item.expirationDate!),
              style: const TextStyle(fontSize: 15),
            ),
          ],
        )
            : null,
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
            maxHeight: MediaQuery.of(context).size.height * 0.3, // Allow scrolling if content is tall
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
            style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.expand_circle_down_sharp),
          ),
        ),
      ],
    );
  }

  Widget _buildItemDetails(Item item) {
    return Column(
      children: [
        Text("Quantity: ${item.quantity} ${item.unit}", style: TextStyle(fontSize: 16)),
        const SizedBox(height: 10),
        Text("Notes: ${item.note}", style: TextStyle(fontSize: 16)),
        const SizedBox(height: 10),
        Text("Nutrition: ${getNutritionString(item)}", style: TextStyle(fontSize: 16)),
        const SizedBox(height: 20),
      ],
    );
  }

  String getNutritionString(Item item) {
    return item.nutrition.isEmpty ? "N/A" : item.nutrition.join("\n");
  }
}
