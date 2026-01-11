# DevPaul Player 🎵

A professional, high-performance Android music player built with **Flutter**, designed to demonstrate the pinnacle of **Clean Architecture**, **SOLID principles**, and **Modular Design**. This project serves as a reference implementation for scalable, maintainable, and testable mobile applications.

## 🚀 Features

-   **Local Audio Playback**: Scans and plays audio files directly from the device storage.
-   **Background Playback**: Seamless audio experience even when the app is minimized or the screen is off.
-   **Playlist Management**: Create, view, and manage custom playlists.
-   **Mini Player**: Persistent playback controls accessible across the application.
-   **Smart Navigation**: Modular navigation with a persistent bottom bar for easy access to Songs and Playlists.
-   **Robust Error Handling**: User-friendly error messages and graceful failure recovery.

## 🏗 Architecture

This project strictly adheres to **Clean Architecture** principles, ensuring a separation of concerns that makes the codebase testable, scalable, and easy to maintain.

### Layers

1.  **Domain Layer (Inner Circle)**
    *   **Entities**: Pure business objects (e.g., `AudioEntity`, `PlaylistEntity`).
    *   **Repositories (Interfaces)**: Abstract definitions of data operations.
    *   **Use Cases**: Encapsulate specific business rules (e.g., `PlayAudio`, `CreatePlaylist`).
    *   *Dependencies*: None (Pure Dart).

2.  **Data Layer (Outer Circle)**
    *   **Repositories (Implementations)**: Concrete implementations of domain repositories.
    *   **Data Sources**: Handle raw data retrieval (e.g., `AudioLocalDataSource` using `on_audio_query`).
    *   **Models**: Data transfer objects (DTOs) that map raw data to Domain Entities.

3.  **Presentation Layer (UI)**
    *   **BLoC (Business Logic Component)**: Manages state using streams and events.
    *   **Pages & Widgets**: Dumb UI components that render state and dispatch events.

### Design Patterns & Principles

*   **SOLID**: Every class and function is designed with Single Responsibility, Open/Closed, Liskov Substitution, Interface Segregation, and Dependency Inversion in mind.
*   **Dependency Injection**: Managed via `get_it` to decouple dependencies and facilitate testing.
*   **Repository Pattern**: Abstracts the data source implementation details from the business logic.
*   **BLoC Pattern**: Separation of business logic from UI rendering.

## 🛠 Tech Stack

*   **Framework**: [Flutter](https://flutter.dev/)
*   **Language**: [Dart](https://dart.dev/)
*   **State Management**: [flutter_bloc](https://pub.dev/packages/flutter_bloc)
*   **Dependency Injection**: [get_it](https://pub.dev/packages/get_it)
*   **Audio Engine**: [just_audio](https://pub.dev/packages/just_audio) & [just_audio_background](https://pub.dev/packages/just_audio_background)
*   **Local Storage Query**: [on_audio_query](https://pub.dev/packages/on_audio_query)
*   **Permissions**: [permission_handler](https://pub.dev/packages/permission_handler)
*   **Functional Programming**: [dartz](https://pub.dev/packages/dartz) (for `Either` type)
*   **Testing**: `bloc_test`, `mocktail`, `flutter_test`.

## 📂 Project Structure

```
lib/
├── core/                   # Shared kernels (Failures, UseCases, DI)
├── features/
│   ├── audio_player/       # Feature: Main Player Logic
│   │   ├── data/           # Data Layer
│   │   ├── domain/         # Domain Layer
│   │   └── presentation/   # UI & State
│   ├── playlists/          # Feature: Playlist Management
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── home/               # Feature: App Navigation Shell
└── main.dart               # Entry point
```

## 🏁 Getting Started

1.  **Clone the repository**:
    ```bash
    git clone https://github.com/your-username/devpaul_player.git
    ```

2.  **Install dependencies**:
    ```bash
    flutter pub get
    ```

3.  **Run the app**:
    ```bash
    flutter run
    ```
    *Note: This app requires an Android device or emulator to function fully due to local file system access.*

## 👨‍💻 About DevPaul.pro

**DevPaul** is a Clean Code Crafter and Senior Software Architect dedicated to the art of software excellence.

At **DevPaul.pro**, we don't just write code; we craft resilient, secure, and scalable digital solutions. Our philosophy is built on:

*   **Uncompromising Quality**: "Good enough" is never enough. Every line of code is scrutinized for clarity, efficiency, and purpose.
*   **Architecture First**: We believe that a solid foundation is the key to longevity. We strictly follow architectural patterns that ensure our software can evolve without breaking.
*   **Security by Design**: Security is not an afterthought. It is woven into the fabric of our development process, from the first line of code to the final deployment.
*   **Mastery**: We act as a reference for other developers, embodying the highest standards of the industry.

*Empowering the next generation of software engineering through example.*
