import 'dart:math';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:food_manager/item_provider.dart';
import 'package:food_manager/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key, required this.title});
  final String title;

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final quantityController = TextEditingController();
  final noteController = TextEditingController();
  final nutritionController = TextEditingController();
  final dateController = TextEditingController();

  List<String> nutritionData = [];
  final List<String> units = ['tsp', 'tbsp', 'cup', 'pint', 'quart', 'gallon', 'oz', 'lb', 'pieces'];
  String? selectedUnit;

  void addNutrition() {
    final value = nutritionController.text.trim();
    if (value.isNotEmpty) {
      setState(() {
        nutritionData.add(value);
        nutritionController.clear();
      });
    }
  }

  Future<void> pickDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null) {
      dateController.text = DateFormat('MM/dd/yyyy').format(selectedDate);
    }
  }

  Future<String> add() async {
    final itemProvider = Provider.of<ItemProvider>(context, listen: false);
    double? quantity = double.tryParse(quantityController.text.trim());
    DateTime? date;

    try {
      date = DateFormat('MM/dd/yyyy').parse(dateController.text.trim());
    } catch (_) {
      date = null;
    }

    final item = Item(
      name: nameController.text.trim(),
      quantity: quantity ?? 0.0,
      unit: selectedUnit ?? '',
      note: noteController.text.trim(),
      nutrition: nutritionData,
      expirationDate: date,
    );

    return await itemProvider.addItem(item);
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  String? _validateDate(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    try {
      DateFormat('MM/dd/yyyy').parse(value);
    } catch (_) {
      return 'Invalid date format';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 10),

              // Item Name Field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: TextFormField(
                  controller: nameController,
                  validator: _requiredValidator,
                  decoration: InputDecoration(
                    labelText: 'Item Name',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    prefixIcon: Icon(Icons.inventory)
                  ),
                ),
              ),

              // Quantity and Unit Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: quantityController,
                        validator: _requiredValidator,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Quantity',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                          prefixIcon: const Icon(Icons.scale),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                        width: max(MediaQuery.of(context).size.width * 0.3, 108.0),
                        child: DropdownButtonFormField2(
                          value: selectedUnit,
                          decoration: InputDecoration(
                            labelText: 'Unit',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                            prefixIcon: const Icon(Icons.straighten),
                          ),
                          isExpanded: true,
                          dropdownStyleData: DropdownStyleData(
                            width: max(MediaQuery.of(context).size.width * 0.30, 108.0),
                            maxHeight: MediaQuery.of(context).size.height * 0.3,
                          ),
                          items: units.map((unit) {
                            return DropdownMenuItem(
                              value: unit,
                              child: Text(unit),
                            );
                          }).toList(),
                          onChanged: (value) => setState(() => selectedUnit = value),
                        )
                    ),
                  ],
                ),
              ),

              // Notes Field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: TextFormField(
                  controller: noteController,
                  decoration: InputDecoration(
                    labelText: 'Notes (optional)',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    prefixIcon: Icon(Icons.note_add),
                  ),
                ),
              ),

              // Expiration Date Field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: TextFormField(
                  controller: dateController,
                  validator: _validateDate,
                  onTap: pickDate,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Expiration Date (MM/DD/YYYY)',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    suffixIcon: const Icon(Icons.calendar_today),
                  ),
                ),
              ),

              // Nutrition Info Field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: TextFormField(
                  controller: nutritionController,
                  decoration: InputDecoration(
                    labelText: 'Add Nutrition Info',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: addNutrition,
                    ),
                    prefixIcon: Icon(Icons.monitor_weight)
                  ),
                ),
              ),

              // Nutrition Info List
              if (nutritionData.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    children: [
                      Text(
                        'Nutrition Info:',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      ...nutritionData.asMap().entries.map((entry) {
                        int index = entry.key;
                        String value = entry.value;
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ListTile(
                            title: Text(value),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  nutritionData.removeAt(index);
                                });
                              },
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),

              // Add Item Button
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: FilledButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      String result = await add();
                      if (!context.mounted) return;

                      showDialog(
                        context: context,
                        builder: (BuildContext dialogContext) => AlertDialog(
                          content: Text(result, style: const TextStyle(fontSize: 18)),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(dialogContext),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      );

                      if (result == "Item added successfully") {
                        nameController.clear();
                        quantityController.clear();
                        noteController.clear();
                        dateController.clear();
                        nutritionController.clear();
                        setState(() {
                          selectedUnit = null;
                          nutritionData.clear();
                        });
                      }
                    }
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.buttonBackground,
                    foregroundColor: AppColors.buttonText,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  ),
                  child: const Text("Add Item"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}