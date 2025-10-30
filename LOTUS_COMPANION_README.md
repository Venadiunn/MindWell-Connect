# Lotus Companion - AI Mental Health Chatbot

## Overview
Lotus Companion is an AI-powered conversational therapist integrated into your mental health app. It uses OpenRouter's API with Meta's Llama 3.3 model to provide compassionate, thoughtful mental health support.

## Features
✅ **Therapeutic Conversations** - Uses a carefully crafted system prompt to act as a compassionate therapist
✅ **Empathetic Listening** - Validates emotions and provides gentle guidance
✅ **Crisis Awareness** - Encourages users to seek professional help when needed
✅ **Beautiful UI** - Modern chat interface with message bubbles
✅ **Real-time Responses** - Streaming responses from the AI
✅ **Conversation History** - Maintains context throughout the chat session

## Files Created

### Models
- `lib/models/chat_message.dart` - Message model for user/assistant messages

### Services
- `lib/services/chat_service.dart` - Handles API communication with OpenRouter
  - Contains therapeutic system prompt
  - Manages conversation history
  - Returns AI responses

### Providers
- `lib/providers/chat_provider.dart` - State management for chat
  - Manages message list
  - Handles loading states
  - Error handling

### Screens
- `lib/screens/lotus_companion_screen.dart` - Chat UI
  - Message list with bubbles
  - Text input field
  - Loading indicators
  - Clear chat option

### Updates
- `lib/main.dart` - Updated to include:
  - ChatProvider in MultiProvider
  - Lotus Companion card on home screen
  - Navigation to chat screen

- `pubspec.yaml` - Added `http: ^1.1.0` package

## How to Run

1. **Install dependencies:**
   ```bash
   flutter pub get
   ```

2. **Run the app:**
   ```bash
   flutter run
   ```

3. **Access Lotus Companion:**
   - Open the app
   - Tap the purple "Lotus Companion" card on the home screen
   - Start chatting!

## System Prompt
The AI is configured with a therapeutic personality that:
- Asks open-ended questions for reflection
- Validates emotions empathetically
- Provides micro-skills (breathing, grounding, reframing)
- Suggests resources when appropriate
- Encourages professional help for crisis situations
- Keeps responses brief and conversational

## API Configuration
- **Provider:** OpenRouter
- **Model:** meta-llama/llama-3.3-8b-instruct:free
- **API Key:** Configured in `chat_service.dart`

## Security Note
⚠️ The API key is currently hardcoded in the service. For production:
- Move API key to environment variables
- Use Flutter's `--dart-define` for secrets
- Consider using a backend proxy to hide the key

## Customization

### Change Greeting
Edit `ChatService.getGreeting()` in `lib/services/chat_service.dart`

### Modify System Prompt
Update `_systemPrompt` in `lib/services/chat_service.dart`

### Change Model
Update `_model` constant in `lib/services/chat_service.dart`

### Styling
Modify colors and styling in `lotus_companion_screen.dart`

## Future Enhancements
- [ ] Save conversation history locally
- [ ] Export chat transcripts
- [ ] Mood tracking integration
- [ ] Crisis detection and resource suggestions
- [ ] Voice input/output
- [ ] Multi-language support

## Testing
Test the chatbot by:
1. Starting a conversation
2. Sharing feelings/thoughts
3. Asking questions
4. Testing the clear chat function
5. Verifying error handling (disconnect internet)

Enjoy your new AI companion! 🌸
