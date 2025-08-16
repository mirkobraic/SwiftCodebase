# DecodingWrappers

A collection of property wrappers that simplify JSON decoding in Swift by providing custom decoding logic for common scenarios.

## What it does

This collection includes four property wrappers that handle specific decoding challenges:

### 1. DecodeBool
Converts various data types to boolean values during JSON decoding.

**Supported inputs:**
- `"true"`, `"false"`, `"yes"`, `"no"`, `"1"`, `"0"` (strings)
- `1`, `0` (integers)
- `1.0`, `0.0` (doubles)
- `true`, `false` (native booleans)

### 2. DecodeHexColor
Converts hex color strings to UIColor objects.

**Supported formats:**
- `"#FF0000"` (6-digit hex)
- `"#FF0000FF"` (8-digit hex with alpha)
- `"FF0000"` (without # prefix)

### 3. DecodeImage
Downloads images from URLs and provides them as a Combine publisher.

**Features:**
- Automatic image fetching
- Configurable fetch timing (AutoFetch/LazyFetch)
- Combine integration for reactive updates

### 4. DecodingDefault
Provides default values when JSON decoding fails.

**Built-in providers:**
- `EmptyString`: Provides `""` for failed string decoding
- `NilString`: Provides `nil` for failed optional string decoding

## How to use

### DecodeBool
```swift
struct User: Codable {
    @DecodeBool var isActive: Bool
    @DecodeBool var isVerified: Bool
}

// JSON: {"isActive": "yes", "isVerified": 1}
// Result: isActive = true, isVerified = true
```

### DecodeHexColor
```swift
struct Theme: Codable {
    @DecodeHexColor var primaryColor: UIColor?
    @DecodeHexColor var accentColor: UIColor?
}

// JSON: {"primaryColor": "#FF0000", "accentColor": "#00FF00"}
```

### DecodeImage
```swift
struct Profile: Codable {
    @ImageUrl<AutoFetch> var avatar: String // Fetches immediately
    @ImageUrl<LazyFetch> var coverPhoto: String // Fetches when accessed
    
    // Access the image via projected value
    var avatarPublisher: AnyPublisher<UIImage?, Never> {
        $avatar
    }
}
```

### DecodingDefault
```swift
struct Settings: Codable {
    @DecodingDefault<EmptyString> var name: String
    @DecodingDefault<NilString> var description: String?
}

// JSON: {"name": null, "description": null}
// Result: name = "", description = nil
```
