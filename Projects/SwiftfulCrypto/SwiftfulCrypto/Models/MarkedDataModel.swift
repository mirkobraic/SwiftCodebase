//
//  MarkedDataModel.swift
//  SwiftfulCrypto
//
//  Created by Mirko Braic on 27.07.2023..
//

import Foundation

// JSON data:
/*
URL: https://api.coingecko.com/api/v3/global

 {
   "data": {
     "active_cryptocurrencies": 10036,
     "upcoming_icos": 0,
     "ongoing_icos": 49,
     "ended_icos": 3376,
     "markets": 782,
     "total_market_cap": {
       "btc": 41902915.15570653,
       "eth": 658571519.0597749,
       "ltc": 13511088588.093817,
       "bch": 4987014975.484901,
       "bnb": 5092647626.363011,
       "eos": 1656356742384.8892,
       "xrp": 1728810328793.2031,
       "xlm": 7707105881604.717,
       "link": 154433931841.59192,
       "dot": 232938035950.49005,
       "yfi": 178914144.05551207,
       "usd": 1233242469566.386,
       "aed": 4529576266470.402,
       "ars": 336038347780339.5,
       "aud": 1809599570960.707,
       "bdt": 133910296723028.95,
       "bhd": 464839917841.312,
       "bmd": 1233242469566.386,
       "brl": 5842732848064.686,
       "cad": 1623255400566.7568,
       "chf": 1055264616085.9727,
       "clp": 1017104394350181.2,
       "cny": 8807447744902.246,
       "czk": 26594875089441.586,
       "dkk": 8252060698460.444,
       "eur": 1107350611788.1094,
       "gbp": 949086139183.7194,
       "hkd": 9618791799417.66,
       "huf": 419262636751864.25,
       "idr": 18508661813783224,
       "ils": 4543635230623.441,
       "inr": 101054968595958.75,
       "jpy": 172544495470120.16,
       "krw": 1576011968203925.8,
       "kwd": 378366189117.7849,
       "lkr": 407798878453945.7,
       "mmk": 2591027424931093,
       "mxn": 20655886433384.8,
       "myr": 5572406098735.733,
       "ngn": 972411687253095,
       "nok": 12359473402748.854,
       "nzd": 1971296157357.9028,
       "php": 67333192674347.75,
       "pkr": 354043918452350.8,
       "pln": 4895626063044.603,
       "rub": 110849991977519.86,
       "sar": 4626077489713.957,
       "sek": 12727358264117.82,
       "sgd": 1630865739846.4514,
       "thb": 42046168757396.234,
       "try": 33245750494570.676,
       "twd": 38550912950151.36,
       "uah": 45567683996545.72,
       "vef": 123484568477.6825,
       "vnd": 29196087738138100,
       "zar": 21521246508067.176,
       "xdr": 916708591387.7224,
       "xag": 49265656501.210815,
       "xau": 623465730.4892868,
       "bits": 41902915155706.53,
       "sats": 4190291515570653
     },
     "total_volume": {
       "btc": 1340262.8215726118,
       "eth": 21064379.866234925,
       "ltc": 432151549.51170623,
       "bch": 159509445.52262297,
       "bnb": 162888101.02165,
       "eos": 52978494523.1255,
       "xrp": 55295919165.10623,
       "xlm": 246511428540.35263,
       "link": 4939562234.929057,
       "dot": 7450512408.37285,
       "yfi": 5722560.701088439,
       "usd": 39445203891.00244,
       "aed": 144878289371.26358,
       "ars": 10748171158954.36,
       "aud": 57879959374.66635,
       "bdt": 4283114705903.48,
       "bhd": 14867883476.616156,
       "bmd": 39445203891.00244,
       "brl": 186879542474.40283,
       "cad": 51919749621.532,
       "chf": 33752590401.0646,
       "clp": 32532037457065.35,
       "cny": 281705812628.3717,
       "czk": 850635861354.6715,
       "dkk": 263941783391.6708,
       "eur": 35418558587.4011,
       "gbp": 30356476681.661087,
       "hkd": 307656615042.2439,
       "huf": 13410096228985.191,
       "idr": 591998700183419.1,
       "ils": 145327964695.62045,
       "inr": 3232238540948.0625,
       "jpy": 5518827782895.019,
       "krw": 50408670601752.64,
       "kwd": 12102025224.982903,
       "lkr": 13043428445011.158,
       "mmk": 82873893484645.61,
       "mxn": 660677581271.3729,
       "myr": 178233153781.49512,
       "ngn": 31102543268055.41,
       "nok": 395317190566.9655,
       "nzd": 63051817282.835106,
       "php": 2153649082978.5088,
       "pkr": 11324078512016.129,
       "pln": 156586375344.98624,
       "rub": 3545531915071.5327,
       "sar": 147964876575.73407,
       "sek": 407083971004.07965,
       "sgd": 52163165974.743385,
       "thb": 1344844781459.833,
       "try": 1063363806493.6451,
       "twd": 1233049184591.9595,
       "uah": 1457480285054.1619,
       "vef": 3949648265.6060824,
       "vnd": 933835528754842.2,
       "zar": 688356083615.6696,
       "xdr": 29320882298.706676,
       "xag": 1575759766.2020364,
       "xau": 19941522.827096295,
       "bits": 1340262821572.6118,
       "sats": 134026282157261.19
     },
     "market_cap_percentage": {
       "btc": 46.39384856104103,
       "eth": 18.31666774610092,
       "usdt": 6.79433989386027,
       "xrp": 3.0460238971274602,
       "bnb": 3.020077509386092,
       "usdc": 2.154959222205476,
       "steth": 1.1931947409816137,
       "doge": 0.8989627674850181,
       "ada": 0.8862697817720657,
       "sol": 0.8235639548452094
     },
     "market_cap_change_percentage_24h_usd": 1.1645177864673915,
     "updated_at": 1690447585
   }
 }
 */

struct GlobalData: Codable {
    let data: MarketDataModel?
}

struct MarketDataModel: Codable {
    let totalMarketCap, totalVolume, marketCapPercentage: [String: Double]
    let marketCapChangePercentage24HUsd: Double

    enum CodingKeys: String, CodingKey {
        case totalMarketCap = "total_market_cap"
        case totalVolume = "total_volume"
        case marketCapPercentage = "market_cap_percentage"
        case marketCapChangePercentage24HUsd = "market_cap_change_percentage_24h_usd"
    }

    var marketCap: String {
        if let item = totalMarketCap.first(where: { $0.key == "usd" }) {
            return "$" + item.value.formattedWithAbbreviations()
        }
        return ""
    }

    var volume: String {
        if let item = totalVolume.first(where: { $0.key == "usd" }) {
            return "$" + item.value.formattedWithAbbreviations()
        }
        return ""
    }

    var btcDominance: String {
        if let item = marketCapPercentage.first(where: { $0.key == "btc" }) {
            return item.value.asPercentString()
        }
        return ""
    }

}
