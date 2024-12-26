//
//  Data.swift
//  Essential Finance
//
//  Created by Enver Dashdemirov on 29.11.24.
//

import SocketIO
import Foundation

class QuoteSocketService {
    private let manager: SocketManager
    private let socket: SocketIOClient
    
    var onQuoteUpdate: ((Quote) -> Void)?
    var onConnectionStatusChange: ((Bool) -> Void)?
    
    init(socketURL: String) {
        manager = SocketManager(socketURL: URL(string: socketURL)!, config: [.log(true), .compress])
        socket = manager.defaultSocket
        setupSocketEvents()
    }
    
    private func setupSocketEvents() {
        socket.on(clientEvent: .connect) { [weak self] _, _ in
            print("Connected to WebSocket")
            self?.onConnectionStatusChange?(true)
        }
        
        socket.on(clientEvent: .disconnect) { [weak self] _, _ in
            print("Disconnected from WebSocket")
            self?.onConnectionStatusChange?(false)
        }
        
        socket.on("updateQuote") { [weak self] data, _ in
            guard let quoteData = data.first as? [String: Any],
                  let symbol = quoteData["symbol"] as? String,
                  let buyPrice = quoteData["buyPrice"] as? Double,
                  let sellPrice = quoteData["sellPrice"] as? Double else {
                return
            }
            let quote = Quote(symbol: symbol, buyPrice: buyPrice, sellPrice: sellPrice)
            self?.onQuoteUpdate?(quote)
        }
    }
    
    func connect() {
        socket.connect()
    }
    
    func disconnect() {
        socket.disconnect()
    }
}
