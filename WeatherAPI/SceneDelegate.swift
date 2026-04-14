import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)
        // Create viewcontrollers: tabs for various windows/scenes
        let homeviewController = HomeViewController()
        homeviewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        
        let settingsViewController = HomeViewController()
        settingsViewController.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 1)
        
        let profileViewController = HomeViewController()
        profileViewController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 2)
        
        // Add to tab bar controller
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [homeviewController, settingsViewController, profileViewController]
        
        // Wrap in navigationController for tabs to be mini-apps
        let homeNav = UINavigationController(rootViewController: homeviewController)
        let settingsNav = UINavigationController(rootViewController: settingsViewController)
        let profileNav = UINavigationController(rootViewController: profileViewController)

        window.rootViewController = tabBarController
        window.tintColor = .systemCyan
        window.makeKeyAndVisible()
        self.window = window
    }
}
