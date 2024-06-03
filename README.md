# D-files App

Welcome to the D-files App! This app allows administrators to view and manage files uploaded by users on the D-files Website. Admins can also upload files to individual user profiles.

## Features

- **View User Uploads**: Access and review files uploaded by users.
- **Upload Files to User Profiles**: Admins can upload files to specific user profiles.
- **User Management**: Admins can manage user profiles and their uploaded content.

## Technology Stack

- **Frontend**: Flutter
- **Backend**: Firebase

## Setup and Installation

### Prerequisites

- Flutter SDK: [Install Flutter](https://flutter.dev/docs/get-started/install)
- Firebase Project: [Create a Firebase project](https://firebase.google.com/)

### Installation Steps

1. **Clone the Repository**:
    ```sh
    git clone https://github.com/yourusername/admin-management-app.git
    cd D-files-app
    ```

2. **Set Up Firebase**:
    - Use the same Firebase project as the User Upload Website.
    - Add an Android and iOS app to your Firebase project.
    - Copy the Firebase configuration settings to your Flutter app.

3. **Configure Firebase in Flutter**:
    - Replace the Firebase configuration in `android/app/google-services.json` and `ios/Runner/GoogleService-Info.plist` with your Firebase project configuration.

4. **Install Dependencies**:
    ```sh
    flutter pub get
    ```

5. **Run the App**:
    ```sh
    flutter run
    ```

## Usage

1. **Login**: Log in with admin credentials.
2. **View User Uploads**: Navigate to the user management section to view files uploaded by users.
3. **Upload Files to User Profiles**: Select a user profile and upload files directly to their account.

## Contributing

We welcome contributions! Please follow these steps to contribute:

1. Fork the repository.
2. Create a new branch: `git checkout -b feature/your-feature-name`.
3. Commit your changes: `git commit -m 'Add some feature'`.
4. Push to the branch: `git push origin feature/your-feature-name`.
5. Create a pull request.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
