# RAWGExplorer

A video game discovery and exploration app built with SwiftUI, featuring game search, details, and genre-based browsing using the RAWG API.

## Features

- **Game Discovery**: Browse and search for video games
- **Game Details**: Comprehensive game information and screenshots
- **Genre Filtering**: Filter games by genre categories
- **RAWG API Integration**: Real-time game data from RAWG database
- **Modern UI**: Clean, responsive SwiftUI interface
- **Search Functionality**: Find games by name and criteria

## Architecture

### Models
- **Game**: Core game data structure with ID, name, image, and genres
- **GameDetails**: Extended game information and metadata
- **Genre**: Game genre classification and filtering
- **GamesResponse**: API response wrapper for pagination

### Core Components
- **UI**: SwiftUI views and components
- **Managers**: API and data management
- **Extensions**: Utility extensions and helpers
- **AppStart**: Application initialization and setup

## Technical Implementation

### API Integration
- RAWG API for game data
- JSON decoding with Codable
- Async/await for network requests
- Error handling and loading states

### SwiftUI Features
- Modern declarative UI
- Responsive design
- Navigation and routing
- Image loading and caching

## API Usage

The app integrates with the RAWG API for:
- Game search and discovery
- Game details and metadata
- Genre information
- Game screenshots and media

## Features

### Game Browsing
- Browse popular games
- Search by game name
- Filter by genre
- View game details

### Game Details
- Comprehensive game information
- Screenshots and media
- Genre classifications
- Release information

### User Experience
- Smooth navigation
- Loading states
- Error handling
- Responsive design
