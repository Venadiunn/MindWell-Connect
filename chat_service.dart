import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/chat_message.dart';

/// Service to communicate with OpenRouter API for Lotus Companion chatbot
class ChatService {
  static const String _apiUrl = 'https://openrouter.ai/api/v1/chat/completions';
  static const String _model = 'meta-llama/llama-3.3-8b-instruct:free';
  
  /// Get API key from environment variable or dart-define
  static String? get _apiKey {
    // Hardcoded API key
    return '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';
  }

  /// System prompt that defines the therapeutic personality of Lotus AI
  static const String _systemPrompt = '''
You are a compassionate, thoughtful, and emotionally intelligent conversational therapist. Your goal is to help the user explore their feelings, thoughts, and behaviors in a calm, nonjudgmental way. Ask open-ended questions that encourage reflection and self-awareness rather than giving direct advice. Use empathetic listening — validate the user’s emotions, paraphrase what they share, and gently guide them toward insight. Your tone should be warm, patient, and grounded in psychological understanding, like a licensed therapist. If the user expresses intense distress, focus on calming, grounding, and helping them think of safe next steps, but do not claim to provide medical or crisis intervention. Encourage the user to reach out to a trusted person or professional if they mention being in crisis. Avoid jargon. Speak naturally and conversationally, using short paragraphs and gentle questions that help the user reflect. Your responses should feel supportive, curious, and human.
''';

  /// Send a message to the chatbot and get a response
  Future<String> sendMessage(List<ChatMessage> conversationHistory, String userMessage) async {
    final apiKey = _apiKey;
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('🔑 API Key Missing: OpenRouter API key not configured. Please restart the app with the API key set as an environment variable or dart-define parameter.');
    }

    try {
      // Build messages array with system prompt first
      final messages = [
        {'role': 'system', 'content': _systemPrompt},
        // Add conversation history
        ...conversationHistory.map((msg) => msg.toJson()),
        // Add the new user message
        {'role': 'user', 'content': userMessage},
      ];

      final headers = {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
        'HTTP-Referer': 'https://ftl-mental-health.app',
        'X-Title': 'Lotus AI',
      };

      final body = jsonEncode({
        'model': _model,
        'messages': messages,
      });

      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'] as String;
        return content;
      } else if (response.statusCode == 401) {
        throw Exception('🔑 API Key Invalid: The OpenRouter API key is not valid. Please check your key and try again.');
      } else if (response.statusCode == 429) {
        throw Exception('⏱️ Rate Limited: Too many requests. Please wait a moment and try again.');
      } else if (response.statusCode >= 500) {
        throw Exception('🔧 Server Error: OpenRouter service is temporarily unavailable. Please try again later.');
      } else {
        throw Exception('🌐 API Error (${response.statusCode}): ${response.body}');
      }
    } catch (e) {
      if (e.toString().contains('SocketException') || e.toString().contains('Failed host lookup')) {
        throw Exception('🌐 Network Error: Please check your internet connection and try again.');
      } else if (e.toString().contains('TimeoutException')) {
        throw Exception('⏱️ Timeout: Request took too long. Please try again.');
      } else {
        throw Exception('💫 Unexpected Error: $e');
      }
    }
  }

  /// Get a greeting message when the chat starts
  String getGreeting() {
    return "Howdy, partner! How are you feeling today? 🌸";
  }
}
