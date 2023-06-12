//
//  AppDelegate.swift
//  personal-spending
//
//  Created by Ly Truong H. VN.Danang on 25/05/2023.
//

import UIKit
import CoreData
import GoogleMobileAds

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "DataPersonal")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        let isChangeRoot = UserDefaults.standard.bool(forKey: ExtenStrings.kChangeRoot)
        var vc = UIViewController()
        if isChangeRoot {
            vc = WelcomeViewController()
        } else {
            vc = GetStartedViewController()
        }
//        let navi = UINavigationController(rootViewController: vc)
//        let vc = LifeLogHistoryController.vc()
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
        return true
    }

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {

                fatalError("Unresolved error")
            }
        }
    }


}

