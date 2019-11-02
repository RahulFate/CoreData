//
//  ViewController.swift
//  PersonData
//
//  Created by Alok Upadhyay on 3/28/18.
//  Copyright © 2018 Alok. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  
  var people: [NSManagedObject] = []

  
  @IBAction func addName(_ sender: Any) {
    
    let alert = UIAlertController(title: "New Name",
                                  message: "Add a new name",
                                  preferredStyle: .alert)
    
    
    alert.addTextField(configurationHandler: { (textFieldName) in
      textFieldName.placeholder = "name"
    })
    
    alert.addTextField(configurationHandler: { (textFieldSSN) in
      
      textFieldSSN.placeholder = "ssn"
    })
    
    let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] action in
      
      guard let textField = alert.textFields?.first,
        let nameToSave = textField.text else {
          return
      }
      
      guard let textFieldSSN = alert.textFields?[1],
        let SSNToSave = textFieldSSN.text else {
          return
      }
      
      self.save(name: nameToSave, ssn: Int16(SSNToSave)!)
      self.tableView.reloadData()
    }
    
    let cancelAction = UIAlertAction(title: "Cancel",
                                     style: .default)
    
    alert.addAction(saveAction)
    alert.addAction(cancelAction)
    
    present(alert, animated: true)
  }
  
  //insert
  func save(name: String, ssn : Int16) {
    
    let person = CoreDataManager.sharedManager.insertPerson(name: name, ssn: ssn)
    
    if person != nil {
      people.append(person!)
      tableView.reloadData()
    }
  }
  
  @IBAction func deleteAction(_ sender: Any) {
    
    /*init alert controller with title and message*/
    let alert = UIAlertController(title: "Delete by ssn", message: "Enter ssn", preferredStyle: .alert)
    
    /*configure delete action*/
    let deleteAction = UIAlertAction(title: "Delete", style: .default) { [unowned self] action in
      guard let textField = alert.textFields?.first , let itemToDelete = textField.text else {
        return
      }
      /*pass ssn number to delete(:) method*/
      self.delete(ssn: itemToDelete)
      /*reoad tableview*/
      self.tableView.reloadData()
      
    }
    
    /*configure cancel action*/
    let cancelAciton = UIAlertAction(title: "Cancel", style: .default)
    
    /*add text field*/
    alert.addTextField()
    /*add actions*/
    
    alert.addAction(deleteAction)
    alert.addAction(cancelAciton)
    
    present(alert, animated: true, completion: nil)
  }
  
  func delete(ssn: String) {
    
    let arrRemovedObjects = CoreDataManager.sharedManager.delete(ssn: ssn)
    people = people.filter({ (param) -> Bool in
      
      if (arrRemovedObjects?.contains(param as! Person))!{
        return false
      }else{
        return true
      }
    })
    
  }
  
  func fetchAllPersons(){

    if CoreDataManager.sharedManager.fetchAllPersons() != nil{
      
      people = CoreDataManager.sharedManager.fetchAllPersons()!

    }
  }
  
    
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    fetchAllPersons()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    tableView.register(UITableViewCell.self,
                       forCellReuseIdentifier: "Cell")
  }
  
  func delete(person : Person){
    CoreDataManager.sharedManager.delete(person: person)
  }
  
  func update(name:String, ssn : Int16, person : Person) {
    CoreDataManager.sharedManager.update(name: name, ssn: ssn, person: person)
  }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return people.count
  }
  
  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let person = people[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",
                                             for: indexPath)
    cell.textLabel?.text = person.value(forKeyPath: "name") as? String
    return cell
}
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    /*get managed object*/
    let person = people[indexPath.row]
    
    /*initialize alert controller*/
    let alert = UIAlertController(title: "Update Name",
                                  message: "Update Name",
                                  preferredStyle: .alert)
    
    /*add name textfield*/
    alert.addTextField(configurationHandler: { (textFieldName) in
      
      /*set name as plaveholder in textfield*/
      textFieldName.placeholder = "name"
      
      /*use key value coding to get value for key "name" and set it as text of UITextField.*/
      textFieldName.text = person.value(forKey: "name") as? String
      
    })
    
    /*add ssn textfield*/
    alert.addTextField(configurationHandler: { (textFieldSSN) in
      
      /*set ssn as plaveholder in textfield*/
      textFieldSSN.placeholder = "ssn"
      
      /*use key value coding to get value for key "ssn" and set it as text of UITextField.*/
      
      textFieldSSN.text = "\(person.value(forKey: "ssn") as? Int16 ?? 0)"
    })
    
    /*configure update event*/
    let updateAction = UIAlertAction(title: "Update", style: .default) { [unowned self] action in
      
      guard let textField = alert.textFields?[0],
        let nameToSave = textField.text else {
          return
      }
      
      guard let textFieldSSN = alert.textFields?[1],
        let SSNToSave = textFieldSSN.text else {
          return
      }
      
      /*imp part, responsible for update, pass nameToSave and SSn to update: method.*/
      self.update(name : nameToSave, ssn: Int16(SSNToSave)!, person : person as! Person)
      
      /*finally reload table view*/
      self.tableView.reloadData()
      
    }
    
    /*configure delete event*/
    let deleteAction = UIAlertAction(title: "Delete", style: .default) { [unowned self] action in
      
      /*look at implementation of delete method */
      
      self.delete(person : person as! Person)
      
      /*remove person object from array also, so that datasource have correct data*/
      self.people.remove(at: (self.people.index(of: person))!)
      
      /*Finally reload tableview*/
      self.tableView.reloadData()
      
    }
    
    /*configure cancel action*/
    let cancelAction = UIAlertAction(title: "Cancel",
                                     style: .default)
    
    /*add all the actions*/
    alert.addAction(updateAction)
    alert.addAction(cancelAction)
    alert.addAction(deleteAction)
    
    /*finally present*/
    present(alert, animated: true)
    
  }
}
