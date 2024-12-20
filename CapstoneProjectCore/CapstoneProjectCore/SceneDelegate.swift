//
//  SceneDelegate.swift
//  CapstoneProjectCore
//
//  Created by Nizamet Özkan on 17.10.2024.
//

import UIKit
import CapstoneProjectUI
import CapstoneProjectData

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let networkManager: NetworkManager = NetworkManager()
        let main: DispatchQueueInterface = DispatchQueue.main
        
        let firstVCViewModel = ProductsViewModel(networkManager: networkManager, main: main)
        let firstVC = ProductsViewController(viewModel: firstVCViewModel, main: main)
        firstVCViewModel.view = firstVC
        firstVC.view.backgroundColor = .secondarySystemBackground
        firstVC.title = "Products"
        let firstNavController = UINavigationController(rootViewController: firstVC)
        firstNavController.navigationBar.prefersLargeTitles = true
        firstNavController.tabBarItem = UITabBarItem(title: "Shop", image: UIImage(systemName: "bag.fill"), tag: 0)
        
        let secondVCViewModel = CartViewModel(networkManager: networkManager, main: main)
        let secondVC = CartViewController(viewModel: secondVCViewModel, main: main)
        secondVCViewModel.view = secondVC
        secondVC.view.backgroundColor = .systemBackground
        secondVC.title = "Cart"
        let secondNavController = UINavigationController(rootViewController: secondVC)
        secondNavController.tabBarItem = UITabBarItem(title: "Cart", image: UIImage(systemName: "cart.fill"), tag: 1)
        
        let thirdVCViewModel = ProfileViewModel()
        let thirdVC = ProfileViewController(viewModel: thirdVCViewModel)
        thirdVCViewModel.view = thirdVC
        thirdVC.view.backgroundColor = .systemBackground
        thirdVC.title = "Profile"
        let thirdNavController = UINavigationController(rootViewController: thirdVC)
        thirdNavController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.crop.circle.fill"), tag: 2)
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [firstNavController, secondNavController, thirdNavController]
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
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

