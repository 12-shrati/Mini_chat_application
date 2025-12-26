# mini_chat

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
# Mini Chat - Flutter Application

A modern Flutter chat application demonstrating best practices in UI/UX, error handling, code architecture, and comprehensive testing.

## Features ✨

- **Multi-User Chat**: Chat with multiple users with separate message histories
- **Message Management**: Send and receive messages with real-time UI updates
- **Chat History**: Track conversation history with timestamps
- **Word Definitions**: Long-press on messages to look up word definitions
- **Tab Navigation**: Switch between users list and chat history
- **Responsive Design**: Works seamlessly on portrait and landscape orientations
- **Error Handling**: Graceful error states with user-friendly messages
- **Material Design 3**: Modern UI using Material 3 design system

## Architecture 🏗️

The application follows a clean architecture pattern with clear separation of concerns:

```
UI (Screens) 
    ↓
State Management (Providers)
    ↓
Data Access (Repositories)
    ↓
External Services (ApiService)
```

### Key Components

- **Models**: Data classes (User, Message, ChatSession)
- **Services**: External API integration (ApiService)
- **Providers**: State management using Provider pattern
- **Screens**: UI implementation with error handling
- **Config**: Constants and theme configuration

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── config/                      # Configuration
│   ├── constants.dart           # App constants
│   └── theme.dart              # Theme configuration
├── models/                      # Data models
│   ├── user.dart
│   ├── message.dart
│   ├── chat_session.dart
│   └── exceptions.dart          # Custom exceptions
├── services/                    # External services
│   └── api_service.dart
├── repositories/                # Data access layer
│   ├── user_repository.dart
│   ├── message_repository.dart
│   └── chat_repository.dart
├── providers/                   # State management
│   ├── user_provider.dart
│   ├── message_provider.dart
│   └── chat_history_provider.dart
├── screens/                     # UI Screens
│   ├── home_screen.dart
│   ├── chat_screen.dart
│   ├── users_list_screen.dart
│   └── chat_history_screen.dart
├── widgets/                     # Reusable widgets
│   └── reusable_widgets.dart
└── utils/                       # Utilities
    └── formatters.dart
```

## Getting Started 🚀

### Prerequisites
- Flutter >= 3.6.0
- Dart >= 3.6.0

### Installation

1. Clone the repository
```bash
git clone <repository-url>
cd mini_chat
```

2. Install dependencies
```bash
flutter pub get
```

3. Run the app
```bash
flutter run
```

## Testing 🧪

The application includes comprehensive tests for all components.

### Run Tests
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/unit/models/user_test.dart

# Run with coverage
flutter test --coverage
```

### Test Coverage
- **Unit Tests**: 50+ tests covering models, providers, and services
- **Widget Tests**: Testing UI components and interactions
- **Integration Tests**: Testing complete user flows

## Skills Assessment 📊

### ✅ Meeting UI/UX Expectations
- Material Design 3 implementation
- Responsive layout for multiple orientations
- Smooth animations and transitions
- Proper loading and error states
- Empty state placeholders
- Visual feedback for user actions

### ✅ Gracefully Handling Errors & Failed States
- Custom exception types for different error scenarios
- User-friendly error messages
- Retry mechanisms for failed operations
- Proper error state display in UI
- Loading indicators for async operations
- Error recovery workflows

### ✅ Understanding Requirements
- Multi-user chat functionality
- Message persistence during session
- Chat history tracking
- Dictionary integration for word definitions
- Tab-based navigation
- API integration with real services

### ✅ Code Architecture
- Clean separation of concerns
- Provider pattern for state management
- Custom exceptions for error handling
- Configuration management (constants, theme)
- SOLID principles adherence

### ✅ Testing (Brownie Points!)
- 50 unit, intigration tests for core components
- Test coverage for models, providers, and services
- Widget tests for UI components.
- Integration tests for user flows.
- Mock-friendly architecture
- Easy to test implementations

## Error Handling Strategy 🛡️

The application implements a robust error handling strategy across all layers:

### 1. Error Recovery
- Automatic retry for failed API calls
- User-friendly error messages
- Retry buttons in error states
- Graceful degradation

### 2. Error Display
- Toast/Snackbar notifications
- Modal dialogs for critical errors
- Banner notifications for warnings
- Clear error messaging

## Dependencies 📦

### Core
- `flutter`: UI framework
- `provider`: State management
- `http`: HTTP requests
- `uuid`: Unique identifiers
- `intl`: Internationalization
- `cupertino_icons`: iOS-style icons

### Development
- `flutter_test`: Testing framework
- `flutter_lints`: Code quality
- `mockito`: Mocking for tests
- `build_runner`: Code generation

## Configuration 🔧

### API Endpoints
- **Messages API**: `https://jsonplaceholder.typicode.com`
- **Dictionary API**: `https://api.dictionaryapi.dev/api/v2/entries/en`

### Timeouts
- API request timeout: 10 seconds
- Animation duration: 300ms

See `lib/config/constants.dart` for all configuration options.

## Best Practices Implemented ✓

- ✅ Separation of concerns (Models, Services, Providers, Screens)
- ✅ DRY principle (constants)
- ✅ State management (Provider pattern, clear state flow)
- ✅ Code organization (Logical folder structure)
- ✅ Type safety (Strong typing, null safety)
- ✅ Testing (Unit tests with good coverage)
- ✅ Documentation (ReadME)
---

**Last Updated**: December 26, 2025
