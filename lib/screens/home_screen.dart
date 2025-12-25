import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../config/constants.dart';
import 'users_list_screen.dart';
import 'chat_history_screen.dart';
import 'chat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _usersScrollController;
  late ScrollController _historyScrollController;
  bool _showSwitcher = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _usersScrollController = ScrollController();
    _historyScrollController = ScrollController();

    // Listen to tab changes to switch scroll controllers
    _tabController.addListener(() {
      setState(() {});
    });

    // Listen to scroll events
    _usersScrollController.addListener(_handleScroll);
    _historyScrollController.addListener(_handleScroll);
  }

// Handle scroll to show/hide tab switcher
  void _handleScroll() {
    final scrollController = _tabController.index == 0
        ? _usersScrollController
        : _historyScrollController;

    if (scrollController.position.pixels > 0 && _showSwitcher) {
      setState(() {
        _showSwitcher = false;
      });
    } else if (scrollController.position.pixels <= 0 && !_showSwitcher) {
      setState(() {
        _showSwitcher = true;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _usersScrollController.dispose();
    _historyScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AnimatedOpacity(
          opacity: _showSwitcher ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 200),
          child: _buildTabSwitcher(),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          UsersListScreen(
            scrollController: _usersScrollController,
            onUserTap: _navigateToChat,
          ),
          ChatHistoryScreen(
            scrollController: _historyScrollController,
            onChatTap: _navigateToChat,
          ),
        ],
      ),
    );
  }

// Build the tab switcher widget
  Widget _buildTabSwitcher() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius:
            BorderRadius.circular(AppConstants.messageBubbleBorderRadius),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSwitcherButton('Users', 0),
          _buildSwitcherButton('Chat History', 1),
        ],
      ),
    );
  }

// Build individual switcher button
  Widget _buildSwitcherButton(String label, int index) {
    final isSelected = _tabController.index == index;
    return GestureDetector(
      onTap: () {
        _tabController.animateTo(index);
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.deepPurple : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black54,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

// Navigate to chat screen
  void _navigateToChat(String userId) {
    final user = context.read<UserProvider>().getUserById(userId);
    if (user != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ChatScreen(userId: userId, userName: user.name),
        ),
      );
    }
  }
}
