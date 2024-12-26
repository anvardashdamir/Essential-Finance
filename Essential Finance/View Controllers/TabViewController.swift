//
//  TabViewController.swift
//  Essential Finance
//
//  Created by Enver's Macbook Pro on 11/14/24.
//

import UIKit

class TabViewController: UITabBarController {

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
        setupTabs()
    }

    // MARK: - Tab Bar Configuration
    private func configureTabBar() {
        tabBar.tintColor = .black
        tabBar.unselectedItemTintColor = .gray
//        selectedIndex = 0 // Default tab
    }

    // MARK: - Tab Setup
    private func setupTabs() {
        let tabs = [
            createNavController(
                title: "Home",
                image: .home,
                viewController: HomeViewController()
            ),
            createNavController(
                title: "Converter",
                image: .convert,
                viewController: QuotesConverterViewController()
            ),
            createNavController(
                title: "Quotes",
                image: .graphic,
                viewController: OnlineQuotesViewController()
            ),
            createNavController(
                title: "Profile",
                image: .profile,
                viewController: ProfileViewController()
            )
        ]
        
        setViewControllers(tabs, animated: true)
    }

    // MARK: - Helper Method
    private func createNavController(
        title: String,
        image: UIImage?,
        viewController: UIViewController
    ) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem = UITabBarItem(title: title, image: image, tag: 0)
        configureNavigationBar(for: viewController)
        return navigationController
    }

    private func configureNavigationBar(for viewController: UIViewController) {
        viewController.navigationItem.title = "Essential Finance"
        viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "fireworks"),
            style: .plain,
            target: self,
            action: #selector(fireworkButtonTapped)
        )
    }

    // MARK: - Actions
    @objc private func fireworkButtonTapped() {
        print("🎆 FIREWORKS 🎆")
    }
}
