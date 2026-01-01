# Engaz App (إنجاز)

A comprehensive Flutter application for managing books, customers, reservations, and reports. This app is built with scalability and performance in mind, utilizing modern Flutter best practices.

## 🚀 Features

-   **Dashboard**: Overview of key metrics and quick actions.
-   **Book Management**: Browse, search, and manage book inventory.
-   **Customer Management**: Track customer details and their association with books.
-   **Reservations System**: Manage book reservations with real-time updates.
-   **Localization**: Full support for **Arabic** and **English** (RTL/LTR).
-   **Theme Support**: Toggle between **Dark** and **Light** modes.
-   **Responsive Design**: optimized for various screen sizes using `flutter_screenutil`.

## 🛠 Tech Stack

-   **Framework**: [Flutter](https://flutter.dev/)
-   **State Management**: [Bloc / Cubit](https://pub.dev/packages/flutter_bloc)
-   **Backend**: [Firebase Cloud Firestore](https://firebase.google.com/docs/firestore)
-   **Localization**: [easy_localization](https://pub.dev/packages/easy_localization)
-   **Architecture**: Feature-First & Clean Architecture principles
-   **Key Packages**:
    -   `skeletonizer`: Loading effects
    -   `lottie`: Animations
    -   `shared_preferences`: Local storage
    -   `flutter_screenutil`: Responsiveness

## 📂 Project Structure

The project follows a **Feature-First** architecture to ensure modularity and maintainability.

```
lib/
├── core/                   # Core functionality shared across features
│   ├── constants/          # App-wide constants (Images, strings, etc.)
│   ├── services/           # External services (Preferences, etc.)
│   ├── theme/              # App theme and styles
│   ├── utils/              # Utility functions
│   └── widgets/            # Core reusable widgets
├── features/               # Feature-specific code
│   ├── app_section/        # App shell and navigation logic
│   ├── books/              # Books feature (UI + Logic)
│   ├── customers/          # Customers feature (UI + Logic)
│   ├── home/               # Home screen
│   ├── reports/            # Reporting feature
│   └── reservations/       # Reservations feature
├── shared/                 # Shared widgets used across multiple features
├── firebase_options.dart   # Firebase configuration
└── main.dart               # Entry point
```

## ⚙️ Setup & Installation

1.  **Clone the repository:**
    ```bash
    git clone <repository_url>
    cd engaz_app
    ```

2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Firebase Configuration:**
    -   Ensure you have the `firebase_options.dart` file generated for your project.
    -   If not, configure it using the FlutterFire CLI:
        ```bash
        flutterfire configure
        ```

4.  **Run the App:**
    ```bash
    flutter run
    ```
    
## 🔐 Security & Configuration
This project uses Firebase, but sensitive configuration files are **not included** in the repository for security reasons.
To run this project, you need to:
1.  Create a Firebase project.
2.  Enable Cloud Firestore.
3.  Generate your own `firebase_options.dart` using `flutterfire configure`.
4.  Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) from Firebase Console and place them in `android/app/` and `ios/Runner/` respectively.

## 📸 App Gallery

### 📚 Books & Details
| **Feature** | **Arabic (Dark)** | **English (Dark)** | **Light Mode** |
| :---: | :---: | :---: | :---: |
| **All Books** | <img src="screenShoots/Books dark ar.jpeg" width="200" /> | <img src="screenShoots/book dark en.jpeg" width="200" /> | <img src="screenShoots/book light.jpeg" width="200" /> |
| **Book Details** | <img src="screenShoots/book details dark ar.jpeg" width="200" /> | <img src="screenShoots/book details dark en.jpeg" width="200" /> | <img src="screenShoots/book details light.jpeg" width="200" /> |

### 👥 Customers
| **Feature** | **Arabic (Dark)** | **English (Dark)** | **Light Mode** |
| :---: | :---: | :---: | :---: |
| **Customers List** | <img src="screenShoots/customers dark ar.jpeg" width="200" /> | <img src="screenShoots/customers dark en.jpeg" width="200" /> | <img src="screenShoots/customers light.jpeg" width="200" /> |
| **Customer Books** | <img src="screenShoots/customer book dark ar.jpeg" width="200" /> | <img src="screenShoots/customer book dark en.jpeg" width="200" /> | <img src="screenShoots/customer book light.jpeg" width="200" /> |

### 📅 Reservations
| **Status** | **Arabic (Dark)** | **Arabic (Light)** | **English (Light)** |
| :---: | :---: | :---: | :---: |
| **Ready** | <img src="screenShoots/reservations ready dark ar.jpeg" width="200" /> | <img src="screenShoots/reservations ready light ar.jpeg" width="200" /> | <img src="screenShoots/reservations ready light en.jpeg" width="200" /> |
| **Not Ready** | <img src="screenShoots/reservations not ready dark ar.jpeg" width="200" /> | <img src="screenShoots/reservations not ready light ar.jpeg" width="200" /> | <img src="screenShoots/reservations not ready light en.jpeg" width="200" /> |


## 🔮 Future Improvements

-   [ ] **Push Notifications**: Notify users about reservation status changes.
-   [ ] **Advanced Analytics**: More granular reporting features.
-   [ ] **Offline Support**: Enhanced caching for offline access.
-   [ ] **User Authentication**: Expand role-based access control.

---
Developed with Mohamed Ehab using Flutter.
