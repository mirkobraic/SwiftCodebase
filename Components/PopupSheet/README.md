## PopupSheet

A SwiftUI view modifier for presenting a centered popup with a subtle scale + fade transition and a dimmed backdrop. Built on top of `fullScreenCover`.

### Features
- **Dimming backdrop** with tap-to-dismiss
- **Close button** (top-right)
- **Custom content**: pass any SwiftUI view
- **Simple API** using an `Identifiable` item binding

### Usage
```swift
@State private var popupData: PopupData?

VStack {
    Button("Show popup") { popupData = .testData }
}
.popupSheet(item: $popupData) { data in
    CustomPopupView(data: data)
}
```

### Demo

https://github.com/user-attachments/assets/4bfc40fc-dce3-4a64-8478-9f81f9dba245

