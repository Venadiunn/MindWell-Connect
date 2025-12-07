# Won 1st Place in Congressional App Challenge (MO-03)
# MindWell Connect

### **Table of Contents**
- [Project Overview](#project-overview)
- [Technologies Used](#technologies-used)
- [Features](#features)
- [Setup and Installation](#setup-and-installation)
- [Usage Instructions](#usage-instructions)
- [License](#license)

## Project Overview
MindWell Connect is a cross-platform Flutter application designed to make mental-health support more accessible for teens and young adults. The app centralizes hundreds of verified mental-health resources—including crisis lines, youth programs, chat/text services, and education tools—into one easy-to-navigate interface.

In addition to its curated resource library, MindWell Connect includes *Lotus*, an integrated AI companion that guides users toward relevant support options and offers conversational assistance when they’re unsure where to start. The app was created for the Congressional App Challenge to improve clarity, accessibility, and safety in the mental-health resource landscape.

## Technologies Used
- Flutter (Dart)
- Provider (state management)
- Firebase / Firestore (optional integration)
- URL Launcher
- HTTP Package
- Video Player
- OpenRouter / LLM API Integration
- Flutter build tools for iOS, Android, and Web

## Features

### **Resource Library**
- Hundreds of curated, categorized mental-health resources
- Filters by category (crisis, LGBTQ+, youth, education, therapy, etc.)
- Keyword and tag-based search
- One-tap options to call, text, email, or open websites

### **Lotus AI Companion**
- AI-powered conversational assistant
- Helps users identify relevant resources and explore coping strategies
- Designed for supportive guidance—not medical advice

### **Cross-Platform Compatibility**
- Works on iOS, Android, and Web
- Responsive and accessible design

### **Offline-Friendly**
- Resource dataset stored locally inside the app

### **Clean UI**
- Category cards, inviting color palette, structured navigation

## Setup and Installation

Setup and Installation

To set up this project locally:

1. Clone the repository:
    ```
    git clone https://github.com/Venadiunn/MindWell-Connect.git
    ```

3. Navigate to the project directory:
    ```
    cd MindWell-Connect
    ```
4. Install dependencies:
   ```
   flutter pub get
    ```

6. (Optional) Configure AI backend:
Create a config.dart file or use environment variables, then include the following:
    ```
    const String apiKey = "YOUR_API_KEY";
    const String modelEndpoint = "YOUR_ENDPOINT_URL";
    ```

5. Run the app:
   ```
    flutter run
    ```

7. Build for release:

Android:
    ```
    flutter build apk
    ```
iOS:
    ```
    flutter build ios
    ```
Web:
    ```
    flutter build web
    ```

## Usage Instructions
Accessing the App
- Navigate through the home screen to browse categories
- Tap on any resource to view details and launch its contact method
- Use the search bar to filter by name or keyword
- Open the Lotus tab to start an AI-guided conversation

Lotus AI Usage
- Type a question or describe how you’re feeling
- Lotus suggests coping methods, directs you to relevant resources, or helps you find crisis options
- All AI interactions route users to verified help—not clinical diagnoses

Managing Resources
- Resource data is bundled locally in localResources within main.dart
- Developers can add or modify entries by editing the dataset
