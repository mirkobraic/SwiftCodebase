//
//  PortfolioView.swift
//  SwiftfulCrypto
//
//  Created by Mirko Braic on 27.07.2023..
//

import SwiftUI

struct PortfolioView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var vm: HomeViewModel

    @State private var selectedCoin: CoinModel?
    @State private var quantityText = ""
    @State private var showCheckmark = false
    private var shouldSaveBeVisible: Bool {
        selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantityText) && quantityText.isEmpty == false
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    SearchBarView(searchText: $vm.searchText)
                    coinLogoList

                    if selectedCoin != nil {
                        portfolioInputSection
                    }
                }
            }
            .background(Color.theme.background.ignoresSafeArea())
            .navigationTitle("Edit Portfolio")
            .toolbar() {
                ToolbarItem(placement: .navigationBarLeading) {
                    backButton
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    trailingNavBarButtons
                }
            }
            .onChange(of: vm.searchText) { newValue in
                if newValue == "" {
                    removeSelectedCoin()
                }
            }
            .animation(.default, value: vm.allCoins)
        }
    }
}

extension PortfolioView {
    private var backButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark")
                .font(.headline)
        }
        .tint(.theme.accent)
    }

    private var coinLogoList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10) {
                ForEach(vm.allCoins) { coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75)
                        .padding(4)
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                updateSelectedCoin(coin: coin)
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(
                                    selectedCoin?.id == coin.id ? Color.theme.green : Color.clear,
                                    lineWidth: 1
                                )
                        )
                }
            }
            .frame(height: 120)
            .padding(.leading)
        }
    }

    private var portfolioInputSection: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Current price of \(selectedCoin?.symbol.uppercased() ?? ""):")
                Spacer()
                Text(selectedCoin?.currentPrice.asCurrency(nDecimals: 6) ?? "")
            }
            Divider()
            HStack {
                Text("Amount holding:")
                Spacer()
                TextField("Ex: 1.4", text: $quantityText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            Divider()
            HStack {
                Text("Current value:")
                Spacer()
                Text(getCurrentValue().asCurrency(nDecimals: 2))
            }
        }
        // todo: find suitable animation for these numbers
        .animation(.none, value: selectedCoin?.id)
        .padding()
        .font(.headline)
    }

    private var trailingNavBarButtons: some View {
        ZStack {
            Image(systemName: "checkmark")
                .opacity(showCheckmark ? 1 : 0)
                .animation(.default, value: showCheckmark)
            Button {
                saveButtonPressed()
            } label: {
                Text("Save".uppercased())
            }
            .opacity(shouldSaveBeVisible ? 1 : 0)
        }
        .font(.headline)
    }

    private func getCurrentValue() -> Double {
        if let quantity = Double(quantityText) {
            return quantity * (selectedCoin?.currentPrice ?? 0)
        }
        return 0
    }

    private func saveButtonPressed() {
        guard let coin = selectedCoin,
              let amount = Double(quantityText)
        else { return }

        // save to portoflio
        vm.updatePortfolio(coin: coin, amount: amount)

        // show checkmark
        withAnimation {
            showCheckmark = true
            removeSelectedCoin()
        }

        // hide keyboard
        UIApplication.shared.endEditing()

        // hide checkmark
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            showCheckmark = false
        }
    }

    private func removeSelectedCoin() {
        selectedCoin = nil
        vm.searchText = ""
        quantityText = ""
    }

    private func updateSelectedCoin(coin: CoinModel) {
        selectedCoin = coin

        if vm.portfolioCoins.contains(coin) {
            quantityText = "\(coin.currentHoldings)"
        } else {
            quantityText = ""
        }
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView()
            .environmentObject(dev.homeVM)
    }
}
