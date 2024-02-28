//
//  TheComposableArchitectureApp.swift
//  TheComposableArchitecture
//
//  Created by Mirko Braić on 27.02.2024..
//

import ComposableArchitecture
import SwiftUI

@main
struct TCAEssentialsApp: App {
    static let store = Store(initialState: AppFeature.State()) {
      AppFeature()
    }
    
    var body: some Scene {
        WindowGroup {
            AppView(store: TCAEssentialsApp.store)
        }
    }
}
