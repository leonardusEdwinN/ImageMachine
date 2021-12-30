//
//  PersistentManager.swift
//  ImageMachine
//
//  Created by Edwin Niwarlangga on 27/12/21.
//

import Foundation
import CoreData

class PersistanceManager {
    static let shared = PersistanceManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ImageMachine")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                print("Error Container: \(error)")
            }
        }
        
        return container
    }()
    
    var context: NSManagedObjectContext {
        let context = PersistanceManager.shared.persistentContainer.viewContext
        context.automaticallyMergesChangesFromParent = true
        return context
    }
    
    func setDataMachine(name: String, type:String, QRNumber: String, lastMaintain : Date) {
        let machine = Machine(context: persistentContainer.viewContext)
        machine.id = "\(UUID())"
        machine.name = name
        machine.type = type
        machine.qrCodeNumber = QRNumber
        machine.maintenanceDate = lastMaintain
        save()
    }
    
    func getListMachines() -> [Machine] {
        let request: NSFetchRequest<Machine> = Machine.fetchRequest()
        
        var listMachines: [Machine] = []
        
        do {
            listMachines = try persistentContainer.viewContext.fetch(request)
        } catch {
            print("Error fetching authors")
        }
        
        return listMachines
    }
    
    func deleteMachine(machine : Machine) {
        persistentContainer.viewContext.delete(machine)
        save()
    }
    
    func getMachineById(id: String) -> Machine {
        let request: NSFetchRequest<Machine> = Machine.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id)
        
        var machine: Machine!
        
        do {
            machine =  try persistentContainer.viewContext.fetch(request).first
        } catch {
            print("Error fetching authors")
        }
        
        return machine
    }
    
    
    // MARK: UPDATE
//    func updateRoutine(id: String, name: String, isEveryDay: Bool, startHabit: Date, category: String, detail: String){
//            // 1. fetch data
//            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Routines")
//
//            // 2. set predicate (condition)
//            fetchRequest.predicate = NSPredicate(format: "id = %@", id)
//
//            // 3. execute update
//            do {
//                let objects = try context.fetch(fetchRequest)
//                let objectToBeUpdated = objects[0] as!NSManagedObject
//                objectToBeUpdated.setValue(name, forKey: "name")
//                objectToBeUpdated.setValue(isEveryDay, forKey: "isEveryday")
//                objectToBeUpdated.setValue(startHabit, forKey: "startHabit")
//                objectToBeUpdated.setValue(category, forKey: "category")
//                objectToBeUpdated.setValue(detail, forKey: "categoryDetail")
//                objectToBeUpdated.setValue(false, forKey: "isCompleted")
//            } catch {
//                // do something if error
//            }
//
//            // 4. save
//            do {
//                try
//                context.save()
//            } catch let error as NSError {
//                // do something if error...
//            }
//        }
    
    
//    func getImageOfMachineID(id: String) -> Machine {
//        let request: NSFetchRequest<Machine> = Machine.fetchRequest()
//
//        var listMachines: [Machine] = []
//
//        do {
//            listMachines = try persistentContainer.viewContext.fetch(request)
//        } catch {
//            print("Error fetching authors")
//        }
//
//        return listMachines
//    }
    
    
    func save () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

