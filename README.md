# Flutter

A modern Flutter-based mobile application utilizing the latest mobile development technologies and tools for building responsive cross-platform applications.

## 📋 Prerequisites

- Flutter SDK (^3.29.2)
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- Android SDK / Xcode (for iOS development)

## 🛠️ Installation

1. Install dependencies:
```bash
flutter pub get
```

2. Run the application:
```bash
flutter run
```

## 📁 Project Structure

```
radha_naam_japa/
├── .gitignore                    # Git ignore rules
├── .metadata                     # Flutter project metadata
├── analysis_options.yaml         # Dart/Flutter analysis configuration
├── env.json                      # Environment configuration
├── firebase.json                 # Firebase configuration
├── pubspec.yaml                  # Project dependencies and configuration
├── README.md                     # Project documentation
├── android/                      # Android-specific configuration
│   ├── .gitignore
│   ├── build.gradle.kts
│   ├── gradle.properties
│   ├── settings.gradle.kts
│   ├── app/
│   │   ├── build.gradle.kts
│   │   ├── google-services.json
│   │   └── src/
│   │       ├── debug/
│   │       ├── main/
│   │       └── profile/
│   └── gradle/
│       └── wrapper/
│           ├── gradle-wrapper.jar
│           └── gradle-wrapper.properties
├── assets/                       # Static assets
│   ├── images/
│   │   ├── img_app_logo.svg
│   │   ├── no-image.jpg
│   │   └── sad_face.svg
│   └── sounds/
│       └── radha_chant.mp3
├── build/                        # Build artifacts (generated)
├── ios/                          # iOS-specific configuration
│   ├── .gitignore
│   ├── Flutter/
│   │   ├── AppFrameworkInfo.plist
│   │   ├── Debug.xcconfig
│   │   ├── Release.xcconfig
│   │   └── ephemeral/
│   ├── Runner/
│   │   ├── AppDelegate.swift
│   │   ├── Info.plist
│   │   ├── Runner-Bridging-Header.h
│   │   ├── Assets.xcassets/
│   │   │   └── AppIcon.appiconset/
│   │   │   └── LaunchImage.imageset/
│   │   ├── Base.lproj/
│   │   │   ├── LaunchScreen.storyboard
│   │   │   └── Main.storyboard
│   │   └── Runner.xcodeproj/
│   │       ├── project.pbxproj
│   │       ├── project.xcworkspace/
│   │       └── xcshareddata/
│   ├── Runner.xcworkspace/
│   │   ├── contents.xcworkspacedata
│   │   └── xcshareddata/
│   └── RunnerTests/
│       └── RunnerTests.swift
├── lib/                          # Main application code
│   ├── firebase_options.dart     # Firebase configuration options
│   ├── main.dart                 # Application entry point
│   ├── core/                     # Core utilities and services
│   │   └── app_export.dart       # App-wide exports
│   ├── presentation/             # UI screens and widgets
│   │   ├── app_settings_screen/
│   │   ├── counting_screen/
│   │   │   └── widgets/
│   │   │       ├── animated_radha_text_widget.dart
│   │   │       ├── circular_progress_widget.dart
│   │   │       └── save_japa_button_widget.dart
│   │   ├── home_screen/
│   │   │   └── widgets/
│   │   │       ├── action_buttons_widget.dart
│   │   │       ├── greeting_header_widget.dart
│   │   │       ├── japa_progress_card_widget.dart
│   │   │       └── session_history_widget.dart
│   │   ├── japa_summary_screen/
│   │   │   └── widgets/
│   │   │       ├── action_buttons_widget.dart
│   │   │       ├── inspirational_quote_widget.dart
│   │   │       ├── progress_visualization_widget.dart
│   │   │       ├── session_stats_card_widget.dart
│   │   │       └── streak_preview_widget.dart
│   │   ├── login_screen/
│   │   ├── notification_screen/
│   │   ├── profile_screen/
│   │   ├── save_confirmation_modal/
│   │   ├── settings_screen/
│   │   │   └── widgets/
│   │   │       ├── profile_card_widget.dart
│   │   │       ├── settings_item_widget.dart
│   │   │       └── settings_section_widget.dart
│   │   └── splash_screen/
│   ├── routes/                   # Application routing
│   │   └── app_routes.dart
│   ├── services/                 # Business logic services
│   │   └── japa_storage_service.dart
│   ├── theme/                    # Theme configuration
│   │   └── app_theme.dart
│   └── widgets/                  # Reusable UI components
│       ├── custom_app_bar.dart
│       ├── custom_bottom_bar.dart
│       ├── custom_error_widget.dart
│       ├── custom_icon_widget.dart
│       └── custom_image_widget.dart
├── linux/                        # Linux-specific configuration
│   ├── .gitignore
│   ├── CMakeLists.txt
│   ├── flutter/
│   │   ├── CMakeLists.txt
│   │   ├── generated_plugin_registrant.cc
│   │   ├── generated_plugin_registrant.h
│   │   └── generated_plugins.cmake
│   └── runner/
│       ├── CMakeLists.txt
│       ├── main.cc
│       ├── my_application.cc
│       └── my_application.h
├── macos/                        # macOS-specific configuration
│   ├── .gitignore
│   ├── Flutter/
│   │   ├── Flutter-Debug.xcconfig
│   │   ├── Flutter-Release.xcconfig
│   │   ├── GeneratedPluginRegistrant.swift
│   │   └── ephemeral/
│   ├── Runner/
│   │   ├── AppDelegate.swift
│   │   ├── DebugProfile.entitlements
│   │   ├── Info.plist
│   │   ├── MainFlutterWindow.swift
│   │   ├── Release.entitlements
│   │   ├── Assets.xcassets/
│   │   ├── Base.lproj/
│   │   ├── Configs/
│   │   └── Runner.xcodeproj/
│   │       ├── project.pbxproj
│   │       ├── project.xcworkspace/
│   │       └── xcshareddata/
│   ├── Runner.xcworkspace/
│   │   ├── contents.xcworkspacedata
│   │   └── xcshareddata/
│   └── RunnerTests/
│       └── RunnerTests.swift
├── test/                         # Unit and widget tests
│   └── widget_test.dart
├── web/                          # Web-specific configuration
└── windows/                      # Windows-specific configuration
    ├── .gitignore
    ├── CMakeLists.txt
    ├── flutter/
    │   ├── CMakeLists.txt
    │   ├── generated_plugin_registrant.cc
    │   ├── generated_plugin_registrant.h
    │   └── generated_plugins.cmake
    └── runner/
        ├── CMakeLists.txt
        ├── flutter_window.cpp
        ├── flutter_window.h
        ├── main.cpp
        ├── resource.h
        ├── runner.exe.manifest
        ├── Runner.rc
        ├── utils.cpp
        ├── utils.h
        ├── win32_window.cpp
        ├── win32_window.h
        └── resources/

```

## 🧩 Adding Routes

To add new routes to the application, update the `lib/routes/app_routes.dart` file:

```dart
import 'package:flutter/material.dart';
import 'package:package_name/presentation/home_screen/home_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String home = '/home';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    home: (context) => const HomeScreen(),
    // Add more routes as needed
  }
}
```

## 🎨 Theming

This project includes a comprehensive theming system with both light and dark themes:

```dart
// Access the current theme
ThemeData theme = Theme.of(context);

// Use theme colors
Color primaryColor = theme.colorScheme.primary;
```

The theme configuration includes:
- Color schemes for light and dark modes
- Typography styles
- Button themes
- Input decoration themes
- Card and dialog themes

## 📱 Responsive Design

The app is built with responsive design using the Sizer package:

```dart
// Example of responsive sizing
Container(
  width: 50.w, // 50% of screen width
  height: 20.h, // 20% of screen height
  child: Text('Responsive Container'),
)
```
## 📦 Deployment

Build the application for production:

```bash
# For Android
flutter build apk --release

# For iOS
flutter build ios --release
```

## 🙏 Acknowledgments
- Built with [Rocket.new](https://rocket.new)
- Powered by [Flutter](https://flutter.dev) & [Dart](https://dart.dev)
- Styled with Material Design

Built with ❤️ on Rocket.new
