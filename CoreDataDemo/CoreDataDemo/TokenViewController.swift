//
//  TokenViewController.swift
//  CoreDataDemo
//
//  Created by kuanwei on 2021/4/21.
//  Copyright © 2021 kuanwei. All rights reserved.
//

import UIKit
import CoreData

class TokenViewController: UIViewController {

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        return tableView
    }()

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var items: [ManagedToken]?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        tableView.frame = view.bounds
        view.addSubview(tableView)

        configureView()

        fetchItems()
    }

    private func configureView() {
        let addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        let filterBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(filterItem))
        navigationItem.rightBarButtonItems = [addBarButtonItem, filterBarButtonItem]

    }

    func fetchItems(_ request: NSFetchRequest<ManagedToken> = NSFetchRequest<ManagedToken>(entityName: ManagedToken.entityName)) {

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
    func addItem(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Token", message: "What is the channel id", preferredStyle: .alert)
        alert.addTextField { (textField) in

        }

        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let textField = alert.textFields?[0]

            let token = ManagedToken(context: self.context)
            token.tokenId = textField?.text ?? "dummy"
            token.encryptedToken = Data()
            token.expirationDate = Int64(Date().timeIntervalSince1970)

            do {
                try self.context.save()
            } catch {
                print(error.localizedDescription)
            }

            self.fetchItems()
        }

        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    @objc
    func filterItem() {
        let alert = UIAlertController(title: "Filter token", message: "What is filter channel id", preferredStyle: .alert)
        alert.addTextField { (textField) in

        }

        let action = UIAlertAction(title: "filter", style: .default) { (action) in
            let textField = alert.textFields?[0]
            guard let filterText = textField?.text else {
                return
            }

            let request = NSFetchRequest<ManagedToken>(entityName: ManagedToken.entityName)
            let predicate = NSPredicate(format: "tokenId = %@", filterText) // need to be 100% match
            request.predicate = predicate

            self.fetchItems(request)
        }

        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

extension TokenViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)

        let token = items?[indexPath.row]

        cell.textLabel?.text = token?.tokenId

        return cell
    }
}

extension TokenViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let token = self.items![indexPath.row]

        let alert = UIAlertController(title: "Edit Token", message: "Edit channel id", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = token.tokenId
        }

        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let textField = alert.textFields?[0]

            token.tokenId = textField?.text ?? "dummy"

            do {
                try self.context.save()
            } catch {
                print(error.localizedDescription)
            }

            self.fetchItems()
        }

        alert.addAction(action)
        present(alert, animated: true, completion: nil)

    }

    func TokenViewController(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            let personToRemove = self.items![indexPath.row]
            self.context.delete(personToRemove)
            do {
                try self.context.save()
            } catch {
                print(error.localizedDescription)
            }

            self.fetchItems()
        }

        return UISwipeActionsConfiguration(actions: [action])
    }
}
