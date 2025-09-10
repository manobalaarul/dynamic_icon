# Flutter Dynamic Icon Plus Demo

A Flutter application demonstrating the usage of the `flutter_dynamic_icon_plus` package to dynamically change app icons and manage badge numbers on iOS and Android devices.

## Features

- ✨ **Dynamic Icon Changing**: Switch between multiple app icons at runtime
- 📱 **Platform Support Detection**: Automatically detects if the device supports dynamic icons
- 🔢 **Badge Number Management**: Set and update app icon badge numbers (iOS only)
- 🎨 **Multiple Icon Themes**: Includes Default, Dark, Christmas, and Summer icon variants
- 📊 **Real-time Status**: Shows current active icon and badge number
- 🚫 **Device Blacklisting**: Supports blacklisting specific brands, manufacturers, and models

## Screenshots

The app provides an intuitive interface with:
- Support status indicator
- Current icon display
- Badge number management (iOS)
- Icon selection grid
- Visual feedback for active icons

## Prerequisites

- Flutter SDK (>=2.0.0)
- Dart SDK (>=2.12.0)
- iOS 10.3+ (for iOS dynamic icons)
- Android API level 26+ (for Android adaptive icons)

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_dynamic_icon_plus: ^latest_version
```

## Installation

1. **Clone the repository**
```bash
git clone <your-repository-url>
cd flutter_dynamic_icon_demo
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Configure iOS Icons (iOS only)**

Add alternate icons to your `ios/Runner/Info.plist`:

```xml
<key>CFBundleIcons</key>
<dict>
    <key>CFBundleAlternateIcons</key>
    <dict>
        <key>com.example.dynamic_icon.DarkIcon</key>
        <dict>
            <key>CFBundleIconFiles</key>
            <array>
                <string>DarkIcon</string>
            </array>
        </dict>
        <key>com.example.dynamic_icon.ChristmasIcon</key>
        <dict>
            <key>CFBundleIconFiles</key>
            <array>
                <string>ChristmasIcon</string>
            </array>
        </dict>
        <key>com.example.dynamic_icon.SummerIcon</key>
        <dict>
            <key>CFBundleIconFiles</key>
            <array>
                <string>SummerIcon</string>
            </array>
        </dict>
    </dict>
</dict>
```

4. **Add icon files to iOS bundle**

Place your icon files in `ios/Runner/` with the following naming convention:
- `DarkIcon@2x.png` (120x120px)
- `DarkIcon@3x.png` (180x180px)
- `ChristmasIcon@2x.png` (120x120px)
- `ChristmasIcon@3x.png` (180x180px)
- `SummerIcon@2x.png` (120x120px)
- `SummerIcon@3x.png` (180x180px)

5. **Configure Android Icons (Android only)**

For Android, add your alternate icons to the appropriate drawable folders and configure them in your `android/app/src/main/AndroidManifest.xml`.

## Usage

### Running the App

```bash
flutter run
```

### Key Features Implementation

#### 1. Check Device Support
```dart
bool isSupported = await FlutterDynamicIconPlus.supportsAlternateIcons;
```

#### 2. Change App Icon
```dart
await FlutterDynamicIconPlus.setAlternateIconName(
  iconName: 'com.example.dynamic_icon.DarkIcon',
  blacklistBrands: ['Redmi'],
  blacklistManufactures: ['Xiaomi'],
  blacklistModels: ['Redmi 200A'],
);
```

#### 3. Get Current Icon
```dart
String? iconName = await FlutterDynamicIconPlus.alternateIconName;
```

#### 4. Set Badge Number (iOS only)
```dart
await FlutterDynamicIconPlus.setApplicationIconBadgeNumber(5);
```

#### 5. Get Badge Number (iOS only)
```dart
int badgeNumber = await FlutterDynamicIconPlus.applicationIconBadgeNumber;
```

## Available Icons

The demo app includes four icon variants:

| Icon Name | Display Name | Description |
|-----------|--------------|-------------|
| Default | Default | Original app icon |
| com.example.dynamic_icon.DarkIcon | Dark | Dark theme variant |
| com.example.dynamic_icon.ChristmasIcon | Christmas | Holiday themed icon |
| com.example.dynamic_icon.SummerIcon | Summer | Summer themed icon |

## Device Blacklisting

The app includes device blacklisting functionality to prevent icon changes on specific devices that may not support the feature properly:

- **Brands**: Redmi
- **Manufacturers**: Xiaomi
- **Models**: Redmi 200A

You can customize these blacklists based on your testing results.

## Platform-Specific Notes

### iOS
- Requires iOS 10.3 or later
- Icons must be added to the app bundle
- Badge numbers are fully supported
- Icon changes may show a system alert
- App may need to be reopened to see changes in launcher

### Android
- Requires API level 26+ for adaptive icons
- Limited support across different manufacturers
- Badge numbers are not supported
- Icon changes are immediate in most cases

## Error Handling

The app includes comprehensive error handling for:
- Unsupported devices
- Platform-specific exceptions
- Invalid badge numbers
- Network or system errors

## Troubleshooting

### Icon Not Changing
1. Verify device compatibility
2. Check if icon files are properly added to the bundle
3. Ensure correct icon names in configuration
4. Restart the app or device

### Badge Number Issues (iOS)
1. Verify iOS version (10.3+)
2. Check notification permissions
3. Ensure valid integer input

### Build Issues
1. Run `flutter clean && flutter pub get`
2. Verify iOS Info.plist configuration
3. Check Android manifest permissions

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For issues and questions:
- Check the [flutter_dynamic_icon_plus documentation](https://pub.dev/packages/flutter_dynamic_icon_plus)
- Open an issue in this repository
- Review platform-specific requirements

## Acknowledgments

- [flutter_dynamic_icon_plus](https://pub.dev/packages/flutter_dynamic_icon_plus) package contributors
- Flutter team for the excellent framework
- Icon designers for the demo icons
