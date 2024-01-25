//
//  PieChartRow.swift
//  PieChart
//
//  Created by Mirko Braic on 29.08.2023..
//

import SwiftUI

struct PieChartRows: View {
    var data: PieChartData

    var body: some View {
        VStack {
            ForEach(data.dataChunks) { chunk in
                HStack {
                    RoundedRectangle(cornerRadius: 5.0)
                        .fill(chunk.color)
                        .frame(width: 20, height: 20)
                    Text(chunk.title)
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text(chunk.amount, format: .currency(code: "USD"))
                        Text(String(format: "%.0f%%", chunk.percentage * 100))
                            .foregroundColor(Color.gray)
                    }
                }
            }
        }
        .padding()
    }
}

struct PieChartRow_Previews: PreviewProvider {
    static var previews: some View {
        PieChartRows(data: dev.pieChartData)
    }
}
