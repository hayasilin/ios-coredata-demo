//
//  AppDelegate.swift
//  Demo
//
//  Created by kuanwei on 2020/12/3.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    lazy var context: NSManagedObjectContext = {
        guard let modelURL = Bundle.main.url(forResource: "Demo", withExtension: "momd") else {
            fatalError("Failed to find data model")
        }
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Failed to create model from file: \(modelURL)")
        }

        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)

        let dirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last

        let fileURL = URL(string: "Demo.sql", relativeTo: dirURL)

        do {
            try psc.addPersistentStore(
                ofType: NSSQLiteStoreType,
                configurationName: nil,
                at: fileURL,
                options: nil)
        } catch {
            fatalError("Error configuring persistent store: \(error)")
        }

        let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        moc.persistentStoreCoordinator = psc

        generateSampleDataIfNeeded(context: moc)

        return moc
    }()

    func generateSampleDataIfNeeded(context: NSManagedObjectContext) {
        context.perform {
            guard let number = try? context.count(for: Book.fetchRequest()), number == 0 else {
                return
            }

            let numbers = 0...9999
            for _ in 1...50 {
                let newBook = Book(context: context)
                newBook.title = "Book - " + String(format: "%04d", numbers.randomElement()!)
                newBook.uuid = UUID()
            }

            do {
                try context.save()
            } catch {
                print("Failed to save test data: \(error)")
            }
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

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

