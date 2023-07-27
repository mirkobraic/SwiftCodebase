//
//  DetailViewModel.swift
//  SwiftfulCrypto
//
//  Created by Mirko Braic on 28.07.2023..
//

import Foundation
import Combine

class DetailViewModel: ObservableObject {
    @Published var overviewStatistics = [StatisticModel]()
    @Published var additionalStatistics = [StatisticModel]()
    @Published var coin: CoinModel
    @Published var coinDescription: String?
    @Published var websiteURL: String?
    @Published var redditURL: String?

    private let coinDetailService: CoinDetailDataService
    private var subscriptions = Set<AnyCancellable>()

    init(coin: CoinModel) {
        self.coin = coin
        coinDetailService = CoinDetailDataService(coin: coin)
        addSubscribers()
    }

    private func addSubscribers() {
        coinDetailService.$coinDetails
            .combineLatest($coin)
            .map(mapDataToStatistics)
            .sink { [weak self] returnedArrays in
                self?.overviewStatistics = returnedArrays.overview
                self?.additionalStatistics = returnedArrays.additional
            }
            .store(in: &subscriptions)

        coinDetailService.$coinDetails
            .sink { [weak self] details in
                self?.coinDescription = details?.readableDescription
                self?.websiteURL = details?.links?.homepage?.first
                self?.redditURL = details?.links?.subredditURL
            }
            .store(in: &subscriptions)
    }

    private func mapDataToStatistics(coinDetails: CoinDetailModel?, coin: CoinModel)-> (overview: [StatisticModel], additional: [StatisticModel]) {
        let overview = createOverviewArray(coin: coin)
        let additional = createAdditionalArray(coin: coin, details: coinDetails)
        return (overview, additional)
    }

    private func createOverviewArray(coin: CoinModel) -> [StatisticModel] {
        let price = coin.currentPrice.asCurrency(nDecimals: 6)
        let pricePercentChange = coin.priceChangePercentage24H
        let priceStat = StatisticModel(title: "Current price", value: price, percentageChange: pricePercentChange)

        let marketCap = "$" + (coin.marketCap?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange = coin.marketCapChangePercentage24H
        let marketCapStat = StatisticModel(title: "Market Capitalization", value: marketCap, percentageChange: marketCapPercentChange)

        let rank = "\(coin.rank)"
        let rankStat = StatisticModel(title: "Rank", value: rank)

        let volume = "$" + (coin.totalVolume?.formattedWithAbbreviations() ?? "")
        let volumeStat = StatisticModel(title: "Volume", value: volume)

        return [priceStat, marketCapStat, rankStat, volumeStat]
    }

    private func createAdditionalArray(coin: CoinModel, details: CoinDetailModel?) -> [StatisticModel] {
        let high = coin.high24H?.asCurrency(nDecimals: 6) ?? "n/a"
        let highStat = StatisticModel(title: "24h High", value: high)

        let low = coin.low24H?.asCurrency(nDecimals: 6) ?? "n/a"
        let lowStat = StatisticModel(title: "24h Low", value: low)

        let priceChange = coin.priceChange24H?.asCurrency(nDecimals: 6) ?? "n/a"
        let pricePercentChange = coin.priceChangePercentage24H
        let priceChangeStat = StatisticModel(title: "24h Price Change", value: priceChange, percentageChange: pricePercentChange)

        let marketCapChange = "$" + (coin.marketCapChange24H?.formattedWithAbbreviations() ?? "")
        let marketCapPercentChange = coin.marketCapChangePercentage24H
        let marketCapChangeStat = StatisticModel(title: "24h Market Cap Change", value: marketCapChange, percentageChange: marketCapPercentChange)

        let blockTime = details?.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "n/a" : "\(blockTime)"
        let blockStat = StatisticModel(title: "Block Time", value: blockTimeString)

        let hashing = details?.hashingAlgorithm ?? "n/a"
        let hashingStat = StatisticModel(title: "Hashing Algorithm", value: hashing)

        return [highStat, lowStat, priceChangeStat, marketCapChangeStat, blockStat, hashingStat]
    }
}
