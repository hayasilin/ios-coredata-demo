//
//  ViewController.swift
//  Demo
//
//  Created by kuanwei on 2020/12/3.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private lazy var context: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        return appDelegate!.context
    }()

    private lazy var fetchedResultsController: NSFetchedResultsController<Book> = {
        let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]

        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: context,
                                                    sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        do {
            try controller.performFetch()
        } catch {
            fatalError("###\(#function): Failed to performFetch: \(error)")
        }
        return controller
    }()

    override func viewDidLoad() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))

        do {
            let books = try context.fetch(Book.fetchRequest())
            for book in books as! [Book] {
                print(book)
            }
        } catch {
            print(error)
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let books = fetchedResultsController.fetchedObjects
        return books?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self)) else {
            return UITableViewCell()
        }

        let book = fetchedResultsController.fetchedObjects?[indexPath.row]

        cell.textLabel?.text = book?.title
        cell.detailTextLabel?.text = book?.uuid?.uuidString

        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let book = fetchedResultsController.fetchedObjects?[indexPath.row] {
                context.delete(book)

                do {
                    try context.save()
                } catch {
                    print("Failed to save feedback: \(error)")
                }
            }
        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension ViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}
