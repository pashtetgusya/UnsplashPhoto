import UIKit

final class TabBarController: UITabBarController {
    
    // MARK: - Public properties
    let viewModel = PhotoViewModel()
    
    // MARK: - Private properties
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
                return "heart"
            }
        }
    }
    
    // MARK: - Override methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBar.tintColor = .label
        self.tabBar.scrollEdgeAppearance = self.tabBar.standardAppearance
        setupTabBar()
    }
    
    // MARK: - Private methods
    private func setupTabBar() {
        let dataSource: [TabBarItem] = [.randomPhoto, .searchPhoto, .favoritePhoto]
        
        self.viewControllers = dataSource.map { item in
            switch item {
            case .randomPhoto:
                let randomPhotoController = RandomPhotoController()
                let randomPhotoNavController = wrappedInNavigationController(
                    with: randomPhotoController,
                    title: item.title
                )
                
                return randomPhotoNavController
            case .searchPhoto:
                let searchPhotoController = SearchPhotoController()
                let searchPhotoNavController = wrappedInNavigationController(
                    with: searchPhotoController,
                    title: item.title
                )
                
                return searchPhotoNavController
            case .favoritePhoto:
                let favoritePhotoController = FavoritePhotoController()
                let favoritePhotoNavController = wrappedInNavigationController(
                    with: favoritePhotoController,
                    title: item.title
                )
                
                return favoritePhotoNavController
            }
        }
        
        self.viewControllers?.enumerated().forEach { itemIndex, controller in
            controller.tabBarItem.title = dataSource[itemIndex].title
            controller.tabBarItem.image = UIImage(systemName: dataSource[itemIndex].iconName)
        }
        
    }
    
    private func wrappedInNavigationController(
        with controller: UIViewController,
        title: String
    ) -> UINavigationController {
        controller.navigationItem.title = "\(title) photo"
        
        return UINavigationController(rootViewController: controller)
    }
}
