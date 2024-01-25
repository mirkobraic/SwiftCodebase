//
//  ContentView.swift
//  PieChart
//
//  Created by Mirko Braic on 29.08.2023..
//

import SwiftUI

struct ContentView: View {
    let data = PieChartData(dataChunks: [PieDataChunk(title: "Rent", amount: 1300, color: .green),
                                         PieDataChunk(title: "Transport", amount: 500, color: .blue),
                                         PieDataChunk(title: "Education", amount: 300, color: .yellow)])

    var body: some View {
        PieChartView(data: data, backgroundColor: .black)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
