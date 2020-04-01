//
//  ViewController.swift
//  MockingObject
//
//  Created by kuanwei on 2020/4/1.
//  Copyright © 2020 kuanwei. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    let app = UIApplication.shared.delegate as! AppDelegate
    var viewContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        viewContext = app.persistentContainer.viewContext
        print(NSPersistentContainer.defaultDirectoryURL())
        
//        insertPersonData()
        queryPersonData()
//        deletePersonsOneByOne()
//        insertPersonData()
//        queryWithPredicate()
        deletePersonsBatch()
    }
    
    func insertPersonData() {
        var person = NSEntityDescription.insertNewObject(forEntityName: "Person", into: viewContext) as! Person
        person.birthday = NSDate()
        person.lastName = "lin"
        person.firstName = "david"
        
        person = NSEntityDescription.insertNewObject(forEntityName: "Person", into: viewContext) as! Person
        person.birthday = NSDate()
        person.lastName = "cheng"
        person.firstName = "ellen"
        
        app.saveContext()
    }
    
    func queryPersonData() {
        do {
            let allPersons = try viewContext.fetch(Person.fetchRequest())
            for person in allPersons as! [Person] {
                print(#function)
                print("\(person.birthday), \(person.firstName), \(person.lastName)")
            }
        } catch {
            print(error)
        }
    }
    
    func queryWithPredicate() {
        let personFetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        let predicate = NSPredicate(format: "lastName like 'lin*'")
        personFetchRequest.predicate = predicate
        
        do {
            let persons = try viewContext.fetch(personFetchRequest)
            for person in persons {
                print(#function)
                print("\(person.birthday), \(person.firstName), \(person.lastName)")
            }
        } catch {
            print(error)
        }
    }
    
    func deletePersonsOneByOne() {
        let personFetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        do {
            let persons = try viewContext.fetch(personFetchRequest)
            for person in persons {
                print(#function)
                viewContext.delete(person)
            }
            app.saveContext()
        } catch {
            print(error)
        }
    }
    
    func deletePersonsBatch() {
        let batch = NSBatchDeleteRequest(fetchRequest: Person.fetchRequest())
        do {
            try app.persistentContainer.persistentStoreCoordinator.execute(batch, with: viewContext)
        } catch {
            print(error)
        }
    }
}
