//
//  OnlineQuotesViewController.swift
//  Essential Finance
//
//  Created by Enver's Macbook Pro on 11/14/24.
//

//import UIKit
//import SocketIO

import UIKit

class OnlineQuotesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView = UITableView()
    private let connectionStatusLabel = UILabel()
    private let filterButton = UIButton(type: .system)
    
    private var quotes: [Quote] = []
    private var filteredSymbols: Set<String> = []
    private var socketService: QuoteSocketService?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Colors.viewBackground
        setupUI()
        loadMockData()
//        setupSocketService()
    }
    
    private func setupUI() {
        // Connection status label
        connectionStatusLabel.text = "Disconnected"
        connectionStatusLabel.textColor = .red
        connectionStatusLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(connectionStatusLabel)
        
        NSLayoutConstraint.activate([
            connectionStatusLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            connectionStatusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
        
        // Filter button
        filterButton.setTitle("Filter Quotes", for: .normal)
        filterButton.setTitleColor(.white, for: .normal)
        filterButton.backgroundColor = .systemBlue
        filterButton.layer.cornerRadius = 8
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        filterButton.addTarget(self, action: #selector(showFilterOptions), for: .touchUpInside)
        view.addSubview(filterButton)
        
        NSLayoutConstraint.activate([
            filterButton.topAnchor.constraint(equalTo: connectionStatusLabel.bottomAnchor, constant: 8),
            filterButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            filterButton.widthAnchor.constraint(equalToConstant: 120),
            filterButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        // TableView
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: filterButton.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupSocketService() {
        socketService = QuoteSocketService(socketURL: "https://q.investaz.az/live")
        socketService?.onConnectionStatusChange = { [weak self] connected in
            self?.updateConnectionStatus(connected: connected)
        }
        socketService?.onQuoteUpdate = { [weak self] quote in
            self?.updateQuotes(with: quote)
        }
        socketService?.connect()
    }
    
    private func loadMockData() {
        quotes = QuoteMockDataSource.getMockQuotes()
        tableView.reloadData()
    }
    
    private func updateConnectionStatus(connected: Bool) {
        connectionStatusLabel.text = connected ? "Connected" : "Disconnected"
        connectionStatusLabel.textColor = connected ? .green : .red
    }
    
    private func updateQuotes(with quote: Quote) {
        if filteredSymbols.isEmpty || filteredSymbols.contains(quote.symbol) {
            if let index = quotes.firstIndex(where: { $0.symbol == quote.symbol }) {
                quotes[index] = quote
            } else {
                quotes.append(quote)
            }
            tableView.reloadData()
        }
    }
    
    @objc private func showFilterOptions() {
        let alertController = UIAlertController(title: "Filter Quotes", message: "Enter symbols to show (comma-separated)", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "e.g., EURUSD,GBPUSD"
        }
        let confirmAction = UIAlertAction(title: "Filter", style: .default) { _ in
            if let input = alertController.textFields?.first?.text {
                self.filteredSymbols = Set(input.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) })
                self.tableView.reloadData()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        quotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let quote = quotes[indexPath.row]
        cell.textLabel?.text = """
        \(quote.symbol) | Buy: \(quote.buyPrice) | Sell: \(quote.sellPrice) | Spread: \(quote.spread)
        """
        return cell
    }
}


//class OnlineQuotesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//    
//    // socket element
//      var manager: SocketManager!
//      var socket: SocketIOClient!
//    
//    // Data model for table
//      var quotes: [(symbol: String, buyPrice: Double, sellPrice: Double)] = []
//      var filteredSymbols: Set<String> = []
//    
//      func loadMockData() {
//        quotes = [
//            (symbol: "EURUSD", buyPrice: 1.1234, sellPrice: 1.1230),
//            (symbol: "GBPUSD", buyPrice: 1.3245, sellPrice: 1.3240),
//            (symbol: "USDJPY", buyPrice: 110.45, sellPrice: 110.40),
//            (symbol: "AUDUSD", buyPrice: 0.7050, sellPrice: 0.7045),
//            (symbol: "NZDUSD", buyPrice: 0.6555, sellPrice: 0.6550),
//            (symbol: "USDCAD", buyPrice: 1.2670, sellPrice: 1.2665),
//            (symbol: "USDMXN", buyPrice: 19.50, sellPrice: 19.45),
//            (symbol: "USDCHF", buyPrice: 0.9200, sellPrice: 0.9195),
//            (symbol: "EURJPY", buyPrice: 124.50, sellPrice: 124.45),
//            (symbol: "GBPJPY", buyPrice: 165.00, sellPrice: 164.95),
//            (symbol: "EURGBP", buyPrice: 0.8500, sellPrice: 0.8495),
//            (symbol: "AUDCAD", buyPrice: 0.9000, sellPrice: 0.8995),
//            (symbol: "NZDCAD", buyPrice: 0.8000, sellPrice: 0.7995),
//            (symbol: "EURCHF", buyPrice: 1.0500, sellPrice: 1.0495),
//            (symbol: "GBPCHF", buyPrice: 1.3000, sellPrice: 1.2995),
//            (symbol: "USDZAR", buyPrice: 18.00, sellPrice: 17.95),
//            (symbol: "USDBRL", buyPrice: 5.20, sellPrice: 5.15),
//            (symbol: "USDRUB", buyPrice: 90.00, sellPrice: 89.95),
//            (symbol: "USDHKD", buyPrice: 7.80, sellPrice: 7.75)
//        ]
//    }
//    
//    // UI Elements
//      let tableView = UITableView()
//    
//      let connectionStatusLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Disconnected"
//        label.textColor = .red
//        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//      let filterButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("Filter Quotes", for: .normal)
//        button.setTitleColor(.white, for: .normal)
//        button.backgroundColor = .systemBlue
//        button.layer.cornerRadius = 8
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.view.backgroundColor = .white
//        
//        setupUI()
//        loadMockData()
//        tableView.reloadData()
//        simulateLiveUpdates()
////        setupSocket()
//    }
//    
//    // mock data
//      func simulateLiveUpdates() {
//        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
//            guard let self = self else { return }
//            
//            // Randomly update prices in the `quotes` array
//            for i in 0..<self.quotes.count {
//                let randomChange = Double.random(in: -0.001...0.001)
//                self.quotes[i].buyPrice += randomChange
//                self.quotes[i].sellPrice += randomChange
//            }
//            
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        }
//    }
//    
//      func formatNumber(_ value: Double, decimals: Int = 4) -> String {
//        return String(format: "%.\(decimals)f", value)
//    }
//
//
//    
//      func setupUI() {
//        // Add connection status label
//        view.addSubview(connectionStatusLabel)
//        NSLayoutConstraint.activate([
//            connectionStatusLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
//            connectionStatusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
//        ])
//        
//        // Add filter button
//        view.addSubview(filterButton)
//        NSLayoutConstraint.activate([
//            filterButton.topAnchor.constraint(equalTo: connectionStatusLabel.bottomAnchor, constant: 8),
//            filterButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            filterButton.widthAnchor.constraint(equalToConstant: 120),
//            filterButton.heightAnchor.constraint(equalToConstant: 44)
//        ])
//        
//        // Add table view
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//        view.addSubview(tableView)
//        
//        NSLayoutConstraint.activate([
//            tableView.topAnchor.constraint(equalTo: filterButton.bottomAnchor, constant: 16),
//            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
//        ])
//        
//        // Filter button action
//        filterButton.addTarget(self, action: #selector(showFilterOptions), for: .touchUpInside)
//    }
//    
//      func setupSocket() {
//        manager = SocketManager(
//            socketURL: URL(string: "https://q.investaz.az/live")!,
//            config: [.log(true), .compress, .forcePolling(true)]
//        )
//
//        socket = manager.defaultSocket
//        
//        // Socket event listeners
//        socket.on(clientEvent: .connect) { _, _ in
//            print("Socket connected!")
//            self.updateConnectionStatus(connected: true)
//        }
//        
//        socket.on(clientEvent: .error) { data, ack in
//            print("Error: \(data)")
//        }
//
//        socket.on(clientEvent: .disconnect) { data, ack in
//            print("Socket disconnected: \(data)")
//        }
//        
//        socket.on("updateQuote") { data, _ in
//            guard let quoteData = data[0] as? [String: Any],
//                  let symbol = quoteData["symbol"] as? String,
//                  let buyPrice = quoteData["buyPrice"] as? Double,
//                  let sellPrice = quoteData["sellPrice"] as? Double else {
//                return
//            }
//            
//            DispatchQueue.main.async {
//                if self.filteredSymbols.isEmpty || self.filteredSymbols.contains(symbol) {
//                    if let index = self.quotes.firstIndex(where: { $0.symbol == symbol }) {
//                        self.quotes[index] = (symbol, buyPrice, sellPrice)
//                    } else {
//                        self.quotes.append((symbol, buyPrice, sellPrice))
//                    }
//                    self.tableView.reloadData()
//                }
//            }
//        }
//        
//        socket.on(clientEvent: .disconnect) { _, _ in
//            print("Socket disconnected!")
//            self.updateConnectionStatus(connected: false)
//        }
//        
//        // Establish connection
//        socket.connect()
//    }
//    
//      func updateConnectionStatus(connected: Bool) {
//        DispatchQueue.main.async {
//            self.connectionStatusLabel.text = connected ? "Connected" : "Disconnected"
//            self.connectionStatusLabel.textColor = connected ? .green : .red
//        }
//    }
//    
//    @objc   func showFilterOptions() {
//        let alertController = UIAlertController(title: "Filter Quotes", message: "Enter symbols to show (comma-separated)", preferredStyle: .alert)
//        alertController.addTextField { textField in
//            textField.placeholder = "e.g., EURUSD,GBPUSD"
//        }
//        
//        let confirmAction = UIAlertAction(title: "Filter", style: .default) { _ in
//            if let input = alertController.textFields?.first?.text {
//                self.filteredSymbols = Set(input.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) })
//                self.tableView.reloadData()
//            }
//        }
//        
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        alertController.addAction(confirmAction)
//        alertController.addAction(cancelAction)
//        present(alertController, animated: true, completion: nil)
//    }
//    
//    // MARK: - UITableView DataSource and Delegate
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        quotes.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        let quote = quotes[indexPath.row]
//        let spread = abs(quote.buyPrice - quote.sellPrice)
//        
//        cell.textLabel?.text = """
//        \(quote.symbol) | Buy: \(formatNumber(quote.buyPrice)) | Sell: \(formatNumber(quote.sellPrice)) | Spread: \(formatNumber(spread))
//        """
//        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
//        return cell
//    }
//
//    deinit {
//        socket.disconnect()
//    }
//}
