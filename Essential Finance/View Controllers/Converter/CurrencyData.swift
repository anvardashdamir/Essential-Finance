//
//  CurrencyData.swift
//  Essential Finance
//
//  Created by Enver Dashdemirov on 08.12.24.
//

import UIKit
import Foundation

struct Currency: Codable {
    let code: String
    let az: String
    let en: String
    let tr: String
    let ru: String
}

struct CurrencyRate: Codable {
    let from: String
    let to: String
    let result: Double
    let date: String
    let menbe: String
    
}
