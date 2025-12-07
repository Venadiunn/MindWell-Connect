# Won 1st Place in Congressional App Challenge (MO-03)
# MindWell Connect
Table of Contents

Project Overview

Technologies Used

Features

Setup and Installation

Usage Instructions

License

Project Overview

MindWell Connect is a cross-platform Flutter application designed to make mental-health support more accessible for teens and young adults. The app centralizes hundreds of verified mental-health resources—including crisis lines, youth-specific programs, chat/text services, and educational tools—into one easy-to-navigate interface.

In addition to its curated resource library, MindWell Connect includes Lotus, an integrated AI companion that helps guide users toward relevant support options and offers conversational assistance when users are unsure where to start. The app was created for the Congressional App Challenge with the goal of improving clarity, accessibility, and safety in the mental-health resource landscape.

Technologies Used

Flutter (Dart)

Provider (state management)

Firebase / Firestore (optional backend integration)

URL Launcher

HTTP Package

Video Player

OpenRouter / LLM API Integration (Lotus AI)

Flutter Web, Android, and iOS build tools

Features
Resource Library

Hundreds of curated, categorized mental-health resources bundled directly into the app

Filters by category (crisis, LGBTQ+, youth, education, therapy, etc.)

Search by keyword, tags, or organization name

One-tap actions for calling, texting, emailing, or opening website links

Lotus AI Companion

AI-powered conversational assistant

Helps users explore coping strategies, ask mental-health questions, and locate relevant resources

Designed for supportive guidance—not medical advice

Cross-Platform Compatibility

Runs on iOS, Android, and Web

Responsive design with consistent UI across devices

Offline-Friendly Design

Local resource dataset stored inside the app for quick access even without internet

Clean UI & User-Focused Navigation

Category cards, accessible color palette, and mobile-first design

Embedded onboarding and helpful prompts

Setup and Installation

To run this project locally:

1. Clone the repository
git clone https://github.com/Venadiunn/MindWell-Connect.git

2. Navigate into the project directory
cd MindWell-Connect

3. Install dependencies
flutter pub get

4. (Optional) Configure AI backend

If using Lotus AI with an external LLM API:

Create a config.dart or use environment variables

Add your API endpoint and key, e.g.:

const String apiKey = "YOUR_API_KEY";
const String modelEndpoint = "YOUR_ENDPOINT_URL";

5. Run the app
flutter run

6. Build for release
flutter build apk       # Android  
flutter build ios       # iOS  
flutter build web       # Web

Usage Instructions
Accessing the App

Navigate through the home screen to browse categories

Tap on any resource to view details and launch its contact method

Use the search bar to filter by name or keyword

Open the Lotus tab to start an AI-guided conversation

Lotus AI Usage

Type a question or describe how you’re feeling

Lotus suggests coping methods, directs you to relevant resources, or helps you find crisis options

All AI interactions route users to verified help—not clinical diagnoses

Managing Resources

Resource data is bundled locally in localResources within main.dart

Developers can add or modify entries by editing the dataset

License

This project is licensed under the MIT License — see the LICENSE file for details.
