# To-do

![Platform](https://img.shields.io/badge/platform-Android%20%7C%20iOS-green.svg)
[![Build Status](https://github.com/0aps/todo-app/workflows/CI/badge.svg)](https://github.com/0aps/todo-app/actions)

A simple to-do application..

## Overview

In **To do**, we use:

- [Git](https://git-scm.com/) as version control.
- [Flutter](https://flutter.dev/) to build and test the mobile application.
- [Anxeb](https://github.com/nodrix/anxeb-flutter) as Flutter wrapper framework.
- [To-Do API](https://api.todo.com/) to fetch data from the To-do backend.
- [Github Actions](https://github.com/0aps/todo-app) to build and publish the project.

## Prerequisites

Make sure you have installed all following prerequisites:

- [Git](https://git-scm.com/)
- [Flutter](https://flutter.dev/)
- [Dart](https://dart.dev/)
- [Android SDK](https://developer.android.com/studio)
- [Xcode](https://developer.apple.com/xcode/) (iOS dev only)

## Install

Clone Anxeb and To-do repositories. Make sure they are both in the same directory level.\
Install project dependencies.

```bash
git clone https://github.com/nodrix/anxeb-flutter.git
git clone https://github.com/0aps/todo-app.git
cd todo-app
flutter pub get
```

## Run Tests

Execute the following on the project root:

```bash
flutter test
```

To run integration tests, execute:

```bash
flutter drive \
  --driver=integration_test/driver.dart \
  --target=integration_test/app_test.dart \
  -d device-id
```

## Code Style

Code style and conventions use all `flutter analyze` default rules.\
A few other rules were added in `analysis_options.yaml`.\
Please see [here](https://dart-lang.github.io/linter/lints/index.html) for all options.

## Useful Commands

- Launch Icons\
  `flutter pub run flutter_launcher_icons`\
  `flutter pub run flutter_native_splash:create`

- Open XCode\
  `flutter pub get`\
  `open ios/Runner.xcworkspace`

- Execute Release\
  `flutter run --release -d device-id`

- Execute Profile\
  `flutter run --profile -d device-id`

- Build Bundle\
  `keytool -genkey -v -keystore ~/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key`\
  `flutter build appbundle`\
  `bundletool build-apks --bundle=build/app/outputs/bundle/release/app-release.aab --output=bundle/todo.apks --ks=/path/to/key.jks --ks-pass=pass:ksPass --ks-key-alias=key --key-pass=pass:keyPass`

- Build APK\
  `flutter build apk --target-platform android-arm,android-arm64,android-x64 --split-per-abi`\
  `flutter build apk --release --no-shrink --no-tree-shake-icons`\
  `flutter build apk --verbose`

- Build for Production (Android)\
  `flutter build appbundle --obfuscate --split-debug-info=symbols`

- Build for Production - iOS\
  `flutter build ios`
