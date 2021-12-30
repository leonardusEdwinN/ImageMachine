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

