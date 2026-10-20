# FinPay — Flutter Wallet Demo

FinPay is a fintech-inspired mobile application built with Flutter and Dart to demonstrate wallet UI development, reactive state management, and transaction handling.

## Current Features

- Wallet dashboard with a displayed balance
- Reactive state management using GetX
- Add Money dialog with amount validation
- Demo transaction list
- Basic wallet balance updates and expense validation

## Tech Stack

- Flutter
- Dart
- GetX
- Material 3

## Project Structure

```text
lib/
├── app/
│   └── app.dart
├── core/
├── features/
│   ├── dashboard/
│   │   ├── controllers/
│   │   ├── bindings/
│   │   └── views/
│   ├── scanner/
│   └── transactions/
└── main.dart
```

## Getting Started

### Prerequisites

- Flutter SDK
- Dart SDK
- An editor such as VS Code or Android Studio

### Run Locally

```bash
git clone https://github.com/Ashwinikhodake/finpay-flutter.git
cd finpay-flutter
flutter pub get
flutter run
```

## Project Status

This project is under active development. Features will be implemented incrementally as part of a hands-on Flutter portfolio project.

**Note:** FinPay is a demo application. Wallet balances and transactions are simulated; no real money or payments are processed.
