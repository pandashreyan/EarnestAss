# Flutter Task App

This is a modern and visually appealing task management application built with Flutter. It provides a seamless user experience for managing tasks, with features like authentication, pagination, search, and filtering.

## Features

- **User Authentication:** Secure user authentication with email and password.
- **Task Management:** Create, view, update, and delete tasks.
- **Modern UI:** A beautiful and intuitive user interface with light and dark themes.
- **Pagination:** Infinite scrolling for the task list, loading tasks on demand.
- **Pull-to-Refresh:** Easily refresh the task list.
- **Search and Filtering:** Quickly find tasks with search and filtering options.
- **Animations:** Smooth animations using Lottie for a more engaging user experience.

## Screenshots

| Light Mode | Dark Mode |
| :---: | :---: |
| ![Light Mode Screenshot](https_www.macstories.net/wp-content/uploads/2019/08/Reminders-on-iOS-13-and-iPadOS-13-Everything-You-Need-to-Know-MacStories-1-1674507119253.jpg) | ![Dark Mode Screenshot](https_9to5mac.com/wp-content/uploads/sites/6/2022/01/reminders-app-redesigned.jpg?quality=82&strip=all&w=1600) |

## Getting Started

To run this project locally, follow these steps:

1.  **Clone the repository:**

    ```bash
    git clone https_github.com/your-username/flutter-task-app.git
    ```

2.  **Install dependencies:**

    ```bash
    flutter pub get
    ```

3.  **Run the app:**

    ```bash
    flutter run
    ```

## Project Structure

The project is organized into the following directories:

-   `lib/models`: Contains the data models for the application.
-   `lib/presentation`: Contains the UI of the application, including screens and widgets.
-   `lib/repository`: Contains the repository for fetching and storing data.
-   `lib/services`: Contains the services for interacting with the backend API.
-   `lib/state`: Contains the state management logic for the application.

## Dependencies

-   `flutter`: The core Flutter framework.
-   `provider`: For state management.
-   `go_router`: For navigation.
-   `http`: For making HTTP requests to the backend API.
-   `flutter_secure_storage`: for securely storing the auth token.
-   `google_fonts`: For custom fonts.
-   `lottie`: For animations.

