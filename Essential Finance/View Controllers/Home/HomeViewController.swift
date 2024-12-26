//
//  HomeViewController.swift
//  Essential Finance
//
//  Created by Enver's Macbook Pro on 11/14/24.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    private let greetingText = "Hi there! 👋"

    // MARK: - Subviews
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = greetingText
        label.font = .boldSystemFont(ofSize: 30)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .homeLogo
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        view.backgroundColor = UIColor.Colors.viewBackground
        view.addSubview(titleLabel)
        view.addSubview(logoImageView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            logoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            logoImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            logoImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
