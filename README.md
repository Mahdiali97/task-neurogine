# Product Catalog Mobile App

A lightweight product catalog app built with Flutter, consuming the DummyJSON API. Developed as part of the technical assessment for the Junior Mobile Developer role at Neurogine.

---

## Tech Stack & Libraries
- **Framework:** Flutter (Dart 3+)
- **Networking:** `http` (lightweight, standard HTTP client)
- **State Management:** `ChangeNotifier` / `ListenableBuilder` (native Flutter reactive state without heavy external framework bloat)
- **Image Handling:** Network images with loading indicators and error fallback widgets
- **Testing:** `flutter_test`, `http/testing` (`MockClient`)

---

## Architecture Overview

I structured the project using a clear two-layer architecture separating **Data** and **Presentation**:

```text
lib/
├── data/
│   ├── models/
│   │   └── product.dart               # Product & ProductResponse models with fromJson
│   └── services/
│       └── product_api_service.dart   # HTTP client, endpoint calls, and exception mapping
├── presentation/
│   ├── controllers/
│   │   └── product_controller.dart    # View logic, pagination state, debouncing, error handling
│   ├── screens/
│   │   ├── product_list_screen.dart   # Main catalog list, search field, pull-to-refresh
│   │   └── product_detail_screen.dart # Detail page with image gallery and product info
│   └── widgets/
│       ├── product_item_card.dart     # List item layout with thumbnail & price
│       ├── error_state_widget.dart    # Error banner with retry action
│       └── empty_state_widget.dart    # Zero-results feedback
└── main.dart                          # Application entry point & theme setup
```

### Why this structure?
- **Testability:** By keeping `ProductApiService` independent of the UI and accepting an optional `http.Client`, we can inject a `MockClient` during unit testing without hitting real network servers.
- **Maintainability:** Business logic (tracking pagination offsets, debouncing search keystrokes, determining view states) lives entirely in `ProductController`, leaving UI widgets focused solely on rendering.

---

## Key Design Decisions

### 1. Server-Side vs. Client-Side Search
I opted for **server-side search** using `https://dummyjson.com/products/search?q={query}`.
- **Why:** In real-world applications with large catalogs, loading the entire dataset into memory for local filtering degrades performance and drains battery/data. Server-side search ensures the client only receives relevant records, while maintaining support for pagination.
- **Debouncing:** Implemented a 400ms debounce timer on search input to prevent unnecessary requests on every keystroke.

### 2. State Handling
The catalog UI explicitly handles four view states:
1. **Loading:** Shown during initial data fetch.
2. **Success:** Renders the scrollable product list with infinite pagination.
3. **Empty:** Shown when a search query returns zero matching records.
4. **Error:** Displays network/server errors with a **Retry** button allowing users to recover without restarting the app.

---

## How to Run

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- A connected device, emulator, or Chrome browser

### Commands
```bash
# 1. Clone repository
git clone <YOUR_PUBLIC_REPO_URL>
cd <REPO_FOLDER>

# 2. Get dependencies
flutter pub get

# 3. Run the app
flutter run

# 4. Run unit tests
flutter test
```

## AI Usage Disclosure
Per assessment guidelines, AI assistance was used strictly for research and syntax reference (specifically verifying the DummyJSON API payload structure and setting up initial test mock patterns). All core logic, architecture layout, state management, and UI implementation were completed and verified independently.

## Known Limitations / Future Work
- [ ] Add offline caching using a local database (e.g., Hive or SQLite).
- [ ] Implement shimmer loading skeletons instead of the circular progress indicator.
- [ ] Add category filter chips for faster product discovery.
