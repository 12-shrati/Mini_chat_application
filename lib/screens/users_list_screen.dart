import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../config/theme.dart';

class UsersListScreen extends StatefulWidget {
  final ScrollController scrollController;
  final Function(String) onUserTap;

  const UsersListScreen({
    super.key,
    required this.scrollController,
    required this.onUserTap,
  });

  @override
  State<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Consumer<UserProvider>(
          builder: (context, userProvider, _) {
            final users = userProvider.users;

            if (users.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 64,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No users yet',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Add a new user to start chatting',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              controller: widget.scrollController,
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppTheme.primaryColor,
                    child: Text(
                      user.initials,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(user.name),
                  subtitle: const Text('Tap to chat'),
                  onTap: () => widget.onUserTap(user.id),
                );
              },
            );
          },
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            onPressed: _showAddUserDialog,
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  void _showAddUserDialog() {
    final TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New User'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            hintText: 'Enter user name',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                context.read<UserProvider>().addUser(nameController.text);
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('User "${nameController.text}" added'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
