//
//  SwiftfulCryptoApp.swift
//  SwiftfulCrypto
//
//  Created by Mirko Braic on 25.07.2023..
//

import SwiftUI

@main
struct SwiftfulCryptoApp: App {
    @StateObject private var homeVM = HomeViewModel()
    @State private var showLaunchView = true

    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
        UINavigationBar.appearance().tintColor = UIColor(Color.theme.accent)
        UITableView.appearance().backgroundColor = UIColor(Color.theme.background)
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                NavigationStack {
                    HomeView()
                        .toolbar(.hidden)
                }
                .environmentObject(homeVM)

                ZStack {
                    if showLaunchView {
                        LaunchView(showLaunchView: $showLaunchView)
                            .transition(.move(edge: .leading))
                    }
                }
                .zIndex(2.0)
            }
        }
    }
}
