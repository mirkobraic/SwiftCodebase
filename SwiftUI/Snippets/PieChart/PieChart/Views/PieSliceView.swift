//
//  PieSliceView.swift
//  PieChart
//
//  Created by Mirko Braic on 29.08.2023..
//

import SwiftUI

struct PieSliceView: View {
    var pieSliceData: PieSliceData

    var midRadians: Double {
          return Double.pi / 2.0 - (pieSliceData.startAngle + pieSliceData.endAngle).radians / 2.0
      }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Path { path in
                    let size: CGFloat = min(geometry.size.width, geometry.size.height)
                    let radius = size / 2
                    let center = CGPoint(x: size / 2, y: size / 2)

                    path.move(to: center)
                    path.addArc(
                        center: center,
                        radius: radius,
                        startAngle: Angle(degrees: -90.0) + pieSliceData.startAngle,
                        endAngle: Angle(degrees: -90.0) + pieSliceData.endAngle,
                        clockwise: false)

                }
                .fill(pieSliceData.color)

                Text(pieSliceData.text)
                    .position(
                        x: geometry.size.width * 0.5 * CGFloat(1.0 + 0.78 * cos(midRadians)),
                        y: geometry.size.height * 0.5 * CGFloat(1.0 - 0.78 * sin(midRadians))
                    )
                    .foregroundColor(Color.white)
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

struct PieSliceView_Previews: PreviewProvider {
    static var previews: some View {
        PieSliceView(pieSliceData: PieSliceData(startAngle: Angle(degrees: 45), endAngle: Angle(degrees: 90), color: .red, text: "45%"))
    }
}
