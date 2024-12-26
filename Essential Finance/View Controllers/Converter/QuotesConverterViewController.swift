//
//  QuotesConverterViewController.swift
//  Essential Finance
//
//  Created by Enver's Macbook Pro on 11/14/24.
//

import UIKit

class QuotesConverterViewController: UIViewController, DialsViewDelegate, UITextFieldDelegate {

    // MARK: - Properties
    let dialsView = DialsView()
    
    let currencyService = CurrencyService()
    var currencies: [Currency] = []
    
    var selectedTopCurrency: String?
    var selectedBottomCurrency: String?
    
    var inputString: String = "" {
        didSet {
            if let fromCurrency = selectedTopCurrency {
                topCurrencyLabel.text = "\(fromCurrency): \(inputString)"
            } else {
                topCurrencyLabel.text = inputString
            }
            
            if !inputString.isEmpty,
               selectedTopCurrency != nil,
               selectedBottomCurrency != nil {
            }
        }
    }

    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Quotes Converter"
        label.font = .boldSystemFont(ofSize: 30)
        return label
    }()

    private let topView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.Colors.currencyBackground
        view.layer.cornerRadius = 10
        return view
    }()

    private let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.Colors.currencyBackground
        view.layer.cornerRadius = 10
        return view
    }()

    private let topCurrencyLabel: UILabel = {
        let label = UILabel()
        label.text = "from"
        label.font = .systemFont(ofSize: 30)
        return label
    }()

    private let bottomCurrencyLabel: UILabel = {
        let label = UILabel()
        label.text = "to"
        label.font = .systemFont(ofSize: 30)
        return label
    }()
    
    private let convertButton: UIButton = {
        let button = UIButton()
        button.setTitle("Convert", for: .normal)
        button.setTitleColor(UIColor.Colors.currencyBackground, for: .normal)
        button.backgroundColor = UIColor.blue
        button.layer.cornerRadius = 7.5
        button.addTarget(self, action: #selector(performConversion), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Colors.viewBackground
        setupUI()
        setupGestures()

        dialsView.delegate = self
        
        // It brings list of currencies
        currencyService.getCurrencies { [weak self] fetchedCurrencies in
            self?.currencies = fetchedCurrencies
        }
    }
    
    func getCurrentDate(format: String = "yyyy-MM-dd") -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = format
            return dateFormatter.string(from: Date())
    }

    // MARK: - Button Actions
    
    @objc func performConversion() {
        guard let fromCurrency = selectedTopCurrency,
              let toCurrency = selectedBottomCurrency,
              let inputAmount = Double(inputString) else {
            bottomCurrencyLabel.text = "Error: Invalid input"
            return
        }
        
        let currentDate = getCurrentDate()
        
        // Debug: Log the inputs being used for conversion
        print("Performing conversion:")
        print("From Currency: \(fromCurrency)")
        print("To Currency: \(toCurrency)")
        print("Input Amount: \(inputAmount)")
        print("Date: \(currentDate)")

        // Fetch the conversion rate for the selected currencies
        currencyService.fetchCurrencyRate(from: fromCurrency, to: toCurrency, date: currentDate) { rates in
            print("Available rates for \(fromCurrency) to \(toCurrency): Rate: ")
            
            DispatchQueue.main.async {
                guard let rates = rates else {
                    print("Error: Conversion rate not found")
                    self.bottomCurrencyLabel.text = "Error: 404"
                    return
                }

                if let conversionRate = rates.first(where: { $0.from == fromCurrency && $0.to == toCurrency })?.result {
                    let convertedAmount = inputAmount * conversionRate
                    print("Conversion successful: \(convertedAmount) \(toCurrency)")
                    self.bottomCurrencyLabel.text = "\(toCurrency): \(String(format: "%.2f", convertedAmount))"
                } else {
                    print("Error: Conversion rate not found for \(fromCurrency) to \(toCurrency)")
                    self.bottomCurrencyLabel.text = "Error: Conversion rate not found"
                }
                print("Available rates: \(rates)")
            }
        }
    }

    
    
    
    
    
    
    
    
    
    
    
    
    private func setupGestures() {
        let topTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapTopView))
        topView.addGestureRecognizer(topTapGesture)
        
        let bottomTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapBottomView))
        bottomView.addGestureRecognizer(bottomTapGesture)
    }

    @objc private func didTapTopView() {
        print("Top View Tapped")
        presentCurrencyListBottomSheet(viewType: "top")
    }

    @objc private func didTapBottomView() {
        print("Bottom View Tapped")
        presentCurrencyListBottomSheet(viewType: "bottom")
    }

    func numberTapped(_ number: Int) {
        inputString.append("\(number)")
    }

    func clearTapped() {
        inputString = ""
    }

    func backspaceTapped() {
        if !inputString.isEmpty {
            inputString.removeLast()
        }
    }

    
    
    
    // MARK: - Currency Selection
    func presentCurrencyListBottomSheet(viewType: String) {
        let alertController = UIAlertController(title: "Select Currency", message: nil, preferredStyle: .actionSheet)
        
        for currency in currencies {
            let action = UIAlertAction(title: currency.code, style: .default) { _ in
                self.updateSelectedCurrency(viewType: viewType, code: currency.code)
                print("Selected currency: \(currency.code)")
            }
            alertController.addAction(action)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }

    func updateSelectedCurrency(viewType: String, code: String) {
        if viewType == "top" {
            selectedTopCurrency = code
            topCurrencyLabel.text = "\(code): \(inputString)"
        } else if viewType == "bottom" {
            selectedBottomCurrency = code
            bottomCurrencyLabel.text = "\(code): "
        }
    }

    
    
    // MARK: - UI Setup
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(topView)
        view.addSubview(bottomView)
        view.addSubview(dialsView)
        view.addSubview(convertButton)
        topView.addSubview(topCurrencyLabel)
        bottomView.addSubview(bottomCurrencyLabel)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        topView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        dialsView.translatesAutoresizingMaskIntoConstraints = false
        topCurrencyLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomCurrencyLabel.translatesAutoresizingMaskIntoConstraints = false
        convertButton.translatesAutoresizingMaskIntoConstraints = false

        setupLayout()
    }

    // MARK: - Layout
    private func setupLayout() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            topView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            topView.heightAnchor.constraint(equalToConstant: 80),
            
            bottomView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 8),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            bottomView.heightAnchor.constraint(equalToConstant: 80),
            
            topCurrencyLabel.centerYAnchor.constraint(equalTo: topView.centerYAnchor),
            topCurrencyLabel.leadingAnchor.constraint(equalTo: topView.leadingAnchor, constant: 16),
            
            bottomCurrencyLabel.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor),
            bottomCurrencyLabel.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 16),
            
            dialsView.topAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: 10),
            dialsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dialsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dialsView.heightAnchor.constraint(equalToConstant: 380),
            
            convertButton.topAnchor.constraint(equalTo: dialsView.bottomAnchor, constant: 5),
            convertButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            convertButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            convertButton.heightAnchor.constraint(equalToConstant: 40),
            convertButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5)
        ])
    }
}
