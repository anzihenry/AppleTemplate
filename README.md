# AppleTemplate

A multi-platform Apple application template built with SwiftUI and The Composable Architecture (TCA).

## Platforms

- iOS 17+
- macOS 14+
- watchOS 10+
- tvOS 17+

## Tech Stack

| Component | Technology |
|-----------|------------|
| UI Framework | SwiftUI |
| Architecture | The Composable Architecture (TCA) 1.25+ |
| Dependency Injection | swift-dependencies |
| Navigation | swift-navigation |
| Data Persistence | SwiftData |
| Package Manager | Swift Package Manager |

## Project Structure

```
AppleTemplate/
├── Packages/
│   ├── AppCore/                 # Core business logic (platform-agnostic)
│   │   ├── Features/            # TCA feature reducers
│   │   ├── Models/              # Data models
│   │   ├── Services/            # Service protocols & dependencies
│   │   └── Utilities/           # Helper extensions
│   ├── AppUI/                   # Shared SwiftUI components
│   │   ├── Components/          # Reusable UI components
│   │   ├── Styles/              # Theme & styling
│   │   ├── Modifiers/           # Custom ViewModifiers
│   │   └── Resources/           # Localizations
│   └── AppData/                 # Data layer
│       ├── Persistence/         # SwiftData models & container
│       ├── Network/             # API client
│       ├── Storage/             # Keychain & UserDefaults
│       └── Mocks/               # Mock implementations
├── Platforms/
│   ├── iOS/                     # iOS app entry
│   ├── macOS/                   # macOS app entry
│   ├── watchOS/                 # watchOS app entry
│   └── tvOS/                    # tvOS app entry
└── .github/workflows/           # CI/CD
```

## Getting Started

### Prerequisites

- Xcode 15.2+
- Swift 5.10+
- macOS 14+

### Setup

1. Clone the repository
2. Open `AppleTemplate.xcodeproj` in Xcode
3. Select your target platform
4. Build and run

### Package Resolution

Xcode will automatically resolve SPM dependencies on first build. To manually resolve:

```bash
cd Packages/AppCore && swift package resolve
cd Packages/AppUI && swift package resolve
cd Packages/AppData && swift package resolve
```

## Architecture

### TCA Pattern

Each feature follows the TCA pattern:

```swift
@Reducer
struct Feature {
    @ObservableState
    struct State: Equatable {
        // Feature state
    }

    enum Action {
        // Feature actions
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            // Handle actions
        }
    }
}
```

### Dependency Injection

Services are registered using `swift-dependencies`:

```swift
struct MyService: TestDependencyKey {
    static let liveValue = MyService(/* real implementation */)
    static let testValue = MyService(/* mock implementation */)
}

// Usage in reducer
@Dependency(\.myService) var myService
```

### Testing

Use `TestStore` for deterministic testing:

```swift
@Test
func testFeature() async {
    let store = TestStore(initialState: Feature.State()) {
        Feature()
    } withDependencies: {
        $0.myService.fetch = { [] }
    }

    await store.send(.loadButtonTapped)
    await store.receive(.loadResponse(.success([]))) {
        $0.items = []
    }
}
```

## Code Quality

### SwiftLint

```bash
brew install swiftlint
swiftlint lint
```

### SwiftFormat

```bash
brew install swiftformat
swiftformat .
```

## CI/CD

GitHub Actions runs on every push and PR:

- **Lint**: SwiftLint code analysis
- **Format**: SwiftFormat style check
- **Build**: Xcode build for iOS and macOS
- **Test**: Unit test execution

## Adding a New Feature

1. Create a new directory in `Packages/AppCore/Sources/AppCore/Features/`
2. Add `FeatureNameFeature.swift` with State, Action, and Reducer
3. Add `FeatureNameView.swift` with the SwiftUI view
4. Compose into `AppFeature` using `Scope` or `forEach`
5. Add to the appropriate platform entry point

## License

MIT
