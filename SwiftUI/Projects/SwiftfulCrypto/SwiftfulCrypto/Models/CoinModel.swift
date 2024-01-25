//
//  CoinModel.swift
//  SwiftfulCrypto
//
//  Created by Mirko Braic on 25.07.2023..
//

import Foundation

// CoinGecko API info
/*
{
    "id": "bitcoin",
    "symbol": "btc",
    "name": "Bitcoin",
    "image": "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579",
    "current_price": 29190,
    "market_cap": 567594268288,
    "market_cap_rank": 1,
    "fully_diluted_valuation": 613183371595,
    "total_volume": 13142809939,
    "high_24h": 29760,
    "low_24h": 28983,
    "price_change_24h": -569.6233426936087,
    "price_change_percentage_24h": -1.91405,
    "market_cap_change_24h": -10835379174.47229,
    "market_cap_change_percentage_24h": -1.87324,
    "circulating_supply": 19438687,
    "total_supply": 21000000,
    "max_supply": 21000000,
    "ath": 69045,
    "ath_change_percentage": -57.70989,
    "ath_date": "2021-11-10T14:24:11.849Z",
    "atl": 67.81,
    "atl_change_percentage": 42960.81622,
    "atl_date": "2013-07-06T00:00:00.000Z",
    "roi": null,
    "last_updated": "2023-07-25T09:32:34.846Z",
    "sparkline_in_7d": {
      "price": [
        30057.673289421466,
        29976.40770143663,
        30016.972147584787,
      ]
    },
    "price_change_percentage_24h_in_currency": -1.9140522478411586
  },
*/

class CoinModel: Identifiable, Codable, Equatable {
    let id, symbol, name: String
    let image: String
    let currentPrice: Double
    let marketCap, marketCapRank, fullyDilutedValuation: Double?
    let totalVolume, high24H, low24H: Double?
    let priceChange24H: Double?
    let priceChangePercentage24H: Double?
    let marketCapChange24H: Double?
    let marketCapChangePercentage24H: Double?
    let circulatingSupply, totalSupply, maxSupply, ath: Double?
    let athChangePercentage: Double?
    let athDate: String?
    let atl, atlChangePercentage: Double?
    let atlDate: String?
    let lastUpdated: String?
    let sparklineIn7D: SparklineIn7D?
    let priceChangePercentage24HInCurrency: Double?

    var currentHoldings: Double = 0

    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case currentPrice = "current_price"
        case marketCap = "market_cap"
        case marketCapRank = "market_cap_rank"
        case fullyDilutedValuation = "fully_diluted_valuation"
        case totalVolume = "total_volume"
        case high24H = "high_24h"
        case low24H = "low_24h"
        case priceChange24H = "price_change_24h"
        case priceChangePercentage24H = "price_change_percentage_24h"
        case marketCapChange24H = "market_cap_change_24h"
        case marketCapChangePercentage24H = "market_cap_change_percentage_24h"
        case circulatingSupply = "circulating_supply"
        case totalSupply = "total_supply"
        case maxSupply = "max_supply"
        case ath
        case athChangePercentage = "ath_change_percentage"
        case athDate = "ath_date"
        case atl
        case atlChangePercentage = "atl_change_percentage"
        case atlDate = "atl_date"
        case lastUpdated = "last_updated"
        case sparklineIn7D = "sparkline_in_7d"
        case priceChangePercentage24HInCurrency = "price_change_percentage_24h_in_currency"
    }

    init(id: String, symbol: String, name: String, image: String, currentPrice: Double, marketCap: Double?, marketCapRank: Double?, fullyDilutedValuation: Double?, totalVolume: Double?, high24H: Double?, low24H: Double?, priceChange24H: Double?, priceChangePercentage24H: Double?, marketCapChange24H: Double?, marketCapChangePercentage24H: Double?, circulatingSupply: Double?, totalSupply: Double?, maxSupply: Double?, ath: Double?, athChangePercentage: Double?, athDate: String?, atl: Double?, atlChangePercentage: Double?, atlDate: String?, lastUpdated: String?, sparklineIn7D: SparklineIn7D?, priceChangePercentage24HInCurrency: Double?, currentHoldings: Double) {
        self.id = id
        self.symbol = symbol
        self.name = name
        self.image = image
        self.currentPrice = currentPrice
        self.marketCap = marketCap
        self.marketCapRank = marketCapRank
        self.fullyDilutedValuation = fullyDilutedValuation
        self.totalVolume = totalVolume
        self.high24H = high24H
        self.low24H = low24H
        self.priceChange24H = priceChange24H
        self.priceChangePercentage24H = priceChangePercentage24H
        self.marketCapChange24H = marketCapChange24H
        self.marketCapChangePercentage24H = marketCapChangePercentage24H
        self.circulatingSupply = circulatingSupply
        self.totalSupply = totalSupply
        self.maxSupply = maxSupply
        self.ath = ath
        self.athChangePercentage = athChangePercentage
        self.athDate = athDate
        self.atl = atl
        self.atlChangePercentage = atlChangePercentage
        self.atlDate = atlDate
        self.lastUpdated = lastUpdated
        self.sparklineIn7D = sparklineIn7D
        self.priceChangePercentage24HInCurrency = priceChangePercentage24HInCurrency
        self.currentHoldings = currentHoldings
    }

    func updateHoldings(amount: Double) {
        currentHoldings = amount
    }

    var currentHoldingsValue: Double {
        return currentHoldings * currentPrice
    }

    var rank: Int {
        return Int(marketCapRank ?? 0)
    }

    static func == (lhs: CoinModel, rhs: CoinModel) -> Bool {
        return lhs.id == rhs.id
    }
}

struct SparklineIn7D: Codable {
    let price: [Double]?
}
