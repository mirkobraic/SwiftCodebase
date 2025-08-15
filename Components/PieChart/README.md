# PieChart

An interactive pie chart component built with SwiftUI for iOS applications.

## Features

- Interactive slices with tap-to-highlight functionality
- Dynamic data with customizable colors and amounts
- Built-in legend with percentages
- Smooth animations and responsive design

## Usage

```swift
let data = PieChartData(dataChunks: [
    PieDataChunk(title: "Rent", amount: 1300, color: .green),
    PieDataChunk(title: "Transport", amount: 500, color: .blue),
    PieDataChunk(title: "Education", amount: 300, color: .yellow)
])

PieChartView(data: data, backgroundColor: .black)
```

## Screenshot

<img height="600" alt="PieChart" src="https://github.com/user-attachments/assets/7fb06608-57d3-4277-9f69-d8edca29961a" />
