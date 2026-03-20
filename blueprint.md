# Project Blueprint

This document outlines the structure and features of the Flutter Task App.

## Project Structure

```
.
├── lib
│   ├── main.dart
│   ├── models
│   │   └── task.dart
│   ├── presentation
│   │   └── screens
│   │       ├── home_screen.dart
│   │       ├── login_screen.dart
│   │       ├── register_screen.dart
│   │       ├── splash_screen.dart
│   │       └── task_details_screen.dart
│   ├── repository
│   │   └── task_repository.dart
│   ├── services
│   │   └── api_service.dart
│   ├── state
│   │   ├── auth_provider.dart
│   │   ├── task_provider.dart
│   │   └── theme_provider.dart
│   └── utils
│       └── dialog_helper.dart
├── pubspec.yaml
└── README.md
```

## File Descriptions

### `lib/main.dart`

The main entry point of the application. It initializes the app, sets up the providers for state management (including the theme), configures the light and dark themes, and sets up the `GoRouter` for navigation.

### `lib/models/task.dart`

Defines the `Task` data model.

### `lib/presentation/screens/home_screen.dart`

Displays the list of tasks with a modern, user-friendly interface. It features a `SliverAppBar` with an integrated search bar, a theme toggle, and a redesigned task list. It also includes features like pagination, pull-to-refresh, and filtering.

### `lib/presentation/screens/login_screen.dart`

Provides a user interface for authentication.

### `lib/presentation/screens/register_screen.dart`

Provides a user interface for new users to create an account.

### `lib/presentation/screens/splash_screen.dart`

The initial screen shown on app launch.

### `lib/presentation/screens/task_details_screen.dart`

Allows users to view and edit the details of a specific task. The screen has been redesigned to match the application's new visual style, with themed form fields and buttons.

### `lib/repository/task_repository.dart`

Acts as a bridge between the data source (API service) and the application's state management.

### `lib/services/api_service.dart`

Handles all communication with the backend API, including authentication and task management. It also contains the logic for automatic token refreshing.

### `lib/state/auth_provider.dart`

Manages the application's authentication state, including login, logout, and registration.

### `lib/state/task_provider.dart`

Manages the state of the tasks, including fetching, creating, updating, and deleting tasks. It also handles API errors and displays appropriate dialogs to the user.

### `lib/state/theme_provider.dart`

Manages the application's theme, allowing users to toggle between light and dark modes.

### `lib/utils/dialog_helper.dart`

A utility file that provides a helper function for showing dialogs.

## Implemented Features

### Registration Feature

- **`register_screen.dart`**: A new screen has been created to allow users to register for a new account.
- **Navigation**: The login screen now has a link to the registration screen. The `GoRouter` configuration has been updated to include the `/register` route.
- **State Management**: The `AuthProvider` and `ApiService` have been updated to handle user registration.

### Automatic Token Refresh

- **`api_service.dart`**: The `ApiService` can now automatically refresh the access token when it expires.
- **Error Handling**: The `_handleRequest` method in `api_service.dart` intercepts 401 Unauthorized responses and attempts to refresh the token. If the refresh is successful, the original request is retried. If the refresh fails, the user is logged out.

### Improved Error Handling

- **`dialog_helper.dart`**: A helper function has been created to show consistent dialogs for errors.
- **`task_provider.dart`**: The `TaskProvider` now uses the `dialog_helper.dart` to display dialogs for critical errors, such as "401 Unauthorized" or "500 Internal Server Error", instead of using snackbars.
- **User Feedback**: When a user's session expires and they are logged out, a dialog is displayed to inform them.

### Visual Design and Theming

- **Theming**: The application now has a centralized theme using `ThemeData` and `ColorScheme.fromSeed`. It supports both light and dark modes, and the user can toggle between them.
- **Custom Fonts**: The `google_fonts` package has been used to improve typography.
- **UI Refactoring**: The `home_screen.dart` and `task_details_screen.dart` have been refactored for a more modern and user-friendly design.
- **Home Screen**: Features a `CustomScrollView` with a `SliverAppBar`, an integrated search bar, and a custom `_TaskListItem` widget.
- **Task Details Screen**: The form fields and buttons have been restyled to match the application's theme.

## Next Steps

Here are some suggestions for future enhancements:

-   **Offline Support:** Implement local caching so users can view and edit tasks even when they are offline. Changes can be synced with the server when the connection is restored.
-   **Push Notifications:** Add push notifications to remind users of upcoming task deadlines.
-   **Task Categories/Tags:** Allow users to categorize or tag their tasks for better organization.
-   **Firebase Integration:** Replace the mock API with a real backend using Firebase services like Firestore for the database and Firebase Authentication.
-   **Unit and Widget Testing:** Increase test coverage by writing more unit and widget tests to ensure application stability and reliability.
-   **Accessibility Improvements:** Conduct a thorough accessibility audit and implement improvements to ensure the app is usable by people with a wide range of abilities.
-   **Profile Screen:** Add a screen where users can view and edit their profile information.
