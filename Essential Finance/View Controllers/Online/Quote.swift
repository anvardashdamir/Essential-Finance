//
//  QuotesRepository.swift
//  Essential Finance
//
//  Created by Enver Dashdemirov on 30.11.24.
//

import Foundation

// Data model
struct Quote {
    let symbol: String
    var buyPrice: Double
    var sellPrice: Double
    
    var spread: Double {
        return abs(buyPrice - sellPrice)
    }
}
