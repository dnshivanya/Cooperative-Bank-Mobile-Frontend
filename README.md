# Cooperative Banking Mobile App

A modern Flutter mobile application for cooperative banking services with a clean, user-friendly interface.

## Features

### 🔐 Authentication
- **Login Screen**: Secure user authentication with email and password
- **Registration Screen**: New user account creation
- **Demo Credentials**: 
  - Email: `demo@cooperativebank.com`
  - Password: `password123`

### 🏠 Dashboard
- **Account Overview**: Real-time balance display
- **Account Information**: Account number and verification status
- **Quick Actions**: Easy access to common banking functions
- **Recent Transactions**: Latest transaction history
- **Theme Toggle**: Switch between light and dark modes

### 💰 Banking Features
- **Money Transfer**: Send money to other accounts
- **Transaction History**: Complete transaction log with filtering
- **Account Management**: View account details and settings
- **Profile Management**: Update user information and preferences

### 🎨 UI/UX Features
- **Modern Design**: Clean, professional interface
- **Brand Colors**: Blue, green, and yellow color scheme
- **Responsive Layout**: Optimized for mobile devices
- **Dark/Light Theme**: User preference support
- **Smooth Animations**: Enhanced user experience

## Technology Stack

- **Framework**: Flutter 3.7.2+
- **State Management**: Provider
- **Navigation**: GoRouter
- **UI Components**: Material Design 3
- **Fonts**: Google Fonts (Inter)
- **Charts**: FL Chart
- **Local Storage**: SharedPreferences
- **Security**: Local Authentication (biometric support)

## Project Structure

```
lib/
├── constants/          # App constants and colors
├── models/            # Data models (User, Transaction)
├── providers/         # State management (Auth, Theme)
├── screens/           # UI screens
├── services/          # Business logic services
├── utils/             # Utility functions
└── widgets/           # Reusable UI components
```

## Getting Started

### Prerequisites
- Flutter SDK (3.7.2 or higher)
- Dart SDK
- Android Studio / VS Code
- Android/iOS device or emulator

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd cooperative_banking_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Demo Usage

1. **Launch the app** - You'll see the splash screen
2. **Login** using the demo credentials:
   - Email: `demo@cooperativebank.com`
   - Password: `password123`
3. **Explore features**:
   - View account balance and information
   - Try money transfers
   - Check transaction history
   - Switch between light/dark themes
   - Update profile settings

## Key Screens

### 1. Splash Screen
- App branding and loading animation
- Automatic authentication check

### 2. Login Screen
- Email and password authentication
- Remember me functionality
- Demo credentials display

### 3. Dashboard
- Account balance overview
- Quick action buttons
- Recent transactions
- Navigation menu

### 4. Transfer Screen
- Send money to other accounts
- Amount validation
- Transfer information

### 5. Transaction History
- Complete transaction log
- Filter by transaction type
- Detailed transaction information

### 6. Profile Screen
- User information display
- Theme settings
- Account verification status

## Security Features

- **Secure Authentication**: Email/password validation
- **Local Storage**: Encrypted token storage
- **Biometric Support**: Fingerprint/face recognition (planned)
- **Input Validation**: Comprehensive form validation
- **Error Handling**: User-friendly error messages

## Customization

### Colors
The app uses a consistent color scheme defined in `lib/constants/app_colors.dart`:
- Primary Blue: `#1976D2`
- Primary Green: `#388E3C`
- Primary Yellow: `#FFC107`

### Themes
- Light theme with clean, modern design
- Dark theme for better night usage
- Automatic system theme detection

## Future Enhancements

- [ ] Biometric authentication
- [ ] Push notifications
- [ ] Bill payment integration
- [ ] Loan applications
- [ ] Investment tracking
- [ ] Multi-language support
- [ ] Offline functionality

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions, please contact the development team or create an issue in the repository.

---

**Note**: This is a demo application for educational purposes. Do not use for actual banking transactions without proper security implementation and backend integration.