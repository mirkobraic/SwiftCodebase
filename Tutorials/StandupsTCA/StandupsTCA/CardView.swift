//
//  CardView.swift
//  StandupsTCA
//
//  Created by Mirko Braić on 01.03.2024..
//

import SwiftUI

struct CardView: View {
    let standup: Standup
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(standup.title)
                .font(.headline)
            Spacer()
            HStack {
                Label("\(standup.attendees.count)", systemImage: "person.3")
                Spacer()
                Label(standup.duration.formatted(.units()), systemImage: "clock")
                    .labelStyle(.trailingIcon)
            }
            .font(.caption)
        }
        .padding()
        .foregroundColor(standup.theme.accentColor)
    }
}

struct TrailingIconLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.title
            configuration.icon
        }
    }
}

extension LabelStyle where Self == TrailingIconLabelStyle {
    static var trailingIcon: Self { Self() }
}
