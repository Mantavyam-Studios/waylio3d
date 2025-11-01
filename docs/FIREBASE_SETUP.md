# Firebase Setup Guide for Waylio3D

## Prerequisites
- Google account
- Flutter project set up
- SHA-1 and SHA-256 certificates (already generated)

## Your SHA Certificates
**SHA-1:** `3B:63:C1:13:6D:5B:8C:F4:AD:4A:52:6C:78:8F:59:D5:66:BB:F6:7D`

**SHA-256:** `D5:DA:CC:36:D3:F4:A1:C7:E5:96:D6:C6:69:A5:44:58:39:1E:D7:49:9F:5D:E6:9B:25:B9:52:92:D9:58:C7:CD`

## Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project"
3. Enter project name: **waylio3d** (or your preferred name)
4. Enable Google Analytics (optional but recommended)
5. Click "Create project"

## Step 2: Add Android App to Firebase

1. In Firebase Console, click the Android icon to add an Android app
2. Enter the following details:
   - **Android package name:** `com.example.waylio3d` (must match `android/app/build.gradle`)
   - **App nickname:** Waylio3D (optional)
   - **Debug signing certificate SHA-1:** `3B:63:C1:13:6D:5B:8C:F4:AD:4A:52:6C:78:8F:59:D5:66:BB:F6:7D`
3. Click "Register app"
4. Download `google-services.json`
5. Place `google-services.json` in `android/app/` directory

## Step 3: Enable Authentication Methods

1. In Firebase Console, go to **Authentication** → **Sign-in method**
2. Enable the following providers:
   - **Email/Password** - Click Enable and Save
   - **Google** - Click Enable, add project support email, and Save

### For Google Sign-In:
1. After enabling Google provider, note the **Web client ID** (you'll need this)
2. Add SHA-256 certificate as well:
   - Go to Project Settings → Your apps → Android app
   - Click "Add fingerprint"
   - Paste SHA-256: `D5:DA:CC:36:D3:F4:A1:C7:E5:96:D6:C6:69:A5:44:58:39:1E:D7:49:9F:5D:E6:9B:25:B9:52:92:D9:58:C7:CD`

## Step 4: Set Up Firestore Database

1. In Firebase Console, go to **Firestore Database**
2. Click "Create database"
3. Choose **Start in test mode** (for development)
4. Select a location (choose closest to your users)
5. Click "Enable"

### Firestore Security Rules (for development):
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

## Step 5: Configure Flutter Project

### Update `android/app/build.gradle`:
Ensure you have:
```gradle
android {
    defaultConfig {
        applicationId "com.example.waylio3d"
        minSdkVersion 21  // Firebase requires minimum SDK 21
        targetSdkVersion flutter.targetSdkVersion
        // ... other config
    }
}

dependencies {
    implementation platform('com.google.firebase:firebase-bom:33.7.0')
    implementation 'com.google.firebase:firebase-analytics'
}
```

### Update `android/build.gradle`:
Add Google services plugin:
```gradle
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.4.2'
    }
}
```

### Update `android/app/build.gradle` (bottom of file):
```gradle
apply plugin: 'com.google.gms.google-services'
```

## Step 6: Initialize Firebase in Flutter

The Firebase initialization code is already prepared in the project. You just need to:

1. Place `google-services.json` in `android/app/`
2. Run the app

## Step 7: Test Firebase Connection

Run the following command to verify Firebase setup:
```bash
flutter run
```

Check the console for Firebase initialization messages.

## Troubleshooting

### Common Issues:

1. **"google-services.json not found"**
   - Ensure the file is in `android/app/` directory
   - Check the file name is exactly `google-services.json`

2. **"Default FirebaseApp is not initialized"**
   - Make sure `Firebase.initializeApp()` is called in `main()`
   - Check that `google-services.json` has correct package name

3. **Google Sign-In not working**
   - Verify SHA-1 and SHA-256 are added in Firebase Console
   - Check that Google Sign-In is enabled in Authentication
   - Ensure you're using the correct Web client ID

4. **Build errors**
   - Run `flutter clean`
   - Run `flutter pub get`
   - Rebuild the app

## Next Steps

After Firebase is set up:
1. Test email/password authentication
2. Test Google Sign-In
3. Verify Firestore database connection
4. Set up proper security rules for production

## Important Notes

- **Never commit `google-services.json` to public repositories** (add to `.gitignore`)
- Change Firestore rules to production mode before deploying
- Set up proper authentication rules and data validation
- Enable Firebase App Check for additional security

## Resources

- [Firebase Documentation](https://firebase.google.com/docs)
- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Firebase Console](https://console.firebase.google.com/)

