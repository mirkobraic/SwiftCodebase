//
//  LazyView.swift
//  SwiftfulCrypto
//
//  Created by Mirko Braic on 28.07.2023..
//

import SwiftUI

struct LazyView<Content: View>: View {
    let content: () -> Content

    init(_ content: @escaping () -> Content) {
        self.content = content
    }

    init(_ content: @autoclosure @escaping () -> Content) {
        self.content = content
    }

    var body: Content {
        content()
    }
}
