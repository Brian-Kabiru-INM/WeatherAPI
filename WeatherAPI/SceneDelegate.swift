//
//  SceneDelegate.swift
//  WeatherAPI
//
//  Created by Brian Kabiru on 20/04/2026.
//
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)
        // Create viewcontrollers: tabs for various windows/scenes
        let homeviewController = HomeViewController()
        homeviewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        
        let blogViewController = BlogViewController()
        blogViewController.tabBarItem = UITabBarItem(title: "Blog", image: UIImage(systemName: "book"), tag: 1)
        
        let settingsViewController = SettingsViewController()
        settingsViewController.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 2)
        
        let profileViewController = ProfileLoginViewController()
        profileViewController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 3)
        
        
        // Wrap in navigationController for tabs to be mini-apps
        let homeNav = UINavigationController(rootViewController: homeviewController)
        let blogNav = UINavigationController(rootViewController: blogViewController)
        let settingsNav = UINavigationController(rootViewController: settingsViewController)
        let profileNav = UINavigationController(rootViewController: profileViewController)

        // Add to tab bar controller
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [homeNav, blogNav, settingsNav, profileNav]
        
        window.rootViewController = tabBarController
        window.tintColor = .cyanGreen
        window.makeKeyAndVisible()
        self.window = window
    }
    func sceneDidDisconnect(_ scene: UIScene) {
            // Called as the scene is being released by the system.
            // This occurs shortly after the scene enters the background, or when its session is discarded.
            // Release any resources associated with this scene that can be re-created the next time the scene connects.
            // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
        }

    func sceneDidBecomeActive(_ scene: UIScene) {
            // Called when the scene has moved from an inactive state to an active state.
            // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        }

    func sceneWillResignActive(_ scene: UIScene) {
            // Called when the scene will move from an active state to an inactive state.
            // This may occur due to temporary interruptions (ex. an incoming phone call).
        }

    func sceneWillEnterForeground(_ scene: UIScene) {
            // Called as the scene transitions from the background to the foreground.
            // Use this method to undo the changes made on entering the background.
        }

    func sceneDidEnterBackground(_ scene: UIScene) {
            // Called as the scene transitions from the foreground to the background.
            // Use this method to save data, release shared resources, and store enough scene-specific state information
            // to restore the scene back to its current state.
        }
}
