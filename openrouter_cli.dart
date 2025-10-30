// Simple OpenRouter CLI using only dart:io so it doesn't require package:http
// Usage: set OPENROUTER_API_KEY env var, then run:
// dart run tools/openrouter_cli.dart

// Ignore print lints for this small CLI tool
// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'dart:async';

Future<void> main() async {
  final apiKey = Platform.environment['OPENROUTER_API_KEY'];
  if (apiKey == null || apiKey.trim().isEmpty) {
    stderr.writeln('Error: OPENROUTER_API_KEY environment variable not set.');
    exit(1);
  }

  const apiUrl = 'https://openrouter.ai/api/v1/chat/completions';
  final client = HttpClient();

  try {
    while (true) {
      stdout.write('\nEnter your prompt (or type "exit" to quit): ');
      final userInput = stdin.readLineSync();
      if (userInput == null || userInput.trim().toLowerCase() == 'exit') {
        print('Goodbye!');
        break;
      }

      final body = jsonEncode({
        'model': 'meta-llama/llama-3.3-8b-instruct:free',
        'messages': [
          {'role': 'user', 'content': userInput}
        ],
        'temperature': 0.2,
        'max_tokens': 1024,
      });

      try {
        final uri = Uri.parse(apiUrl);
        final request = await client.postUrl(uri).timeout(const Duration(seconds: 10));
        request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $apiKey');
        request.headers.contentType = ContentType('application', 'json', charset: 'utf-8');
        request.write(body);
        final response = await request.close().timeout(const Duration(seconds: 20));

        final responseBody = await response.transform(utf8.decoder).join();
        if (response.statusCode == 200) {
          try {
            final data = jsonDecode(responseBody);
            final choices = data['choices'];
            if (choices is List && choices.isNotEmpty) {
              final contents = choices.map((c) {
                final msg = c['message'];
                if (msg is Map) return msg['content']?.toString() ?? '';
                return c['message']?.toString() ?? '';
              }).where((s) => s.isNotEmpty).toList();

              print('\n🤖 Response:\n${contents.join('\n\n')}\n');
            } else {
              print('No choices found in response: $responseBody');
            }
          } catch (e) {
            print('Failed to parse JSON response: $e');
            print('Raw response: $responseBody');
          }
        } else {
          print('Error: ${response.statusCode} - $responseBody');
        }
      } on TimeoutException catch (_) {
        print('Request timed out.');
      } catch (e) {
        print('Request failed: $e');
      }
    }
  } finally {
    client.close(force: true);
  }
}
