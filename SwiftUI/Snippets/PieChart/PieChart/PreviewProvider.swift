//
//  PreviewProvider.swift
//  PieChart
//
//  Created by Mirko Braic on 05.09.2023..
//

import SwiftUI

extension PreviewProvider {
    static var dev: DeveloperPreview {
        return DeveloperPreview.shared
    }
}

class DeveloperPreview {
    static let shared = DeveloperPreview()
    private init() { }
    
    let pieChartData = PieChartData(dataChunks: [PieDataChunk(title: "Rent", amount: 1300, color: .green),
                                                        PieDataChunk(title: "Transport", amount: 500, color: .blue),
                                                        PieDataChunk(title: "Education", amount: 300, color: .yellow)])
}
