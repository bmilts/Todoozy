//
//  AppDelegate.swift
//  Todoozy
//
//  Created by Brendan Milton on 04/06/2019.
//  Copyright © 2019 Brendan Milton. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Locate realm database
        //print(Realm.Configuration.defaultConfiguration.fileURL)
        
        // Realm
        do {
            _ = try Realm()
        } catch {
            print("Error initializing new realm \(error)")
        }
        
        return true
    }
    
    // MARK: - Core Data stack
    // Lazy method gets memory benefit
    // NSPersistent containter = SQLite Database
    // Can use XML instead
    
//    lazy var persistentContainer: NSPersistentContainer = {
//
//        // 1. Data Model steps
//        // Sets container with name of data model
//        let container = NSPersistentContainer(name: "DataModel")
//
//        // 2. Load
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error as NSError? {
//
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//
//        // Return container set as NSPersisten container
//        return container
//    }()
//
//    // MARK: - Core Data Saving support
//
//    // Saves data if app closes
//
//    func saveContext () {
//
//        // Context update change and play with data until it is commited
//        let context = persistentContainer.viewContext
//        if context.hasChanges {
//            do {
//                try context.save()
//            } catch {
//                let nserror = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//            }
//        }
//    }


}

