//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by kuanwei on 2020/8/28.
//  Copyright © 2020 kuanwei. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var items: [Person]?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        let addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        let filterBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(filterItem))
        let sortBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(sortItem))
        navigationItem.rightBarButtonItems = [addBarButtonItem, filterBarButtonItem, sortBarButtonItem]

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))

        fetchPeople()
    }

    func showRelationship() {
        let family = Family(context: context)
        family.name = "Abc Family"

        let person = Person(context: context)
        person.name = "Maggie"
        person.family = family

        family.addToPeople(person)

        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }

    func fetchPeople(_ request: NSFetchRequest<Person> = Person.fetchRequest()) {
        do {
            items = try context.fetch(request)

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    @objc
    func sortItem() {
        let request = Person.fetchRequest() as NSFetchRequest<Person>
        let sort = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sort]
        fetchPeople(request)
    }

    @objc
    func filterItem() {
        let alert = UIAlertController(title: "Filter Person", message: "What is filter name", preferredStyle: .alert)
        alert.addTextField { (textField) in

        }

        let action = UIAlertAction(title: "filter", style: .default) { (action) in
            let textField = alert.textFields?[0]
            guard let filterText = textField?.text else {
                return
            }

            let request = Person.fetchRequest() as NSFetchRequest<Person>

            let predicate = NSPredicate(format: "name CONTAINS %@", filterText)
            request.predicate = predicate

            self.fetchPeople(request)
        }

        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    @objc
    func addItem(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Person", message: "What is their name", preferredStyle: .alert)
        alert.addTextField { (textField) in

        }

        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let textField = alert.textFields?[0]

            let newPerson = Person(context: self.context)
            newPerson.name = textField?.text
            newPerson.age = 20
            newPerson.gender = "Male"

            do {
                try self.context.save()
            } catch {
                print(error.localizedDescription)
            }

            self.fetchPeople(Person.fetchRequest())
        }

        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)

        let person = items?[indexPath.row]

        cell.textLabel?.text = person?.name

        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let person = self.items![indexPath.row]

        let alert = UIAlertController(title: "Edit Person", message: "Edit name", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = person.name
        }

        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let textField = alert.textFields?[0]

            person.name = textField?.text

            do {
                try self.context.save()
            } catch {
                print(error.localizedDescription)
            }

            self.fetchPeople()
        }

        alert.addAction(action)
        present(alert, animated: true, completion: nil)

    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            let personToRemove = self.items![indexPath.row]
            self.context.delete(personToRemove)
            do {
                try self.context.save()
            } catch {
                print(error.localizedDescription)
            }

            self.fetchPeople()
        }

        return UISwipeActionsConfiguration(actions: [action])
    }
}
