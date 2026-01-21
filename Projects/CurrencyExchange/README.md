# CurrencyExchange

SwiftUI iOS app for USDc <-> fiat conversions, built with a clean, modular architecture.

### Demo

[Demo video](https://github.com/user-attachments/assets/1a776e5e-a5f2-44de-b32b-0d8bde101486)

## Features
- **USDc <-> fiat conversion** with live rates
- **Currency selector** with tickers, flags and icons
- **Configurable exchange policies** to easily reflect business strategy

## Requirements
- **iOS**: 18.0+
- **Swift**: 6.2 toolchain

## Architecture
The app follows a layered, modular design using SPM packages.

```
CurrencyExchange/
├─ CurrencyExchange.xcodeproj
├─ CurrencyExchange/              # App target
├─ PresentationLayer/             # SPM package (depends on DomainLayer, Factory)
├─ DomainLayer/                   # SPM package (pure domain + tests)
└─ DataLayer/                     # SPM package (depends on DomainLayer)
```

- **PresentationLayer**: SwiftUI views, view models, UI components, DI container
- **DomainLayer**: Use cases, data layer contracts, pure models, business rules
- **DataLayer**: API client, endpoints, networking utilities
