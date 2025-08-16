# UserDefaultsWrapper

A property wrapper that simplifies UserDefaults access with type safety and Combine integration.

## What it does

The `UserDefault` property wrapper provides:

- Type-safe access to UserDefaults
- Automatic persistence of property changes
- Combine publisher for reactive updates
- Support for optional values with automatic cleanup
- Default value handling

## How to use

### Basic Usage
```swift
class Settings {
    @UserDefault(key: "username", defaultValue: "")
    var username: String
    
    @UserDefault(key: "isLoggedIn", defaultValue: false)
    var isLoggedIn: Bool
    
    @UserDefault(key: "lastLoginDate", defaultValue: Date())
    var lastLoginDate: Date
}

let settings = Settings()
settings.username = "john_doe" // Automatically saved to UserDefaults
```

### Optional Values
```swift
class UserProfile {
    @UserDefault(key: "userToken")
    var userToken: String? // Automatically handles nil values
    
    @UserDefault(key: "preferences", defaultValue: [:])
    var preferences: [String: Any]
}
```

### Reactive Updates with Combine
```swift
class ThemeManager {
    @UserDefault(key: "isDarkMode", defaultValue: false)
    var isDarkMode: Bool
    
    init() {
        // Subscribe to changes
        $isDarkMode
            .sink { isDark in
                self.updateTheme(isDark: isDark)
            }
            .store(in: &cancellables)
    }
}
```

### Custom UserDefaults Container
```swift
class AppSettings {
    static let shared = AppSettings()
    
    @UserDefault(key: "apiKey", defaultValue: "", container: .standard)
    var apiKey: String
    
    @UserDefault(key: "debugMode", defaultValue: false, container: UserDefaults(suiteName: "debug"))
    var debugMode: Bool
}
```
