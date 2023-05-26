//
//  AppDelegate.swift
//  personal-spending
//
//  Created by Ly Truong H. VN.Danang on 25/05/2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        let vc = HomeViewController()
        let navi = UINavigationController(rootViewController: vc)
//        let vc = LifeLogHistoryController.vc()
        window?.rootViewController = navi
        window?.makeKeyAndVisible()
        return true
    }


}

