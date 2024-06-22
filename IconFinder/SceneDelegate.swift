//
//  SceneDelegate.swift
//  IconFinder
//
//  Created by Петр Постников on 19.06.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = makeTabBarController()
        self.window = window
        window.makeKeyAndVisible()
    }
}

extension SceneDelegate {
    
    private func makeTabBarController() -> UITabBarController {
        let tabBarController = UITabBarController()
        tabBarController.tabBar.tintColor = .balckWhiteColor
        tabBarController.view.backgroundColor = .backgroundColor
        let firstViewController = UINavigationController(rootViewController: MainViewController())
        let secondViewController = UINavigationController(rootViewController: SecondViewController())
        firstViewController.tabBarItem = UITabBarItem(title: "ГЛАВНАЯ", image: nil, tag: 0)
        firstViewController.tabBarItem.accessibilityIdentifier = "ГЛАВНАЯ"
        secondViewController.tabBarItem = UITabBarItem(title: "ИЗБРАННЫЕ", image: nil, tag: 1)
        secondViewController.tabBarItem.accessibilityIdentifier = "ИЗБРАННЫЕ"
        tabBarController.viewControllers = [firstViewController, secondViewController]
        return tabBarController
    }
}


