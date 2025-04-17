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
  final unitController = TextEditingController();
  final noteController = TextEditingController();
  final nutritionController = TextEditingController();
  final dateController = TextEditingController();

  List<String> nutritionData = [];

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
      unit: unitController.text.trim(),
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

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    VoidCallback? onTap,
    bool readOnly = false,
    Widget? suffixIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        readOnly: readOnly,
        onTap: onTap,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          suffixIcon: suffixIcon,
        ),
      ),
    );
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
              buildTextField(
                controller: nameController,
                label: 'Item Name',
                validator: _requiredValidator,
              ),
              buildTextField(
                controller: quantityController,
                label: 'Quantity',
                validator: _requiredValidator,
                keyboardType: TextInputType.number,
              ),
              buildTextField(
                controller: unitController,
                label: 'Unit (e.g., kg, L, pieces)',
              ),
              buildTextField(
                controller: noteController,
                label: 'Notes (optional)',
              ),
              buildTextField(
                controller: dateController,
                label: 'Expiration Date (MM/DD/YYYY)',
                validator: _validateDate,
                onTap: pickDate,
                readOnly: true,
                suffixIcon: Icon(Icons.calendar_today),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: TextFormField(
                  controller: nutritionController,
                  decoration: InputDecoration(
                    labelText: 'Add Nutrition Info',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: addNutrition,
                    ),
                  ),
                ),
              ),
              if (nutritionData.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                              icon: Icon(Icons.delete, color: Colors.red),
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
                        unitController.clear();
                        noteController.clear();
                        dateController.clear();
                        nutritionController.clear();
                        setState(() => nutritionData.clear());
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
