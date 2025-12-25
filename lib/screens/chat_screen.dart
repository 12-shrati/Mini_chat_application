import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/message_provider.dart';
import '../providers/chat_history_provider.dart';
import '../providers/user_provider.dart';
import '../models/message.dart';
import '../services/api_service.dart';
import '../config/theme.dart';
import '../config/constants.dart';

class ChatScreen extends StatefulWidget {
  final String userId;
  final String userName;

  const ChatScreen({
    super.key,
    required this.userId,
    required this.userName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ApiService _apiService = ApiService();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage(MessageProvider messageProvider,
      ChatHistoryProvider chatHistoryProvider) async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    // Add sender message
    messageProvider.addSenderMessage(widget.userId, text);
    _messageController.clear();
    chatHistoryProvider.updateChatSession(
      userId: widget.userId,
      userName: widget.userName,
      lastMessage: text,
    );

    _scrollToBottom();

    // Fetch and add receiver message
    await messageProvider.addReceiverMessage(widget.userId);

    // Get the last message if available
    final messages = messageProvider.getMessagesByUserId(widget.userId);
    if (messages.isNotEmpty) {
      final lastMessage = messages.last.text;
      chatHistoryProvider.updateChatSession(
        userId: widget.userId,
        userName: widget.userName,
        lastMessage: lastMessage,
      );
    }

    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: AppConstants.scrollAnimationDuration,
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userName),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: AppTheme.senderTextColor,
      ),
      body: Consumer<MessageProvider>(
        builder: (context, messageProvider, _) {
          final messages = messageProvider.getMessagesByUserId(widget.userId);
          final userProvider = context.read<UserProvider>();
          final user = userProvider.getUserById(widget.userId);

          return Column(
            children: [
              Expanded(
                child: messages.isEmpty
                    ? Center(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.chat_bubble_outline,
                                size: 64,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No messages yet',
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Start a conversation',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Colors.grey.shade600,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        itemCount: messages.length,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          return _buildMessageBubble(message, user);
                        },
                      ),
              ),
              if (messageProvider.isLoading)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                    ),
                  ),
                ),
              if (messageProvider.error != null)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.red.shade100,
                    child: Row(
                      children: [
                        Icon(Icons.error, color: Colors.red.shade700),
                        const SizedBox(width: 8),
                        Text(
                          messageProvider.error!,
                          style: TextStyle(color: Colors.red.shade700),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () =>
                              messageProvider.clearMessages(widget.userId),
                        ),
                      ],
                    ),
                  ),
                ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: _buildMessageInput(messageProvider),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMessageBubble(Message message, user) {
    final userInitials = user?.initials ?? 'U';
    const senderInitials = 'Y'; // Y for "You"

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment:
            message.isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isSender) ...[
            CircleAvatar(
              backgroundColor: AppTheme.accentColor,
              radius: 18,
              child: Text(
                userInitials,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: GestureDetector(
              onLongPress: () => _showWordDefinitionSheet(message.text),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: message.isSender
                      ? AppTheme.senderMessageColor
                      : AppTheme.receiverMessageColor,
                  borderRadius: BorderRadius.circular(
                      AppConstants.messageBubbleBorderRadius),
                ),
                child: Column(
                  crossAxisAlignment: message.isSender
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Text(
                      message.text,
                      style: TextStyle(
                        color: message.isSender
                            ? AppTheme.senderTextColor
                            : AppTheme.receiverTextColor,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message.formattedTime,
                      style: TextStyle(
                        color:
                            message.isSender ? Colors.white70 : Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (message.isSender) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: AppTheme.primaryColor,
              radius: 18,
              child: const Text(
                senderInitials,
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ],
        ],
      ),
    );
  }

// Build the message input area
  Widget _buildMessageInput(MessageProvider messageProvider) {
    final chatHistoryProvider = context.read<ChatHistoryProvider>();
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: isLandscape
          ? _buildLandscapeMessageInput(messageProvider, chatHistoryProvider)
          : _buildPortraitMessageInput(messageProvider, chatHistoryProvider),
    );
  }

  Widget _buildPortraitMessageInput(MessageProvider messageProvider,
      ChatHistoryProvider chatHistoryProvider) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: TextField(
            controller: _messageController,
            decoration: InputDecoration(
              hintText: 'Type a message...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              isDense: true,
            ),
            minLines: 1,
            maxLines: 3,
            onChanged: (value) {
              setState(() {});
            },
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          height: 48,
          width: 48,
          child: FloatingActionButton(
            mini: true,
            onPressed: messageProvider.isLoading
                ? null
                : () => _sendMessage(messageProvider, chatHistoryProvider),
            backgroundColor:
                messageProvider.isLoading ? Colors.grey : Colors.deepPurple,
            child: const Icon(Icons.send, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildLandscapeMessageInput(MessageProvider messageProvider,
      ChatHistoryProvider chatHistoryProvider) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.15,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 100,
              ),
              child: SingleChildScrollView(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Type a message...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    isDense: true,
                  ),
                  minLines: 1,
                  maxLines: 3,
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            height: 48,
            width: 48,
            child: FloatingActionButton(
              mini: true,
              onPressed: messageProvider.isLoading
                  ? null
                  : () => _sendMessage(messageProvider, chatHistoryProvider),
              backgroundColor: messageProvider.isLoading
                  ? Colors.grey
                  : AppTheme.primaryColor,
              child: const Icon(Icons.send, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  void _showWordDefinitionSheet(String messageText) {
    // Extract words from message
    final words = messageText.split(RegExp(r'\s+|[,\.!?;:]'));
    final cleanWords =
        words.where((w) => w.isNotEmpty && w.length > 2).toList();

    if (cleanWords.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No words to look up')),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      builder: (context) => WordSelectionSheet(
        words: cleanWords,
        onWordSelected: _showDefinition,
      ),
    );
  }

  void _showDefinition(String word) async {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Definition: $word'),
        content: FutureBuilder<String>(
          future: _apiService.getWordDefinition(word),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            return SingleChildScrollView(
              child: Text(snapshot.data ?? 'Definition not found'),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class WordSelectionSheet extends StatelessWidget {
  final List<String> words;
  final Function(String) onWordSelected;

  const WordSelectionSheet({
    super.key,
    required this.words,
    required this.onWordSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select a word to see definition:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: words.map((word) {
              return ActionChip(
                label: Text(word),
                onPressed: () => onWordSelected(word),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
