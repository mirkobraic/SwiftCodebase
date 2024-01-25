//
//  PieChartView.swift
//  PieChart
//
//  Created by Mirko Braic on 29.08.2023..
//

import SwiftUI

struct PieChartView: View {
    let data: PieChartData
    var backgroundColor: Color

    let innerRadiusFraction = 0.5
    let widthFraction: CGFloat = 0.5

    @State private var selection: PieDataChunk? = nil

    var slices: [PieSliceData] {
        var endDeg: Double = 0
        var tempSlices: [PieSliceData] = []

        for chunk in data.dataChunks {
            let degrees: Double = chunk.percentage * 360
            tempSlices.append(PieSliceData(startAngle: Angle(degrees: endDeg),
                                           endAngle: Angle(degrees: endDeg + degrees),
                                           color: chunk.color,
                                           text: String(format: "%.0f%%", chunk.percentage * 100)))
            endDeg += degrees
        }
        return tempSlices
    }

    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack {
                    ForEach(Array(zip(data.dataChunks, slices)), id: \.0) { (chunk, slice) in
                        PieSliceView(pieSliceData: slice)
                            .onTapGesture {
                                selection = chunk == selection ? nil : chunk
                            }
                            .scaleEffect(chunk == selection ? 1.03 : 1)
                            .animation(.spring(), value: selection)
                    }
                    .padding()

                    Circle()
                        .fill(backgroundColor)
                        .frame(width: geometry.size.width * innerRadiusFraction, height: geometry.size.width * innerRadiusFraction)

                    VStack {
                        Text(selection?.title ?? "Total")
                            .font(.title)
                            .foregroundColor(Color.gray)

                        Text(selection == nil ? data.totalValue.rounded() : selection?.amount ?? 0, format: .currency(code: "USD"))
                            .font(.title)
                    }
                }
                PieChartRows(data: data)
            }
            .background(backgroundColor)
            .foregroundColor(.white)
        }
    }
}

struct PieChartView_Previews: PreviewProvider {
    static var previews: some View {
        PieChartView(data: dev.pieChartData, backgroundColor: .black)
    }
}
