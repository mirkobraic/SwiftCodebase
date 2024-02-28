//
//  TCANavigationApp.swift
//  TCANavigation
//
//  Created by Mirko Braić on 28.02.2024..
//

import ComposableArchitecture
import SwiftUI

@main
struct TCANavigationApp: App {
    static let store = StoreOf<ContactsFeature>(initialState: ContactsFeature.State()) {
        ContactsFeature()
    }
    
    var body: some Scene {
        WindowGroup {
            ContactsView(store: TCANavigationApp.store)
        }
    }
}
