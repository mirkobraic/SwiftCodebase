# DynamicLocalization

A runtime localization system that allows downloading and switching between different language bundles at runtime.

## What it does

This system provides dynamic localization capabilities by:

- Fetching localization data from a remote source
- Generating `.strings` files and language bundles at runtime
- Switching between languages without app restart
- Providing Combine publishers for reactive language changes
- Storing language bundles in the app's documents directory

## How to use

### 1. Set up the LocalizationFetcher
```swift
class MyLocalizationFetcher: LocalizationFetcher {
    func fetchLocalization() -> AnyPublisher<RuntimeLocalization, Error> {
        // Return your localization data
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: RuntimeLocalization.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
```

### 2. Initialize the LocalizationManager
```swift
let fetcher = MyLocalizationFetcher()
let languagePublisher = CurrentValueSubject<String, Never>("en")

LocalizationManager.shared.fetchLocalizations(
    with: fetcher, 
    currentLanguagePublisher: languagePublisher.eraseToAnyPublisher()
)
```

### 3. Switch languages
```swift
// Switch to Croatian
languagePublisher.send("hr")

// Switch to English
languagePublisher.send("en")
```

### 4. Use localized strings
```swift
// Add the localized() extension to String
extension String {
    func localized() -> String {
        return NSLocalizedString(self, bundle: LocalizationManager.shared.getCurrentBundle() ?? Bundle.main, comment: "")
    }
}

// Use it in your app
let text = "menu.live".localized()
```

## Key Components

- **LocalizationManager**: Singleton that manages the localization system
- **LocalizationFetcher**: Protocol for fetching localization data
- **RuntimeLocalization**: Data structure for localization content
- **String Extension**: Convenience method for accessing localized strings

