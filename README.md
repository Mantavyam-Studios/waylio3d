# Product Requirements Document (PRD)
## Waylio - AR Indoor Navigation Application

---

## 1. Executive Summary

**Product Name:** Waylio  
**Version:** 1.0 (MVP)  
**Platform:** Android (Kotlin)  
**Target Release:** MVP - USB Building, Chandigarh University

### Vision Statement
Waylio is an AR-powered indoor navigation application that helps students, faculty, visitors, and the general public navigate complex indoor spaces seamlessly using cutting-edge LiDAR-based positioning technology.

### MVP Scope
- Single building support (University School of Business - USB, Chandigarh University)
- Ground floor navigation
- AR-based wayfinding with real-time localization
- Basic user authentication and profile management

---

## 2. Product Overview

### 2.1 Problem Statement
Indoor navigation in large institutional buildings like university campuses is challenging. Traditional maps are confusing, and GPS doesn't work reliably indoors. Users struggle to find specific rooms, labs, and facilities efficiently.

### 2.2 Solution
Waylio leverages Multiset SDK's LiDAR-based AR technology to provide:
- Real-time indoor positioning through environment scanning
- Visual AR overlays for intuitive wayfinding
- Room and facility search capabilities
- Personalized navigation experience

### 2.3 Target Audience
- **Students:** Finding classrooms, labs, and study areas
- **Faculty:** Locating offices and meeting rooms
- **Visitors:** First-time campus visitors needing guidance
- **General Public:** Event attendees and campus guests

---

## 3. Technical Architecture

### 3.1 Technology Stack
- **Language:** Kotlin
- **Build System:** Gradle (Kotlin DSL)
- **Minimum SDK:** API 24 (Android 7.0 Nougat)
- **Target SDK:** Latest available (auto-configured)
- **AR Framework:** Multiset SDK
- **UI Framework:** Material Design 3, Jetpack Compose (or XML with Material Components)
- **Architecture Pattern:** MVVM (Model-View-ViewModel)

### 3.2 Project Configuration
```
Project Name: WaylioApp
Package Name: com.mantavyam.waylioapp
Build Config: Kotlin DSL (build.gradle.kts)
Navigation: Bottom Navigation (3 tabs)
```

### 3.3 Key Dependencies
- **Multiset SDK** (AR Navigation with offline support)
- **Firebase:**
  - Firebase Authentication (Email/Password + Google Sign-In)
  - Firebase Firestore (User profiles, favorites, navigation history)
- **AndroidX Libraries:**
  - Core KTX
  - AppCompat
  - ConstraintLayout
  - Lifecycle (ViewModel & LiveData)
  - Navigation Component
- **Material Design 3 Components**
- **Kotlin Coroutines** (Async operations)
- **Room Database** (Local caching for offline support)
- **Gson** (JSON parsing for room data)
- **CameraX** (AR camera view)

### 3.4 Multiset SDK Integration
**Map ID:** `MSET_Z1RHU09TW3AX`  
**Coverage:** USB Building - Ground Floor

**SDK Managers to Implement:**
1. `MultisetSdkManager` - Core SDK initialization
2. `MapLocalizationManager` - Environment scanning & localization
3. `ModelSetTrackingManager` - AR tracking and navigation
4. `ToastManager` - User feedback

#### **Namespaces**

* MultiSet

#### **Managers**

* [MultisetSdkManager](https://docs.multiset.ai/unity-sdk/api-reference/multisetsdkmanager)  
* [MapLocalizationManager](https://docs.multiset.ai/unity-sdk/api-reference/maplocalizationmanager)  
* [SingleFrameLocalizationManager](https://docs.multiset.ai/unity-sdk/api-reference/singleframelocalizationmanager)  
* [ModelSetTrackingManager](https://docs.multiset.ai/unity-sdk/api-reference/modelsettrackingmanager)  
* [MappingManager](https://docs.multiset.ai/unity-sdk/api-reference/mappingmanager)  
* [MapMeshHandler](https://docs.multiset.ai/unity-sdk/api-reference/mapmeshhandler)  
* [ToastManager](https://docs.multiset.ai/unity-sdk/api-reference/toastmanager)

---

## 4. Feature Requirements

### 4.1 Authentication System

#### 4.1.1 Sign Up / Sign In
**Priority:** P0 (Must Have)

**Features:**
- Email/Password authentication
- Google Social Sign-In
- Guest mode (limited features)
- Password reset functionality

**User Profile Fields:**
- Name (Required)
- Email (Required)
- Profile Photo (Optional)
- User Type: Dropdown (Student / Visitor / Faculty / Public)

**Validation Rules:**
- Email format validation
- Password: Minimum 8 characters
- Unique email per account

#### 4.1.2 Guest Mode
- No registration required
- Full AR navigation access
- No profile/favorites/history features
- Prompt to sign up after session

---

### 4.2 Home & Navigation

#### 4.2.1 Home Screen (Bottom Nav Tab 1)
**Priority:** P0

**Components:**
- Welcome message with user name
- Quick action card: "Start AR Navigation"
- Recent destinations (if logged in)
- Featured locations/announcements
- Building status indicator (USB - Ground Floor)

#### 4.2.2 Explore Screen (Bottom Nav Tab 2)
**Priority:** P0

**Features:**
- **Search Bar:** Search by room number (e.g., "USB-101", "Lab 3")
- **Category Browsing:**
  - Classrooms
  - Laboratories
  - Faculty Offices
  - Facilities (Restrooms, Cafeteria, etc.)
- **Recent Destinations** (logged-in users)
- **Favorites** (logged-in users) - Star icon to save
- **Location Details Card:**
  - Room name/number
  - Category
  - Floor (Ground for MVP)
  - "Navigate" button

---

### 4.3 AR Navigation Experience

#### 4.3.1 Navigation Flow
**Priority:** P0

**Phase 1: Localization (Critical)**
1. User taps "Navigate" from Explore screen
2. AR Camera view launches
3. **Localization Screen:**
   - Instruction overlay: "Scan your surroundings to locate yourself"
   - Visual feedback: Scanning progress indicator
   - Multiset `MapLocalizationManager` processes environment
   - Success indicator when localized
4. Only after successful localization → Proceed to Phase 2

**Phase 2: Destination Selection**
- Show destination confirmation dialog
- Display estimated distance/path
- "Start Navigation" button

**Phase 3: Active Navigation**
- AR overlays (managed by Multiset SDK):
  - Directional arrows
  - Path visualization
  - Waypoint markers
- UI Elements:
  - Current location indicator
  - Destination name header
  - Distance remaining
  - "End Navigation" button
  - Re-localize button (if tracking lost)

#### 4.3.2 Edge Cases
- **Localization Failure:** Retry option with tips
- **Tracking Lost:** Auto-prompt to re-scan environment
- **Wrong Floor/Building:** Alert user (future multi-floor support)

---

### 4.4 Profile Management

#### 4.4.1 Profile Screen (Bottom Nav Tab 3)
**Priority:** P0

**Guest Mode View:**
- "Sign Up / Sign In" prominent button
- Limited feature message

**Logged-In View:**
- Profile photo (editable)
- Name (editable)
- Email (display only)
- User Type (editable dropdown)
- **Options:**
  - Edit Profile
  - Favorites (saved destinations)
  - Navigation History
  - Settings
  - Help & Support
  - Submit Feedback
  - Log Out / Delete Account

---

### 4.5 Additional Screens

#### 4.5.1 Splash Screen
**Priority:** P0
- Waylio logo with tagline
- App initialization
- Auto-navigate to Onboarding (first launch) or Home

#### 4.5.2 Onboarding Tutorial
**Priority:** P1
- 3-4 swipeable screens:
  1. Welcome to Waylio
  2. How AR Navigation Works
  3. Scanning for Localization
  4. Getting Started
- Skip button
- "Get Started" → Sign In/Guest options

#### 4.5.3 Settings Screen
**Priority:** P2
- App version
- Permissions management (Camera)
- Notifications toggle (future)
- Language (future - default English)
- Clear cache
- Terms & Privacy Policy links

#### 4.5.4 Help & Support Screen
**Priority:** P1
- FAQ section:
  - How to use AR navigation
  - Localization tips
  - Troubleshooting
- Contact support (email link)
- Tutorial replay option

#### 4.5.5 Feedback Form Screen
**Priority:** P2
- Rating (1-5 stars)
- Feedback category dropdown:
  - Navigation Accuracy
  - App Performance
  - Feature Request
  - Bug Report
  - Other
- Text area (500 char limit)
- Submit button (email/backend integration)

---

## 5. User Stories & Acceptance Criteria

### 5.1 Authentication

**US-001: As a new user, I want to sign up so I can access personalized features**
- **AC1:** User can create account with email/password
- **AC2:** User can sign up with Google
- **AC3:** Profile type is selected during signup
- **AC4:** Email validation prevents duplicates

**US-002: As a returning user, I want to sign in quickly**
- **AC1:** Email/password login works
- **AC2:** Google sign-in works
- **AC3:** "Remember me" keeps user logged in

**US-003: As a visitor, I want to use the app without signing up**
- **AC1:** Guest mode allows immediate navigation access
- **AC2:** Guest users see signup prompts (non-intrusive)

---

### 5.2 Navigation

**US-004: As a user, I want to search for a specific room**
- **AC1:** Search bar accepts room numbers and names
- **AC2:** Results display with category labels
- **AC3:** Tapping result shows details with Navigate button

**US-005: As a user, I want to browse locations by category**
- **AC1:** Categories: Classrooms, Labs, Offices, Facilities
- **AC2:** Each category shows filtered list
- **AC3:** Location cards are tappable

**US-006: As a user, I want to navigate to my destination using AR**
- **AC1:** Localization phase requires environment scan
- **AC2:** Localization success shows visual confirmation
- **AC3:** AR overlays show path after localization
- **AC4:** Navigation updates in real-time
- **AC5:** User can end navigation anytime

**US-007: As a user, I need to re-localize if tracking is lost**
- **AC1:** App detects tracking loss
- **AC2:** Re-localize prompt appears
- **AC3:** User can re-scan environment without restarting

---

### 5.3 Profile & Personalization

**US-008: As a logged-in user, I want to save favorite locations**
- **AC1:** Star icon on location details
- **AC2:** Favorites appear in Profile and Explore
- **AC3:** Can remove from favorites

**US-009: As a user, I want to view my navigation history**
- **AC1:** History shows recent destinations with timestamps
- **AC2:** Can navigate to past locations quickly

**US-010: As a user, I want to update my profile**
- **AC1:** Can edit name and photo
- **AC2:** Can change user type
- **AC3:** Changes save persistently

---

## 6. Design Specifications

### 6.1 Design System

**Style:** Material Design 3 - Modern, Minimal, Sleek

**Color Scheme - Neutral Palette:**
- **Primary:** Charcoal Gray `#2C3E50` (trust, professionalism)
- **Secondary:** Soft Blue `#3498DB` (navigation, clarity)
- **Accent:** Warm Amber `#F39C12` (highlights, CTAs)
- **Background:** Light Gray `#ECF0F1`
- **Surface:** White `#FFFFFF`
- **Error:** Soft Red `#E74C3C`
- **Success:** Soft Green `#27AE60`

**Typography:**
- **Headings:** Roboto Bold
- **Body:** Roboto Regular
- **Captions:** Roboto Light

**Components:**
- Rounded corners (8dp radius)
- Elevated cards with subtle shadows
- Bottom navigation with icons + labels
- Floating Action Button for primary actions

### 6.2 Screen Mockup Descriptions

#### Home Screen
```
[Header: "Welcome back, [Name]" ]
[Large Card: "Start AR Navigation" with icon]
[Section: "Recent Destinations" - Horizontal scroll]
[Building Info Card: "USB - Ground Floor Available"]
```

#### Explore Screen
```
[Search Bar with icon]
[Category Chips: Classrooms | Labs | Offices | Facilities]
[List of Locations - Cards]
  - Room Number
  - Category badge
  - Favorite star icon
  - Navigate button
```

#### AR Navigation Screen
```
[Full-screen Camera View]
[Top Overlay: Destination name]
[Center: AR Path/Arrows from Multiset]
[Bottom UI:]
  - Distance remaining
  - End Navigation button
  - Re-localize button (if needed)
```

#### Profile Screen
```
[Profile Header: Photo, Name, Email]
[Menu Items:]
  - Edit Profile
  - Favorites
  - History
  - Settings
  - Help
  - Feedback
  - Log Out
```

---

## 7. Technical Implementation Plan

### 7.1 Phase 1: Foundation (Week 1-2)
**Deliverables:**
- [ ] Project setup with dependencies
- [ ] Bottom navigation structure
- [ ] Splash screen with branding
- [ ] Onboarding screens (static)
- [ ] Material Design 3 theme implementation

### 7.2 Phase 2: Authentication (Week 2-3)
**Deliverables:**
- [ ] Email/Password auth UI
- [ ] Google Sign-In integration
- [ ] Guest mode implementation
- [ ] User data model & local storage
- [ ] Profile creation flow

### 7.3 Phase 3: Core Navigation UI (Week 3-4)
**Deliverables:**
- [ ] Home screen with quick actions
- [ ] Explore screen with search
- [ ] Category browsing
- [ ] Location details screen
- [ ] Favorites & history (logged-in users)

### 7.4 Phase 4: Multiset SDK Integration (Week 4-6)
**Deliverables:**
- [ ] SDK initialization with API credentials
- [ ] Camera permissions handling
- [ ] Localization flow implementation
- [ ] AR camera view setup
- [ ] Navigation session management
- [ ] Tracking loss handling

### 7.5 Phase 5: Profile & Settings (Week 6-7)
**Deliverables:**
- [ ] Profile management screen
- [ ] Edit profile functionality
- [ ] Settings screen
- [ ] Help & Support content
- [ ] Feedback form with validation

### 7.6 Phase 6: Polish & Testing (Week 7-8)
**Deliverables:**
- [ ] Error handling & edge cases
- [ ] Loading states & animations
- [ ] User feedback (toasts, dialogs)
- [ ] End-to-end testing
- [ ] Performance optimization
- [ ] Beta testing with real users

---

## 8. Multiset SDK Implementation Details

### 8.1 Initialization
```kotlin
// In Application class or MainActivity
MultisetSdkManager.initialize(
    context = applicationContext,
    apiKey = "YOUR_API_KEY",
    mapId = "MSET_Z1RHU09TW3AX"
)
```

### 8.2 Localization Flow
```kotlin
// Step 1: Start localization session
MapLocalizationManager.startLocalization(
    onProgress = { progress ->
        // Update UI with scanning progress
    },
    onSuccess = { pose ->
        // User is localized, enable destination selection
        showDestinationSelection()
    },
    onFailure = { error ->
        // Show retry with helpful tips
        showLocalizationError(error)
    }
)

// Step 2: After destination selected
ModelSetTrackingManager.startNavigation(
    destination = selectedDestination,
    onPathUpdate = { path ->
        // AR overlays handled by SDK
    }
)
```

### 8.3 Permissions
```xml
<!-- AndroidManifest.xml -->
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.INTERNET" />
<uses-feature android:name="android.hardware.camera" android:required="true" />
<uses-feature android:name="android.hardware.camera.ar" android:required="true" />
```

---

## 9. Success Metrics (Post-Launch)

### 9.1 MVP Success Criteria
- [ ] 80% localization success rate on first attempt
- [ ] Average time to destination < 2 minutes for USB building
- [ ] User can complete navigation flow end-to-end without errors
- [ ] App crash rate < 1%
- [ ] 50+ beta users providing feedback

### 9.2 Future KPIs
- Daily Active Users (DAU)
- Navigation completion rate
- Average session duration
- User retention (7-day, 30-day)
- App store rating (target: 4.2+)

---

## 10. Risks & Mitigation

| Risk | Impact | Mitigation |
|------|--------|------------|
| Localization accuracy issues | High | Provide clear scanning instructions, retry mechanism |
| Camera permission denied | High | Explain AR need upfront, graceful degradation |
| Poor lighting conditions | Medium | Guide users to well-lit areas, adjust SDK sensitivity |
| SDK compatibility issues | High | Test on multiple devices, maintain SDK docs |
| User onboarding confusion | Medium | Comprehensive tutorial, in-app tooltips |
| Backend dependency (future) | Low | MVP uses only Multiset API, no custom backend |

---

## 11. Compliance & Privacy

### 11.1 Data Collection
- Email, name, profile photo (with consent)
- Navigation history (local storage)
- Camera frames (processed locally by SDK, not stored)

### 11.2 Privacy Policy Requirements
- Transparent data usage disclosure
- Camera access explanation
- User data deletion option
- GDPR compliance (if applicable)

### 11.3 Permissions Rationale
- **Camera:** Required for AR navigation and localization
- **Internet:** Required for Multiset SDK API calls

---

---

## 13. Technical Decisions (Confirmed)

### 13.1 Backend & Authentication
**Decision:** Firebase (Option A)

**Implementation:**
- **Firebase Authentication:**
  - Email/Password authentication
  - Google Sign-In integration
  - Guest mode (anonymous auth or local flag)
- **Firebase Firestore:**
  - User profiles collection
  - Favorites subcollection per user
  - Navigation history subcollection per user
- **Offline Persistence:** Firestore offline caching enabled

**Rationale:**
- Fastest MVP implementation
- Built-in authentication providers
- Cloud sync across devices
- Excellent offline support with local caching

---

### 13.2 Room/Destination Data
**Decision:** JSON File in Assets (Option B)

**File Location:** `app/src/main/assets/destinations.json`

**Sample Data Structure:**
```json
{
  "building": "USB",
  "floor": "Ground",
  "destinations": [
    {
      "id": "usb_main",
      "name": "Main Hall",
      "roomNumber": "USB-Main",
      "category": "Facility",
      "description": "Main entrance hall",
      "coordinates": null
    },
    {
      "id": "usb_entrance",
      "name": "Entrance",
      "roomNumber": "USB-Entrance",
      "category": "Facility",
      "description": "Building entrance",
      "coordinates": null
    },
    {
      "id": "usb_left_exit",
      "name": "Left Exit",
      "roomNumber": "USB-Left-Exit",
      "category": "Facility",
      "description": "Left side exit",
      "coordinates": null
    },
    {
      "id": "usb_right_wing",
      "name": "Right Wing",
      "roomNumber": "USB-Right-Wing",
      "category": "Facility",
      "description": "Right wing corridor",
      "coordinates": null
    },
    {
      "id": "usb_hall_1",
      "name": "Hall 1",
      "roomNumber": "USB-Hall-1",
      "category": "Classroom",
      "description": "Lecture hall 1",
      "coordinates": null
    },
    {
      "id": "usb_hall_2",
      "name": "Hall 2",
      "roomNumber": "USB-Hall-2",
      "category": "Classroom",
      "description": "Lecture hall 2",
      "coordinates": null
    },
    {
      "id": "usb_hall_3",
      "name": "Hall 3",
      "roomNumber": "USB-Hall-3",
      "category": "Classroom",
      "description": "Lecture hall 3",
      "coordinates": null
    }
  ]
}
```

**Categories:**
- `Classroom` - Lecture halls, classrooms
- `Laboratory` - Computer labs, research labs
- `Office` - Faculty offices, administrative offices
- `Facility` - Restrooms, cafeteria, entrances, exits, halls

**Rationale:**
- Easy to update without code changes
- Works fully offline
- Can migrate to Firestore later for remote updates
- Lightweight for MVP

---

### 13.3 Offline Capabilities
**Decision:** Full Offline Support Required

**Implementation Strategy:**
1. **Room Data:** Bundled in assets (always available offline)
2. **Multiset Maps:** SDK must cache map data locally after first download
3. **User Data:** Firestore offline persistence enabled
4. **Authentication:**
   - Firebase caches auth state (stays logged in offline)
   - New logins require internet
   - Guest mode works fully offline

**Offline User Experience:**
- ✅ Browse and search rooms
- ✅ AR navigation (after map cached)
- ✅ View favorites and history (syncs when online)
- ❌ New login/signup (requires internet)
- ❌ Profile photo upload (requires internet)

**Sync Strategy:**
- Firestore automatically syncs when connection restored
- Show offline indicator in UI
- Queue actions (favorites, history) for sync

---

### 13.4 API Key Management
**Decision:** Placeholder with `local.properties` (Option C)

**Implementation:**

**File:** `local.properties` (gitignored)
```properties
# Multiset SDK Credentials
multiset.api.key=YOUR_MULTISET_API_KEY_HERE
multiset.map.id=MSET_Z1RHU09TW3AX
```

**File:** `app/build.gradle.kts`
```kotlin
android {
    defaultConfig {
        // Load from local.properties
        val properties = Properties()
        properties.load(project.rootProject.file("local.properties").inputStream())

        buildConfigField("String", "MULTISET_API_KEY",
            "\"${properties.getProperty("multiset.api.key", "PLACEHOLDER_KEY")}\"")
        buildConfigField("String", "MULTISET_MAP_ID",
            "\"${properties.getProperty("multiset.map.id", "MSET_Z1RHU09TW3AX")}\"")
    }

    buildFeatures {
        buildConfig = true
    }
}
```

**Usage in Code:**
```kotlin
MultisetSdkManager.initialize(
    context = applicationContext,
    apiKey = BuildConfig.MULTISET_API_KEY,
    mapId = BuildConfig.MULTISET_MAP_ID
)
```

**Security:**
- `local.properties` is in `.gitignore` (not committed)
- Placeholder key for development
- Production key added before release

---

### 13.5 Analytics & Tracking
**Decision:** No Analytics for MVP (Option B)

**Rationale:**
- Focus on core functionality first
- Reduce dependencies and complexity
- Can add Firebase Analytics post-launch
- Manual user feedback via in-app form sufficient for MVP

**Post-MVP Consideration:**
- Firebase Analytics (if already using Firebase)
- Track: screen views, navigation success rate, localization attempts

---

### 13.6 Bottom Navigation Implementation
**Decision:** Keep Existing Navigation IDs, Update Labels

**Mapping:**
| Navigation ID | Display Label | Functionality |
|---------------|---------------|---------------|
| `navigation_home` | **Home** | Welcome screen, quick actions, recent destinations |
| `navigation_dashboard` | **Explore** | Search rooms, browse categories, favorites |
| `navigation_notifications` | **Profile** | User profile, settings, history, logout |

**Implementation:**
- Keep existing fragment/ViewModel structure
- Update `res/values/strings.xml` labels
- Update menu icons to match functionality
- Implement PRD-specified features in each fragment

---

### 12. References
- [Multiset Android Native Docs](https://docs.multiset.ai/native-support/android-native)
- [Multiset SDK GitHub](https://github.com/MultiSet-AI/multiset-android-sdk)
- [Material Design 3 Guidelines](https://m3.material.io/)
- [Firebase Android Documentation](https://firebase.google.com/docs/android/setup)
- [Firebase Offline Capabilities](https://firebase.google.com/docs/firestore/manage-data/enable-offline)

---