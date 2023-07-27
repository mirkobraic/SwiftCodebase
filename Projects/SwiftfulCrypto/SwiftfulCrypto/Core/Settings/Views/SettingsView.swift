//
//  SettingsView.swift
//  SwiftfulCrypto
//
//  Created by Mirko Braic on 02.08.2023..
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss

    let defaultURL = URL(string: "https://www.google.com")!
    let youtubeURL = URL(string: "https://www.youtube.com")!
    let coffeeURL = URL(string: "https://www.buymeacoffee.com/nicksarno")!
    let coingeckoURL = URL(string: "https://www.coingecko.com")!
    let personalURL = URL(string: "https://nicksarno.com")!

    var body: some View {
        NavigationView {
            List {
                firstSection
                    .listRowBackground(Color.theme.background.opacity(0.5))
                coingeckoSection
                    .listRowBackground(Color.theme.background.opacity(0.5))
                developerSection
                    .listRowBackground(Color.theme.background.opacity(0.5))
                applicationSection
                    .listRowBackground(Color.theme.background.opacity(0.5))
            }
            .font(.headline)
            .tint(.blue)
            .listStyle(.grouped)
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    backButton
                }
            }
            .background(Color.theme.background)
            .scrollContentBackground(.hidden)
        }
    }
}

extension SettingsView {
    private var backButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark")
                .font(.headline)
        }
        .tint(.theme.accent)
    }

    private var firstSection: some View {
        Section {
            VStack(alignment: .leading) {
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("This app was made by following a SwiftwulThinking course on YouTube. It uses MVVM architecture, Combine and CoreData.")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.theme.accent)
            }
            .padding(.vertical)
            Link("Subscribe on YouTube", destination: youtubeURL)
            Link("Support coffee addiction", destination: coffeeURL)
        } header: {
            Text("Swiftful Thinking")
        }
    }

    private var coingeckoSection: some View {
        Section {
            VStack(alignment: .leading) {
                Image("coingecko")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("The crypto currency data taht is used in this app comes from a free API from CoinGecko.")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.theme.accent)
            }
            .padding(.vertical)
            Link("Visit CoinGecko", destination: coingeckoURL)
        } header: {
            Text("CoinGecko")
        }
    }

    private var developerSection: some View {
        Section {
            VStack(alignment: .leading) {
                Image(systemName: "person.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("This app was made when I did not have any tasks to do on my job. It teaches SwiftUI and has a nice MVVM architecture.")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.theme.accent)
            }
            .padding(.vertical)
            Link("Visit Website", destination: personalURL)
        } header: {
            Text("Developer")
        }
    }

    private var applicationSection: some View {
        Section {
            Link("Terms of Service", destination: personalURL)
            Link("Privacy Policy", destination: personalURL)
            Link("Company Website", destination: personalURL)
            Link("Learn more", destination: personalURL)
        } header: {
            Text("Applicaiton")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
