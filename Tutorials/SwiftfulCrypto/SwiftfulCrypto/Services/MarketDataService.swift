//
//  MarketDataService.swift
//  SwiftfulCrypto
//
//  Created by Mirko Braic on 27.07.2023..
//

import Foundation
import Combine

class MarketDataService {
    @Published var marketData: MarketDataModel?
    var marketDataSubscription: AnyCancellable?

    init() {
        getData()
    }

    func getData() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else { return }

        marketDataSubscription = NetworkingManager.download(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: NetworkingManager.handleCompletion) { [weak self] globalData in
                self?.marketData = globalData.data
                self?.marketDataSubscription?.cancel()
            }
    }
}
