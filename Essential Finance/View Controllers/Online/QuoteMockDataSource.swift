//
//  mock.swift
//  Essential Finance
//
//  Created by Enver Dashdemirov on 02.12.24.
//

class QuoteMockDataSource {
    static func getMockQuotes() -> [Quote] {
        return [
            Quote(symbol: "EURUSD", buyPrice: 1.1234, sellPrice: 1.1230),
            Quote(symbol: "GBPUSD", buyPrice: 1.3245, sellPrice: 1.3240),
            Quote(symbol: "EURUSD", buyPrice: 1.1234, sellPrice: 1.1230),
            Quote(symbol: "GBPUSD", buyPrice: 1.3245, sellPrice: 1.3240),
            Quote(symbol: "USDJPY", buyPrice: 110.45, sellPrice: 110.40),
            Quote(symbol: "AUDUSD", buyPrice: 0.7050, sellPrice: 0.7045),
            Quote(symbol: "NZDUSD", buyPrice: 0.6555, sellPrice: 0.6550),
            Quote(symbol: "USDCAD", buyPrice: 1.2670, sellPrice: 1.2665),
            Quote(symbol: "USDMXN", buyPrice: 19.50, sellPrice: 19.45),
            Quote(symbol: "USDCHF", buyPrice: 0.9200, sellPrice: 0.9195),
            Quote(symbol: "EURJPY", buyPrice: 124.50, sellPrice: 124.45),
            Quote(symbol: "GBPJPY", buyPrice: 165.00, sellPrice: 164.95),
            Quote(symbol: "EURGBP", buyPrice: 0.8500, sellPrice: 0.8495),
            Quote(symbol: "AUDCAD", buyPrice: 0.9000, sellPrice: 0.8995),
            Quote(symbol: "NZDCAD", buyPrice: 0.8000, sellPrice: 0.7995),
            Quote(symbol: "EURCHF", buyPrice: 1.0500, sellPrice: 1.0495),
            Quote(symbol: "GBPCHF", buyPrice: 1.3000, sellPrice: 1.2995),
            Quote(symbol: "USDZAR", buyPrice: 18.00, sellPrice: 17.95),
            Quote(symbol: "USDBRL", buyPrice: 5.20, sellPrice: 5.15),
            Quote(symbol: "USDRUB", buyPrice: 90.00, sellPrice: 89.95),
            Quote(symbol: "USDHKD", buyPrice: 7.80, sellPrice: 7.75)
        ]
    }
}

