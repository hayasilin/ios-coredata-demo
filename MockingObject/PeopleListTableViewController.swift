//
//  PeopleListTableViewController.swift
//  MockingObject
//
//  Created by kuanwei on 2020/4/1.
//  Copyright © 2020 kuanwei. All rights reserved.
//

import UIKit
import CoreData
import AddressBookUI

class PeopleListTableViewController: UITableViewController {
    var dataProvider: PeopleListDataProviderProtocol?
    var userDefaults = UserDefaults.standard
    var communicator: APICommunicatorProtocol = APICommunicator()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        tableView.dataSource = dataProvider
        tableView.delegate = self
        dataProvider?.tableView = tableView
        dataProvider?.fetch()
    }
    
    func configureViews() {
        self.clearsSelectionOnViewWillAppear = false
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPerson(sender:)))
        navigationItem.leftBarButtonItem = addButton
        
        let segmentedControl: UISegmentedControl = UISegmentedControl(items: ["Last Name", "First Name"])
        segmentedControl.sizeToFit()
        segmentedControl.selectedSegmentIndex = 0;
        segmentedControl.addTarget(self, action: #selector(changeSorting(sender:)), for: .valueChanged)
        self.navigationItem.titleView = segmentedControl
        
        tableView.frame = UIScreen.main.bounds
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    @objc func addPerson(sender: UIBarButtonItem) {
        let picker = ABPeoplePickerNavigationController()
        picker.peoplePickerDelegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func fetchPeopleFromAPI() {
        let allPersonInfos = communicator.getPeople().1
        if let allPersons = allPersonInfos {
            for personInfo in allPersons {
                dataProvider?.addPerson(personInfo: personInfo)
            }
        }
    }
    
    func sendPersonToAPI(personInfo: PersonInfo) {
        print(communicator.postPerson(personInfo: personInfo)!)
    }
    
    @objc func changeSorting(sender: UISegmentedControl) {
        userDefaults.set(sender.selectedSegmentIndex, forKey: "sort")
        userDefaults.synchronize()
        dataProvider?.fetch()
    }
}

extension PeopleListTableViewController: ABPeoplePickerNavigationControllerDelegate {
    func peoplePickerNavigationController(_ peoplePicker: ABPeoplePickerNavigationController, didSelectPerson person: ABRecord) {
        let personInfo = PersonInfo(abRecord: person)
        dataProvider?.addPerson(personInfo: personInfo)
    }
}
