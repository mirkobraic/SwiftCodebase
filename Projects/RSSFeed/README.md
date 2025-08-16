# RSS Feed

A native iOS app for reading and managing RSS feeds with a clean, modern interface.

## Features

- **Feed Management**: Add, remove, and organize RSS feeds
- **Article Reading**: Browse articles from your feeds with rich content display
- **Favorites**: Mark feeds as favorites for quick access
- **Read Status**: Track which articles you've already read
- **Offline Storage**: Feeds and read status are persisted locally
- **Modern UI**: Built with UIKit and Compositional Layouts

## Architecture

The app follows a clean architecture pattern with clear separation of concerns:

### Core Components

- **Models**: `RssFeed` and `RssItem` represent the core data structures
- **Services**: 
  - `RssFeedService` - Main business logic for feed operations
  - `NetworkService` - Handles HTTP requests
  - `RSSParser` - Parses RSS/XML content
  - `UserDefaultsService` - Local data persistence
- **ViewModels**: MVVM pattern with `FeedListViewModel` and `FeedDetailsViewModel`
- **ViewControllers**: UI layer with `FeedListViewController` and `FeedDetailsViewController`
- **Coordinators**: Navigation flow management with `MainCoordinator`

### Key Design Patterns

- **MVVM**: Separation of view logic and business logic
- **Repository Pattern**: Abstract data access through `RssFeedRepositoryType`
- **Coordinator Pattern**: Centralized navigation management
- **Combine**: Reactive programming for data binding
- **Compositional Layouts**: Modern collection view layouts
