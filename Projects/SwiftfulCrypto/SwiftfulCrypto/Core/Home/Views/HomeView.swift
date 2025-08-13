//
//  HomeView.swift
//  SwiftfulCrypto
//
//  Created by Mirko Braic on 25.07.2023..
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var vm: HomeViewModel
    @State private var showPortfolio: Bool = false  // animate to the right
    @State private var showPortfolioView: Bool = false  // show new sheet
    @State private var showSettingsView: Bool = false

    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
                .sheet(isPresented: $showPortfolioView) {
                    PortfolioView()
                        .environmentObject(vm)
                }

            VStack {
                homeHeader
                HomeStatsView(showPortfolio: $showPortfolio)
                SearchBarView(searchText: $vm.searchText)
                columnTitles

                if showPortfolio == false {
                    allCoinsList
                        .transition(.move(edge: .leading))
                } else {
                    ZStack(alignment: .top) {
                        if vm.portfolioCoins.isEmpty, vm.searchText.isEmpty {
                            Text("Clikc the + button to add coins to your portfolio.")
                                .font(.callout)
                                .foregroundColor(.theme.accent)
                                .fontWeight(.medium)
                                .multilineTextAlignment(.center)
                                .padding(50)
                        } else {
                            portfolioCoinsList
                        }
                    }
                    .transition(.move(edge: .trailing))
                }

                Spacer(minLength: 0)
            }
            .sheet(isPresented: $showSettingsView) {
                SettingsView()
            }
        }
    }
}

extension HomeView {
    private var homeHeader: some View {
        HStack {
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .animation(.none, value: showPortfolio)
                .onTapGesture {
                    if showPortfolio {
                        showPortfolioView.toggle()
                    } else {
                        showSettingsView.toggle()
                    }
                }
                .background(
                    // todo: how to place this animation view inside of CircleButtonView
                    CircleButtonAnimationView(animate: $showPortfolio)
                )
            Spacer()
            Text(showPortfolio ? "Portfolio" : "Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(.theme.accent)
                .animation(.none, value: showPortfolio)
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .rotation3DEffect(Angle(degrees: showPortfolio ? 180 : 0), axis: (x: 0, y: 1, z: 0))
                .onTapGesture {
                    withAnimation(.spring()) {
                        showPortfolio.toggle()
                    }
                }
        }
        .padding(.horizontal)
    }

    private var allCoinsList: some View {
        List {
            ForEach(vm.allCoins) { coin in
                NavigationLink(destination: LazyView(DetailView(coin: coin))) {
                    CoinRowView(coin: coin, showHoldingsColumn: false)
                        .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                }
                .listRowBackground(Color.theme.background)
                .listRowInsets(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 10))
            }
        }
        .listStyle(.plain)
        .refreshable {
            vm.reloadData()
        }
    }

    private var portfolioCoinsList: some View {
        List {
            ForEach(vm.portfolioCoins) { coin in
                NavigationLink(destination: LazyView(DetailView(coin: coin))) {
                    CoinRowView(coin: coin, showHoldingsColumn: true)
                        .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                }
                .listRowBackground(Color.theme.background)
                .listRowInsets(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 10))
            }
        }
        .listStyle(.plain)
        .refreshable {
            vm.reloadData()
        }
    }

    private var columnTitles: some View {
        HStack {
            HStack(spacing: 4) {
                Text("Coin")
                Image(systemName: "chevron.down")
                    .opacity((vm.sortOption == .rank || vm.sortOption == .rankReversed) ? 1 : 0)
                    .rotation3DEffect(Angle(degrees: vm.sortOption == .rank ? 0 : 180), axis: (x: 1, y: 0, z: 0))
            }
            .onTapGesture {
                withAnimation {
                    vm.sortOption = vm.sortOption == .rank ? .rankReversed : .rank
                }
            }
            Spacer()
            if showPortfolio {
                HStack(spacing: 4) {
                    Text("Holdings")
                    Image(systemName: "chevron.down")
                        .opacity((vm.sortOption == .holdings || vm.sortOption == .holdingsReversed) ? 1 : 0)
                        .rotation3DEffect(Angle(degrees: vm.sortOption == .holdings ? 0 : 180), axis: (x: 1, y: 0, z: 0))
                }
                .onTapGesture {
                    withAnimation {
                        vm.sortOption = vm.sortOption == .holdings ? .holdingsReversed : .holdings
                    }
                }
            }
            HStack(spacing: 4) {
                Text("Price")
                Image(systemName: "chevron.down")
                    .opacity((vm.sortOption == .price || vm.sortOption == .priceReversed) ? 1 : 0)
                    .rotation3DEffect(Angle(degrees: vm.sortOption == .price ? 0 : 180), axis: (x: 1, y: 0, z: 0))
            }
            .onTapGesture {
                withAnimation {
                    vm.sortOption = vm.sortOption == .price ? .priceReversed : .price
                }
            }
            .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
        }
        .font(.caption)
        .foregroundColor(.theme.secondaryText)
        .padding(.horizontal)
    }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            HomeView()
//                .toolbar(.hidden)
//        }
//        .environmentObject(dev.homeVM)
//    }
//}
