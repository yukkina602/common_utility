## TODO
This source is a compilation of processes that I personally use frequently.

## Getting started
```dart
import 'package:common_utility/common_utility.dart';
```

### iOS
Update on your project `info.plist`.
```dart
platform :ios, '14.0'
```

## Firebase
Check on this package.

Firebase Auth: https://pub.dev/packages/firebase_auth

Firebase Messaging: https://pub.dev/packages/firebase_messaging

Firebase Remote Config: https://pub.dev/packages/firebase_remote_config

## When use camera on android (USB keyboard input)
Update on your project `android/app/AndroidManifest.xml`
```dart
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- Use usb hardware -->
    <uses-feature android:name="android.hardware.usb.host" />

    <!-- Permissions -->
    <uses-permission android:name="android.permission.USB_PERMISSION" />
...
```

```dart
...
    <!-- Use on qr barcode scanner on usb keyboard type. -->
    <intent-filter>
        <action android:name="android.hardware.usb.action.USB_DEVICE_ATTACHED" />
    </intent-filter>
</activity>
```

```dart
<queries>
    <intent>
        <action android:name="android.intent.action.PROCESS_TEXT"/>
        <data android:mimeType="text/plain"/>
    </intent>
</queries>
```

## Additional information

