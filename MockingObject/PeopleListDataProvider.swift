//
//  PeopleListDataProvider.swift
//  MockingObject
//
//  Created by kuanwei on 2020/4/1.
//  Copyright © 2020 kuanwei. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class PeopleListDataProvider: NSObject, PeopleListDataProviderProtocol, NSFetchedResultsControllerDelegate {
    var managedObjectContext: NSManagedObjectContext?
    weak var tableView: UITableView!
    var fetchedResultsController: NSFetchedResultsController<Person>?
    
    let dateFormatter: DateFormatter = DateFormatter()
    
    let fetchRequest = NSFetchRequest<Person>()
    var entity: NSEntityDescription!
    
    override init() {
        super.init()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
    }
    
    func setUpCoreData() {
        entity = NSEntityDescription.entity(forEntityName: "Person", in: managedObjectContext!)
        fetchRequest.entity = entity
        fetchRequest.fetchBatchSize = 20
        let sortDescriptor = NSSortDescriptor(key: "lastName", ascending: true)
        let sortDescriptors = [sortDescriptor]
        fetchRequest.sortDescriptors = sortDescriptors
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController?.delegate = self
    }
    
    func addPerson(personInfo: PersonInfo) {
        let context = fetchedResultsController?.managedObjectContext
        let entity = fetchedResultsController?.fetchRequest.entity
        let person = NSEntityDescription.insertNewObject(forEntityName: entity!.name!, into: context!) as! Person
        
        person.firstName = personInfo.firstName
        person.lastName = personInfo.lastName
        person.birthday = personInfo.birthday
        
        do {
            try context?.save()
            print("add succfully")
        } catch {
            print(error)
        }
        
    }
    
    func configureCell(cell: UITableViewCell, atIndexPath indexPath: IndexPath) {
        let person = fetchedResultsController?.object(at: indexPath)
        cell.textLabel?.text = "\(String(describing: person!.firstName)) \(String(describing: person!.lastName))"
        cell.detailTextLabel?.text = dateFormatter.string(from: person!.birthday! as Date)
    }
    
    func fetch() {
        let sortKey = UserDefaults.standard.integer(forKey: "sort") == 0 ? "lastName" : "firstName"
        let sortDescriptor = NSSortDescriptor(key: sortKey, ascending: true)
        let sortDescriptors = [sortDescriptor]
        
        fetchedResultsController?.fetchRequest.sortDescriptors = sortDescriptors
        do {
            try fetchedResultsController?.performFetch()
            tableView.reloadData()
        } catch {
            print(error)
        }
    }
}

extension PeopleListDataProvider: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController?.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController?.sections![section]
        return sectionInfo!.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        configureCell(cell: cell, atIndexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = fetchedResultsController?.managedObjectContext
            context?.delete(fetchedResultsController?.object(at: indexPath) as! NSManagedObject)
            
            do {
                try context?.save()
            } catch {
                print(error)
            }
        }
    }
}

extension PeopleListDataProvider {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default: break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            configureCell(cell: tableView.cellForRow(at: indexPath!)!, atIndexPath: indexPath!)
        case .move:
            tableView.deleteRows(at: [indexPath!], with: .fade)
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
