//
//  API.swift
//  Essential Finance
//
//  Created by Enver Dashdemirov on 08.12.24.
//

import UIKit
import Foundation

class CurrencyService {

    // MARK: - Fetch Currencies
    func getCurrencies(completion: @escaping ([Currency]) -> Void) {
        guard let url = URL(string: "https://valyuta.com/api/get_currency_list_for_app") else {
            print("Invalid URL for currencies.")
            return
        }
        
        fetchData(from: url) { result in
            switch result {
            case .success(let data):
                let currencies = (try? JSONDecoder().decode([Currency].self, from: data)) ?? []
                DispatchQueue.main.async {
                    completion(currencies)
                }
            case .failure(let error):
                print("Error fetching currencies: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Fetch Currency Rate
    func fetchCurrencyRate(from: String, to: String, date: String, completion: @escaping ([CurrencyRate]?) -> Void) {
        guard let url = URL(string: "https://valyuta.com/api/get_currency_rate_for_app/\(to)/\(date)") else {
            print("Invalid URL for currency rate.")
            completion(nil)
            return
        }
        
        fetchData(from: url) { result in
            switch result {
            case .success(let data):
                do {
                    print("Raw JSON response: \(String(data: data, encoding: .utf8) ?? "Invalid JSON")")
                    
                    let decodedRates = try JSONDecoder().decode([CurrencyRate].self, from: data)
                    // Filter rates to match the desired 'from' currency
                    let matchingRates = decodedRates.filter { $0.from == from && $0.to == to }
                    
                    if !matchingRates.isEmpty {
                        DispatchQueue.main.async {
                            completion(matchingRates)
                        }
                    } else {
                        print("No matching rates found for \(from) to \(to).")
                        completion(nil)
                    }
                } catch {
                    print("Error decoding rates: \(error.localizedDescription)")
                    completion(nil)
                }
            case .failure(let error):
                print("Error fetching rates: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
    
    // MARK: - Private Method for Data Fetching
    private func fetchData(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "CurrencyService", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received."])))
                return
            }
            completion(.success(data))
        }.resume()
    }
}
