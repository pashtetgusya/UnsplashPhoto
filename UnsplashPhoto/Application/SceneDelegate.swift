import UIKit
import Kingfisher

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        ImageCache.default.memoryStorage.config.totalCostLimit = 1
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        let mainController = TabBarController()
        
        window?.overrideUserInterfaceStyle = .light
        window?.windowScene = windowScene
        window?.rootViewController = mainController
        window?.makeKeyAndVisible()
    }
}
