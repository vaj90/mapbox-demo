//
//  AppDelegate.swift
//  MapDemo
//
//  Created by Allan John Valiente on 2023-04-18.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        window?.makeKeyAndVisible()

        let welcomePage = CalendarPageController()
        let navigationControler = UINavigationController(rootViewController: welcomePage)
        window?.rootViewController = navigationControler
        return true
    }
}

