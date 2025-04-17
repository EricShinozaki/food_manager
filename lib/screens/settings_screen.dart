import 'package:flutter/material.dart';
import 'package:food_manager/item_provider.dart';
import 'package:food_manager/recipe_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, required this.title});
  final String title;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  var syncString = "Sync Data";

  Future<void> _showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String content,
    required String confirmText,
    required VoidCallback onConfirm,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(confirmText),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      onConfirm();
    }
  }

  Future<void> _syncData() async {
    try {
      await Provider.of<ItemProvider>(context, listen: false).fetchItems();
      await Provider.of<RecipeProvider>(context, listen: false).fetchRecipes();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to sync data: ${e.toString()}")),
      );
    }
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (context.mounted) context.go('/login');
  }

  Future<void> _deleteAccount() async {
    try {
      await FirebaseAuth.instance.currentUser?.delete();
      if (context.mounted) context.go('/login');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete account: ${e.toString()}")),
      );
    }
  }

  void _changeTheme() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Theme setting not implemented")),
    );
  }

  Widget _buildSettingsButton(String label, VoidCallback onPressed) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange.shade600, Colors.red.shade400],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: SizedBox(
        width: double.infinity,
        child: FilledButton.tonal(
          onPressed: onPressed,
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(Colors.transparent),
            shadowColor: WidgetStateProperty.all(Colors.transparent),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          ),
          child: Text(
            label,
            style: const TextStyle(fontSize: 18, color: Colors.black),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> buttons) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 30),
        Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ...buttons,
      ],
    );
  }

  Widget _buildAccountHeader(String email) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 24,
              backgroundColor: Colors.deepOrange,
              child: Icon(Icons.person, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Logged in as",
                      style: TextStyle(fontSize: 14, color: Colors.grey)),
                  Text(
                    email,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Change Password"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: currentPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Current Password'),
                ),
                TextField(
                  controller: newPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'New Password'),
                ),
                TextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Confirm New Password'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                final currentPassword = currentPasswordController.text;
                final newPassword = newPasswordController.text;
                final confirmPassword = confirmPasswordController.text;

                if (newPassword != confirmPassword) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("New passwords do not match")),
                  );
                  return;
                }

                try {
                  final user = FirebaseAuth.instance.currentUser;
                  if (user?.email == null) throw Exception("User email not found");

                  final cred = EmailAuthProvider.credential(
                    email: user!.email!,
                    password: currentPassword,
                  );

                  await user.reauthenticateWithCredential(cred);
                  await user.updatePassword(newPassword);
                  Navigator.pop(context); // Close dialog

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Password updated successfully")),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Failed to update password: ${e.toString()}")),
                  );
                }
              },
              child: const Text("Change"),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final scaffoldContext = context;
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? "No email available";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildAccountHeader(email),
            _buildSection("Account", [
              _buildSettingsButton(syncString, () {
                _showConfirmationDialog(
                  context: scaffoldContext,
                  title: "Confirm Sync",
                  content: "Are you sure you want to sync data?",
                  confirmText: "Sync",
                  onConfirm: _syncData,
                );
              }),
              _buildSettingsButton("Logout", () {
                _showConfirmationDialog(
                  context: scaffoldContext,
                  title: "Confirm Logout",
                  content: "Are you sure you want to log out?",
                  confirmText: "Logout",
                  onConfirm: _logout,
                );
              }),
              _buildSettingsButton("Change Password", () {
                _showChangePasswordDialog(context);
              }),
              _buildSettingsButton("Delete Account", () {
                _showConfirmationDialog(
                  context: scaffoldContext,
                  title: "Delete Account",
                  content: "This action is permanent. Are you sure?",
                  confirmText: "Delete",
                  onConfirm: _deleteAccount,
                );
              }),
            ]),
            _buildSection("Appearance", [
              _buildSettingsButton("Change Theme", _changeTheme),
            ]),
          ],
        ),
      ),
    );
  }
}
