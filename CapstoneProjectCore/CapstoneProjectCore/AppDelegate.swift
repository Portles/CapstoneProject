//
//  AppDelegate.swift
//  CapstoneProject
//
//  Created by Nizamet Özkan on 6.10.2024.
//

import UIKit
import FirebaseCore
import CapstoneProjectUI

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let firstVC = ProductsViewController()
        firstVC.view.backgroundColor = .secondarySystemBackground
        firstVC.title = "Products"
        let firstNavController = UINavigationController(rootViewController: firstVC)
        firstNavController.tabBarItem = UITabBarItem(title: "Shop", image: UIImage(systemName: "bag.fill"), tag: 0)
        
        let secondVC = CartViewController()
        secondVC.view.backgroundColor = .systemBackground
        secondVC.title = "Cart"
        let secondNavController = UINavigationController(rootViewController: secondVC)
        secondNavController.tabBarItem = UITabBarItem(title: "Cart", image: UIImage(systemName: "cart.fill"), tag: 1)
        
        let thirdVC = ProfileViewController()
        thirdVC.view.backgroundColor = .systemBackground
        thirdVC.title = "Profile"
        let thirdNavController = UINavigationController(rootViewController: thirdVC)
        thirdNavController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.crop.circle.fill"), tag: 2)
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [firstNavController, secondNavController, thirdNavController]
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

