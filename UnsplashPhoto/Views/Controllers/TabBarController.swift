//
//  TabBarController.swift
//  UnsplashPhoto
//
//  Created by Pavel Yarovoi on 01.08.2022.
//

import UIKit

final class TabBarController: UITabBarController {
    
    // MARK: - Public Properties
    let viewModel = PhotoViewModel()
    
    // MARK: Private properties
    private enum TabBarItem {
        case randomPhoto
        case searchPhoto
        case favoritePhoto
        
        var title: String {
            switch self {
            case .randomPhoto:
                return "Popular"
            case .searchPhoto:
                return "Search"
            case .favoritePhoto:
                return "Favorites"
            }
        }
        
        var iconName: String {
            switch self {
            case .randomPhoto:
                return "photo.on.rectangle.angled"
            case .searchPhoto:
                return "magnifyingglass"
            case .favoritePhoto:
                return "star"
            }
        }
    }
    
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBar.tintColor = .label
        self.tabBar.scrollEdgeAppearance = self.tabBar.standardAppearance
        setupTabBar()
    }
    
    // MARK: - Private Methods
    private func setupTabBar() {
        let dataSource: [TabBarItem] = [.randomPhoto, .searchPhoto, .favoritePhoto]
        
        self.viewControllers = dataSource.map { item in
            switch item {
            case .randomPhoto:
                let photoController = RandomPhotoController()
                return wrappedInNavigationController(with: photoController, title: item.title)
            case .searchPhoto:
                let photoController = SearchPhotoController()
                return wrappedInNavigationController(with: photoController, title: item.title)
            case .favoritePhoto:
                let photoController = FavoritePhotoController()
                return wrappedInNavigationController(with: photoController, title: item.title)
            }
        }
        
        self.viewControllers?.enumerated().forEach { itemIndex, controller in
            controller.tabBarItem.title = dataSource[itemIndex].title
            controller.tabBarItem.image = UIImage(systemName: dataSource[itemIndex].iconName)
        }
        
    }
    
    private func wrappedInNavigationController(with controller: UIViewController, title: String) -> UINavigationController {
        controller.navigationItem.title = "\(title) photo"
        return UINavigationController(rootViewController: controller)
    }

}
