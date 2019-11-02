//
//  CoreDataManager.swift
//  PersistentTodoList
//
//  Created by Alok Upadhyay on 30/03/2018.
//  Copyright © 2017 Alok Upadhyay. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
  
  //1
  static let sharedManager = CoreDataManager()
  private init() {} // Prevent clients from creating another instance.
  
  //2
  lazy var persistentContainer: NSPersistentContainer = {
    
    let container = NSPersistentContainer(name: "PersonData")
    
    
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()
  
  //3
  func saveContext () {
    let context = CoreDataManager.sharedManager.persistentContainer.viewContext
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
  
  /*Insert*/
  func insertPerson(name: String, ssn : Int16)->Person? {
    
    /*1.
     Before you can save or retrieve anything from your Core Data store, you first need to get your hands on an NSManagedObjectContext. You can consider a managed object context as an in-memory “scratchpad” for working with managed objects.
     Think of saving a new managed object to Core Data as a two-step process: first, you insert a new managed object into a managed object context; then, after you’re happy with your shiny new managed object, you “commit” the changes in your managed object context to save it to disk.
     Xcode has already generated a managed object context as part of the new project’s template. Remember, this only happens if you check the Use Core Data checkbox at the beginning. This default managed object context lives as a property of the NSPersistentContainer in the application delegate. To access it, you first get a reference to the app delegate.
     */
    let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
    
    /*
     An NSEntityDescription object is associated with a specific class instance
     Class
     NSEntityDescription
     A description of an entity in Core Data.
     
     Retrieving an Entity with a Given Name here person
     */
    let entity = NSEntityDescription.entity(forEntityName: "Person",
                                            in: managedContext)!
    
    
    /*
     Initializes a managed object and inserts it into the specified managed object context.
     
     init(entity: NSEntityDescription,
     insertInto context: NSManagedObjectContext?)
     */
    let person = NSManagedObject(entity: entity,
                                 insertInto: managedContext)
    
    /*
     With an NSManagedObject in hand, you set the name attribute using key-value coding. You must spell the KVC key (name in this case) exactly as it appears in your Data Model
     */
    person.setValue(name, forKeyPath: "name")
    person.setValue(ssn, forKeyPath: "ssn")
    
    /*
     You commit your changes to person and save to disk by calling save on the managed object context. Note save can throw an error, which is why you call it using the try keyword within a do-catch block. Finally, insert the new managed object into the people array so it shows up when the table view reloads.
     */
    do {
      try managedContext.save()
      return person as? Person
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
      return nil
    }
  }
  
  func update(name:String, ssn : Int16, person : Person) {
    
    /*1.
     Before you can save or retrieve anything from your Core Data store, you first need to get your hands on an NSManagedObjectContext. You can consider a managed object context as an in-memory “scratchpad” for working with managed objects.
     Think of saving a new managed object to Core Data as a two-step process: first, you insert a new managed object into a managed object context; then, after you’re happy with your shiny new managed object, you “commit” the changes in your managed object context to save it to disk.
     Xcode has already generated a managed object context as part of the new project’s template. Remember, this only happens if you check the Use Core Data checkbox at the beginning. This default managed object context lives as a property of the NSPersistentContainer in the application delegate. To access it, you first get a reference to the app delegate.
     */
    let context = CoreDataManager.sharedManager.persistentContainer.viewContext
    
    do {
      
      
      /*
       With an NSManagedObject in hand, you set the name attribute using key-value coding. You must spell the KVC key (name in this case) exactly as it appears in your Data Model
       */
      person.setValue(name, forKey: "name")
      person.setValue(ssn, forKey: "ssn")
      
        print("\(String(describing: person.value(forKey: "name")))")
        print("\(String(describing: person.value(forKey: "ssn")))")
      
      /*
       You commit your changes to person and save to disk by calling save on the managed object context. Note save can throw an error, which is why you call it using the try keyword within a do-catch block. Finally, insert the new managed object into the people array so it shows up when the table view reloads.
       */
      do {
        try context.save()
        print("saved!")
      } catch let error as NSError  {
        print("Could not save \(error), \(error.userInfo)")
      } catch {
        
      }
      
    } catch {
      print("Error with request: \(error)")
    }
  }
  
  /*delete*/
  func delete(person : Person){
    
    let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
    
    do {
      
      managedContext.delete(person)
      
    } catch {
      // Do something in response to error condition
      print(error)
    }
    
    do {
      try managedContext.save()
    } catch {
      // Do something in response to error condition
    }
  }
  
  func fetchAllPersons() -> [Person]?{
    
    
    /*Before you can do anything with Core Data, you need a managed object context. */
    let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
    
    /*As the name suggests, NSFetchRequest is the class responsible for fetching from Core Data.
     
     Initializing a fetch request with init(entityName:), fetches all objects of a particular entity. This is what you do here to fetch all Person entities.
     */
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
    
    /*You hand the fetch request over to the managed object context to do the heavy lifting. fetch(_:) returns an array of managed objects meeting the criteria specified by the fetch request.*/
    do {
      let people = try managedContext.fetch(fetchRequest)
      return people as? [Person]
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
      return nil
    }
  }
  
  func delete(ssn: String) -> [Person]? {
    /*get reference to appdelegate file*/
    
    
    /*get reference of managed object context*/
    let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
    
    /*init fetch request*/
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
    
    /*pass your condition with NSPredicate. We only want to delete those records which match our condition*/
    fetchRequest.predicate = NSPredicate(format: "ssn == %@" ,ssn)
    do {
      
      /*managedContext.fetch(fetchRequest) will return array of person objects [personObjects]*/
      let item = try managedContext.fetch(fetchRequest)
      var arrRemovedPeople = [Person]()
      for i in item {
        
        /*call delete method(aManagedObjectInstance)*/
        /*here i is managed object instance*/
        managedContext.delete(i)
        
        /*finally save the contexts*/
        try managedContext.save()
        
        /*update your array also*/
        arrRemovedPeople.append(i as! Person)
      }
      return arrRemovedPeople
      
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
  return nil
    }
    
  }
}

