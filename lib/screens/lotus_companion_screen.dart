import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../models/chat_message.dart';

/// Lotus Companion chat screen - AI mental health companion
class LotusCompanionScreen extends StatefulWidget {
  const LotusCompanionScreen({super.key});

  @override
  State<LotusCompanionScreen> createState() => _LotusCompanionScreenState();
}

class _LotusCompanionScreenState extends State<LotusCompanionScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Initialize chat with greeting
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChatProvider>().initializeChat();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 300), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      context.read<ChatProvider>().sendMessage(message);
      _messageController.clear();
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Lotus AI'),
            Text(
              'Your friendly mental health companion',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Clear chat',
            onPressed: () {
              context.read<ChatProvider>().clearChat();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Chat messages
          Expanded(
            child: Consumer<ChatProvider>(
              builder: (context, chatProvider, child) {
                if (!chatProvider.hasMessages) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: chatProvider.messages.length,
                  itemBuilder: (context, index) {
                    final message = chatProvider.messages[index];
                    return _MessageBubble(message: message);
                  },
                );
              },
            ),
          ),

          // Loading indicator
          Consumer<ChatProvider>(
            builder: (context, chatProvider, child) {
              if (chatProvider.isLoading) {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      SizedBox(width: 16),
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 12),
                      Text('Lotus is thinking...'),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),

          // Error message
          Consumer<ChatProvider>(
            builder: (context, chatProvider, child) {
              if (chatProvider.error != null) {
                return Container(
                  padding: const EdgeInsets.all(12),
                  color: Colors.red.shade50,
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red.shade700),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          chatProvider.error!,
                          style: TextStyle(color: Colors.red.shade700),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),

          // Quick mood check and action preset buttons
          Consumer<ChatProvider>(
            builder: (context, chatProvider, child) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Mood quick selector
                    const Text(
                      'Quick mood check:',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _MoodButton(
                            emoji: '😊',
                            label: 'Good',
                            onTap: () => chatProvider.sendPresetMessage(
                              'I\'m feeling pretty good today!',
                            ),
                            isDisabled: chatProvider.isLoading,
                          ),
                          const SizedBox(width: 8),
                          _MoodButton(
                            emoji: '😐',
                            label: 'Okay',
                            onTap: () => chatProvider.sendPresetMessage(
                              'I\'m feeling okay, just a regular day.',
                            ),
                            isDisabled: chatProvider.isLoading,
                          ),
                          const SizedBox(width: 8),
                          _MoodButton(
                            emoji: '😟',
                            label: 'Stressed',
                            onTap: () => chatProvider.sendPresetMessage(
                              'I\'m feeling stressed and overwhelmed.',
                            ),
                            isDisabled: chatProvider.isLoading,
                          ),
                          const SizedBox(width: 8),
                          _MoodButton(
                            emoji: '😢',
                            label: 'Sad',
                            onTap: () => chatProvider.sendPresetMessage(
                              'I\'m feeling sad and need some support.',
                            ),
                            isDisabled: chatProvider.isLoading,
                          ),
                          const SizedBox(width: 8),
                          _MoodButton(
                            emoji: '😰',
                            label: 'Anxious',
                            onTap: () => chatProvider.sendPresetMessage(
                              'I\'m feeling anxious and my mind is racing.',
                            ),
                            isDisabled: chatProvider.isLoading,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Quick action buttons
                    const Text(
                      'Or try a quick activity:',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _QuickActionButton(
                            label: 'Practice a 2-min exercise',
                            icon: Icons.self_improvement,
                            onTap: () => chatProvider.sendPresetMessage(
                              'Can you guide me through a quick 2-minute calming exercise?',
                            ),
                            isDisabled: chatProvider.isLoading,
                          ),
                          const SizedBox(width: 8),
                          _QuickActionButton(
                            label: 'Read a short tip',
                            icon: Icons.lightbulb_outline,
                            onTap: () => chatProvider.sendPresetMessage(
                              'Can you share a helpful tip for managing my emotions?',
                            ),
                            isDisabled: chatProvider.isLoading,
                          ),
                          const SizedBox(width: 8),
                          _QuickActionButton(
                            label: 'Find support',
                            icon: Icons.support_agent,
                            onTap: () => chatProvider.sendPresetMessage(
                              'I need help finding additional support resources.',
                            ),
                            isDisabled: chatProvider.isLoading,
                          ),
                          const SizedBox(width: 8),
                          _QuickActionButton(
                            label: 'Journal',
                            icon: Icons.edit_note,
                            onTap: () => chatProvider.sendPresetMessage(
                              'Can you give me a journaling prompt to reflect on my feelings?',
                            ),
                            isDisabled: chatProvider.isLoading,
                          ),
                          const SizedBox(width: 8),
                          _QuickActionButton(
                            label: 'Talk more',
                            icon: Icons.chat_bubble_outline,
                            onTap: () => chatProvider.sendPresetMessage(
                              'I\'d like to talk more about what\'s on my mind.',
                            ),
                            isDisabled: chatProvider.isLoading,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // Message input
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Share how you\'re feeling...',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      maxLines: null,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Consumer<ChatProvider>(
                    builder: (context, chatProvider, child) {
                      return IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: chatProvider.isLoading ? null : _sendMessage,
                        color: Theme.of(context).primaryColor,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget to display a single message bubble
class _MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              backgroundColor: Colors.purple.shade100,
              child: const Text('🌸', style: TextStyle(fontSize: 20)),
            ),
            const SizedBox(width: 12),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUser
                    ? Theme.of(context).primaryColor
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF028d8d), // Gold border
                  width: 1.0,
                ),
              ),
              child: Text(
                message.content,
                style: TextStyle(
                  color: isUser ? Colors.white : Colors.black87,
                  fontSize: 15,
                ),
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 12),
            CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.2),
              child: Icon(
                Icons.person,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Quick action button widget for preset messages
class _QuickActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isDisabled;

  const _QuickActionButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isDisabled ? null : onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isDisabled
                ? Colors.grey.shade200
                : Colors.purple.shade50,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFF028d8d), // Gold border
              width: 1.0,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: isDisabled
                    ? Colors.grey.shade400
                    : Colors.purple.shade700,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: isDisabled
                      ? Colors.grey.shade500
                      : Colors.purple.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Mood button widget for quick mood selection
class _MoodButton extends StatelessWidget {
  final String emoji;
  final String label;
  final VoidCallback onTap;
  final bool isDisabled;

  const _MoodButton({
    required this.emoji,
    required this.label,
    required this.onTap,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isDisabled ? null : onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isDisabled
                ? Colors.grey.shade200
                : Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF028d8d), // Gold border
              width: 1.0,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                emoji,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isDisabled
                      ? Colors.grey.shade500
                      : Colors.blue.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
