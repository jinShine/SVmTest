//
//  AppDelegate.swift
//  SVmiOS
//
//  Created by 승진김 on 06/03/2019.
//  Copyright © 2019 승진김. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setupKeyWindow()
        
        return true
    }
    
}

extension AppDelegate {
    private func setupKeyWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        let allUserViewController = ProvideObject.allUser.viewController
        let navigationController = UINavigationController(rootViewController: allUserViewController)
        window?.rootViewController = navigationController
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
    }
}
