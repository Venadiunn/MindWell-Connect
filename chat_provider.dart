import 'package:flutter/foundation.dart';
import '../models/chat_message.dart';
import '../services/chat_service.dart';

/// Provider to manage chat state and conversation with Lotus Companion
class ChatProvider extends ChangeNotifier {
  final ChatService _chatService = ChatService();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  String? _error;

  List<ChatMessage> get messages => List.unmodifiable(_messages);
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasMessages => _messages.isNotEmpty;

  /// Initialize chat with greeting message
  void initializeChat() {
    if (_messages.isEmpty) {
      _messages.add(
        ChatMessage(
          role: 'assistant',
          content: _chatService.getGreeting(),
        ),
      );
      notifyListeners();
    }
  }

  /// Send a user message and get AI response
  Future<void> sendMessage(String userMessage) async {
    if (userMessage.trim().isEmpty) return;

    _error = null;

    // Add user message
    final userMsg = ChatMessage(
      role: 'user',
      content: userMessage,
    );
    _messages.add(userMsg);
    notifyListeners();

    // Set loading state
    _isLoading = true;
    notifyListeners();

    try {
      // Pass all conversation history except the initial greeting
      final conversationHistory = _messages.length > 1
          ? _messages.sublist(1, _messages.length - 1) // Exclude greeting and current message
          : <ChatMessage>[];
      
      // Get AI response with full conversation context
      final response = await _chatService.sendMessage(
        conversationHistory,
        userMessage,
      );

      // Add assistant response
      _messages.add(
        ChatMessage(
          role: 'assistant',
          content: response,
        ),
      );
    } catch (e) {
      // Provide more specific error messages based on the error type
      final String errorMessage = e.toString();
      if (errorMessage.contains('🔑 API Key Missing')) {
        _error = '🔑 Setup Required: Please restart the app with the OpenRouter API key configured.';
      } else if (errorMessage.contains('🔑 API Key Invalid')) {
        _error = '🔑 Invalid Key: Please check your OpenRouter API key and restart the app.';
      } else if (errorMessage.contains('🌐 Network Error')) {
        _error = '🌐 No Internet: Please check your connection and try again.';
      } else if (errorMessage.contains('⏱️')) {
        _error = '⏱️ Timeout: Please try again in a moment.';
      } else if (errorMessage.contains('💫 Unexpected Error')) {
        _error = 'Sorry, I encountered an unexpected error. Please try again.';
      } else {
        _error = 'Sorry, I encountered an error. Please try again.';
      }
      debugPrint('Chat error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear the chat history
  void clearChat() {
    _messages.clear();
    _error = null;
    initializeChat();
  }

  /// Send a preset quick action message
  Future<void> sendPresetMessage(String presetMessage) async {
    await sendMessage(presetMessage);
  }
}
