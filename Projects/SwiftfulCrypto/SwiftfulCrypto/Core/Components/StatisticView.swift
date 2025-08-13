//
//  StatisticView.swift
//  SwiftfulCrypto
//
//  Created by Mirko Braic on 27.07.2023..
//

import SwiftUI

struct StatisticView: View {
    let statistic: StatisticModel

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(statistic.title)
                .font(.caption)
                .foregroundColor(.theme.secondaryText)
            Text(statistic.value)
                .font(.headline)
                .foregroundColor(.theme.accent)
            HStack(spacing: 4) {
                Image(systemName: "triangle.fill")
                    .font(.caption2)
                    .rotationEffect(
                        Angle(degrees: (statistic.percentageChange ?? 0) >= 0 ? 0 : 180)
                    )
                Text(statistic.percentageChange?.asPercentString() ?? "")
                    .font(.caption)
                .bold()
            }
            .foregroundColor((statistic.percentageChange ?? 0) >= 0 ? Color.theme.green : Color.theme.red)
            .opacity(statistic.percentageChange == nil ? 0 : 1)
        }
    }
}

struct StatisticView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticView(statistic: dev.statisticModel1)
            .previewLayout(.sizeThatFits)
        StatisticView(statistic: dev.statisticModel2)
            .previewLayout(.sizeThatFits)
        StatisticView(statistic: dev.statisticModel3)
            .previewLayout(.sizeThatFits)
    }
}
