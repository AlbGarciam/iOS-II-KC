//
//  AppDelegate.swift
//  Midia
//
//  Created by Julio Martínez Ballester on 2/25/19.
//  Copyright © 2019 AlbGarciam. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        guard let tabBarController = window?.rootViewController as? UITabBarController,
            let homeViewController = tabBarController.viewControllers?.first as? HomeViewController,
            let searchViewController = tabBarController.viewControllers?[1] as? SearchViewController else {
                fatalError("Wrong initial setup")
        }
        
        homeViewController.mediaItemProvider = Repository.shared.mediaProvider
        searchViewController.mediaItemProvider = Repository.shared.mediaProvider
        return true
    }
}

