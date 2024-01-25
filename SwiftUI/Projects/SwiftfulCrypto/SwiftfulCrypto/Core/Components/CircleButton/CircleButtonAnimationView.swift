//
//  CircleButtonAnimationView.swift
//  SwiftfulCrypto
//
//  Created by Mirko Braic on 25.07.2023..
//

import SwiftUI

struct CircleButtonAnimationView: View {
    @Binding var animate: Bool

    var body: some View {
        Circle()
            .stroke(lineWidth: 1)
            .scale(animate ? 1 : 0)
            .opacity(animate ? 0: 1)
            .animation(animate ? Animation.easeOut(duration: 0.6) : .none, value: animate)
    }
}

struct CircleButtonAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        CircleButtonAnimationView(animate: .constant(false))
            .previewLayout(.sizeThatFits)
            .foregroundColor(.red)
            .frame(width: 200, height: 200)
    }
}
