# Flutter To-Do List App

A feature-rich to-do list application built with Flutter that helps you organize and manage your tasks efficiently with reminders, priorities, and local storage.

## 📱 Features

- ✅ **Task Management**: Create, edit, delete, and mark tasks as complete
- 🔔 **Smart Reminders**: Set date and time reminders with local notifications
- 🎯 **Priority Levels**: Organize tasks by priority (Low, Medium, High, Urgent) with color coding
- 📱 **Modern UI**: Clean, intuitive Material Design 3 interface
- 🌙 **Dark Mode**: Automatic theme switching based on system preference
- 💾 **Local Storage**: Tasks persist locally using SharedPreferences
- 🗂️ **Categories**: Organize tasks by categories (optional)
- 📅 **Due Dates**: Set and track task due dates
- 📱 **Cross-Platform**: Runs on Android, iOS, and other Flutter-supported platforms

## 🛠️ Tech Stack

- **Framework**: Flutter 3.x
- **Language**: Dart
- **Local Storage**: SharedPreferences
- **Database**: SQLite (sqflite)
- **Notifications**: flutter_local_notifications
- **State Management**: Provider
- **Date/Time**: intl, timezone packages

## 📋 Prerequisites

Before running this app, make sure you have:

- Flutter SDK (3.2.3 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- Android emulator or physical device for testing

## 🚀 Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/YOUR_USERNAME/flutter-todo-app.git
cd flutter-todo-app
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Run the App

```bash
# For debug mode
flutter run

# For release mode
flutter run --release
```

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.6
  uuid: ^4.2.1                           # Unique ID generation
  intl: ^0.18.1                          # Internationalization
  shared_preferences: ^2.2.2             # Local storage
  flutter_local_notifications: ^17.2.2   # Push notifications
  timezone: ^0.9.2                       # Timezone handling
  sqflite: ^2.3.0                       # SQLite database
  path: ^1.8.3                          # Path utilities
  provider: ^6.1.1                      # State management
```

## 🏗️ Project Structure

```
lib/
├── main.dart                    # App entry point
├── models/
│   └── task.dart               # Task data model
├── screens/
│   ├── home_screen.dart        # Main task list screen
│   ├── add_task_screen.dart    # Add new task screen
│   └── task_detail_screen.dart # Task edit/detail screen
├── services/
│   ├── task_service.dart       # Task data operations
│   ├── notification_service.dart # Notification handling
│   ├── database_helper.dart    # SQLite database operations
│   └── task_manager.dart       # Task state management
└── widgets/
    └── task_list_item.dart     # Individual task list item
```

## 🎨 Screenshots

*(Add screenshots of your app here)*

| Home Screen | Add Task | Task Details |
|-------------|----------|--------------|
| ![Home](screenshots/home.png) | ![Add](screenshots/add_task.png) | ![Details](screenshots/task_details.png) |

## ⚙️ Configuration

### Android Setup

1. **Minimum SDK**: API level 21 (Android 5.0)
2. **Target SDK**: Latest stable
3. **Permissions**: The app requests notification permissions automatically

### iOS Setup

1. **Minimum iOS**: 12.0
2. **Permissions**: Notification permissions handled automatically

## 🔔 Notification Setup

The app uses local notifications for task reminders. Permissions are requested automatically when:
- A user sets a reminder for the first time
- The app starts (for Android)

## 🗄️ Data Storage

- **Tasks**: Stored locally using SharedPreferences as JSON
- **Settings**: App preferences stored in SharedPreferences
- **Future**: SQLite integration ready for complex queries

## 🧪 Testing

Run tests with:

```bash
flutter test
```

## 🚢 Building for Release

### Android APK
```bash
flutter build apk --release
```

### Android App Bundle
```bash
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Your Name**
- GitHub: [@yourusername](https://github.com/yourusername)
- LinkedIn: [Your LinkedIn](https://linkedin.com/in/yourprofile)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Material Design for the beautiful UI components
- Community packages that made development easier

## 🐛 Known Issues

- None currently reported

## 🔮 Future Enhancements

- [ ] Cloud synchronization
- [ ] Task sharing with other users
- [ ] Advanced filtering and sorting
- [ ] Task templates
- [ ] Export/Import functionality
- [ ] Widget support for home screen
- [ ] Voice notes for tasks

---

⭐ **If you found this project helpful, please give it a star!** ⭐
