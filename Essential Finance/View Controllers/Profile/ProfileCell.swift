//
//  ProfileCell.swift
//  Essential Finance
//
//  Created by Enver Dashdemirov on 05.12.24.
//

import UIKit

class ProfileCell: UITableViewCell {
    
    // MARK: - Subviews
    var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = .account
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var cellLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor.Colors.cellLabelColor
        return label
    }()
    
    var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor.Colors.iconColor
        return imageView
    }()
    
    // MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(cellLabel)
        contentView.addSubview(iconImageView)
        
        setupLayout()
        backgroundColor = UIColor.Colors.viewBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout Setup
    private func setupLayout() {
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            profileImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            profileImageView.widthAnchor.constraint(equalTo: profileImageView.heightAnchor),
            
            cellLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            cellLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 12),
            
            iconImageView.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            iconImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            iconImageView.leadingAnchor.constraint(greaterThanOrEqualTo: cellLabel.trailingAnchor, constant: 8)
        ])
    }
}

