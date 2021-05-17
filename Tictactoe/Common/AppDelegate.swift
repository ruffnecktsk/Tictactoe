//
//  AppDelegate.swift
//  Tictactoe
//
//  Created by Mikhail Kirsanov on 17.05.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)

        let startVC = StartScreenInitializer.configure()
        self.window?.rootViewController = startVC
        self.window?.makeKeyAndVisible()
        
        return true
    }
}

