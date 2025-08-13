//
//  PieChartData.swift
//  PieChart
//
//  Created by Mirko Braic on 29.08.2023..
//

import SwiftUI

struct PieDataChunk: Identifiable, Hashable {
    let id = UUID()
    var title: String
    var amount: Double
    var color: Color
    var percentage: Double

    init(title: String, amount: Double, color: Color) {
        self.title = title
        self.amount = amount
        self.color = color
        self.percentage = 0
    }
}

struct PieChartData {
    private(set) var dataChunks: [PieDataChunk]
    var totalValue: Double

    init(dataChunks: [PieDataChunk]) {
        totalValue = dataChunks.reduce(0) { $0 + $1.amount }
        self.dataChunks = dataChunks
        for i in self.dataChunks.indices {
            self.dataChunks[i].percentage = dataChunks[i].amount / totalValue
        }
    }
}
