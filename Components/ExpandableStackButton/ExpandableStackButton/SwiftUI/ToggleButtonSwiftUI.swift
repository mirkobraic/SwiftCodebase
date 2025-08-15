//
//  ToggleButtonSwiftUI.swift
//  ExpandableStackButton
//
//  Created by Mirko Braić on 15.08.2025..
//

import SwiftUI

struct ToggleButtonSwiftUI: View {
    @Binding var isOn: Bool
    let buttonSize: CGFloat
    
    var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                isOn.toggle()
            }
        } label: {
            Image(systemName: isOn ? "circle.fill" : "circle")
                .font(.system(size: 16))
                .foregroundColor(.primary)
        }
        .frame(width: buttonSize, height: buttonSize)
        .background(isOn ? Color(.systemGray3) : Color.white)
        .cornerRadius(8)
        .shadow(radius: 8)
    }
}
