# ArrayTableViewController

A generic, reusable table view controller that displays an array of items with selection functionality.

## What it does

`ArrayTableViewController` is a generic UIViewController subclass that wraps a UITableView to display a list of items. It provides:

- Single selection with visual feedback (checkmark)
- Callback when an item is selected
- Support for any type that conforms to `CustomStringConvertible` and `Equatable`
- Automatic cell configuration using the item's description

## How to use

```swift
// 1. Define your data type (must conform to CustomStringConvertible & Equatable)
enum TestEnum: CustomStringConvertible, CaseIterable {
    case one, two, three, four
    
    var description: String {
        switch self {
        case .one: return "One"
        case .two: return "Two two"
        case .three: return "Three"
        case .four: return "Four"
        }
    }
}

// 2. Create the view controller
let vc = ArrayTableViewController(
    allCases: TestEnum.allCases, 
    initialSelection: .three
)

// 3. Handle selection
vc.rowSelected = { item in
    print("\(item) selected.")
}

// 4. Present the view controller
present(vc, animated: true)
```