//
//  ProfileViewController.swift
//  Essential Finance
//
//  Created by Enver's Macbook Pro on 11/14/24.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Properties
    var items: [String] = ["Account", "Security", "Settings", "FAQ"]
    
    var profileImages: [UIImage?] = [
        UIImage(named: "account"),
        UIImage(named: "security"),
        UIImage(named: "settings"),
        UIImage(named: "faq")
    ]

    // MARK: - Subviews
    let fullNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello \nWarren Buffet"
        label.numberOfLines = 0
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 30, weight: UIFont.Weight(rawValue: 12))
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let profilePhoto: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "defaultProfilePhoto")
        imageView.layer.cornerRadius = 40
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor.Colors.viewBackground
        tableView.separatorStyle = .none
        return tableView
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup
        self.view.backgroundColor = UIColor.Colors.viewBackground
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ProfileCell.self, forCellReuseIdentifier: "ProfileCell")
        
        // UI and Layout
        setupUI()
        setupLayout()
    }

    // MARK: - Setup UI
    func setupUI() {
        view.addSubview(fullNameLabel)
        view.addSubview(profilePhoto)
        view.addSubview(tableView)
    }

    // MARK: - Layout Constraints
    func setupLayout() {
        NSLayoutConstraint.activate([
            // Profile Photo
            profilePhoto.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            profilePhoto.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            profilePhoto.widthAnchor.constraint(equalToConstant: 80),
            profilePhoto.heightAnchor.constraint(equalToConstant: 80),
            
            // Full Name Label
            fullNameLabel.centerYAnchor.constraint(equalTo: profilePhoto.centerYAnchor),
            fullNameLabel.leadingAnchor.constraint(equalTo: profilePhoto.trailingAnchor, constant: 8),
            fullNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            // Table View
            tableView.topAnchor.constraint(equalTo: profilePhoto.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as? ProfileCell else {
            return UITableViewCell()
        }
        
        cell.profileImageView.image = profileImages[indexPath.row] ?? UIImage(systemName: "questionmark.circle")
        cell.cellLabel.text = items[indexPath.row]
        return cell
    }

    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("Selected: \(items[indexPath.row])")
    }
}
