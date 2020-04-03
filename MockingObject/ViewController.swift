//
//  ViewController.swift
//  MockingObject
//
//  Created by kuanwei on 2020/4/1.
//  Copyright © 2020 kuanwei. All rights reserved.
//

import UIKit
import CoreData

// CoreDate demo code
class ViewController: UIViewController {
    let app = UIApplication.shared.delegate as? AppDelegate
    var viewContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewContext = app?.persistentContainer.viewContext
        print(NSPersistentContainer.defaultDirectoryURL())
        
//        insertPersonData()
//        queryPersonData()
//        deletePersonsOneByOne()
//        insertPersonData()
//        queryWithPredicate()
//        deletePersonsBatch()
//        queryPersonData()
    }
    
    func insertPersonData() {
        guard var person = NSEntityDescription.insertNewObject(forEntityName: "Person", into: viewContext) as? Person else { return }
        person.birthday = NSDate()
        person.lastName = "lin"
        person.firstName = "david"
        
        person = NSEntityDescription.insertNewObject(forEntityName: "Person", into: viewContext) as! Person
        person.birthday = NSDate()
        person.lastName = "cheng"
        person.firstName = "ellen"
        
//        app?.saveContext()
        do {
            try viewContext.save()
        } catch {
            print(error)
        }
    }
    
    func queryPersonData() -> [Person] {
        var allPersons = [Person]()
        do {
            allPersons = try viewContext.fetch(Person.fetchRequest())
            for person in allPersons {
                print(#function)
                print("\(String(describing: person.birthday)), \(String(describing: person.firstName)), \(String(describing: person.lastName))")
            }
        } catch {
            print(error)
        }
        
        return allPersons
    }
    
    func queryWithPredicate() -> [Person] {
        let personFetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        let predicate = NSPredicate(format: "lastName like 'lin*'")
        personFetchRequest.predicate = predicate
        
        var allPersons = [Person]()
        
        do {
            allPersons = try viewContext.fetch(personFetchRequest)
            for person in allPersons {
                print(#function)
                print("\(String(describing: person.birthday)), \(String(describing: person.firstName)), \(String(describing: person.lastName))")
            }
        } catch {
            print(error)
        }
        
        return allPersons
    }
    
    func deletePersonsOneByOne() {
        let personFetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        do {
            let persons = try viewContext.fetch(personFetchRequest)
            for person in persons {
                print(#function)
                viewContext.delete(person)
            }
//            app?.saveContext()
            do {
                try viewContext.save()
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
    }
    
    func deletePersonsBatch() {
        let batch = NSBatchDeleteRequest(fetchRequest: Person.fetchRequest())
        do {
//            try app?.persistentContainer.persistentStoreCoordinator.execute(batch, with: viewContext)
            try viewContext.persistentStoreCoordinator?.execute(batch, with: viewContext)
        } catch {
            print(error)
        }
    }
}
