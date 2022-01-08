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
    
    // MARK: Add Data Machine
    func setDataMachine(name: String, type:String, QRNumber: String, lastMaintain : Date, machine: MachineEntity) {
        
        let machine = machine
        machine.id = "\(UUID())"
        machine.name = name
        machine.type = type
        machine.qrCodeNumber = QRNumber
        machine.maintenanceDate = lastMaintain
        save()
    }
    
    // MARK: Get List Data Machine
    func getListMachines(sortBy: String) -> [MachineEntity] {
        let request: NSFetchRequest<MachineEntity> = MachineEntity.fetchRequest()
        let sort = NSSortDescriptor(key: "\(sortBy)", ascending: true)
        
        request.sortDescriptors = [sort]
        
        var listMachines: [MachineEntity] = []
        
        do {
            listMachines = try persistentContainer.viewContext.fetch(request)
            
        } catch {
            print("Error fetching list machines")
        }
        
        
        return listMachines
    }
    
    
    // MARK: Delete Data Machine
    func deleteMachine(machine : MachineEntity) {
        persistentContainer.viewContext.delete(machine)
        save()
    }
    
    // MARK: Get Machine By ID
    func getMachineById(id: String) -> MachineEntity {
        let request: NSFetchRequest<MachineEntity> = MachineEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", id)
        
        var machine: MachineEntity?
        
        do {
            machine =  try persistentContainer.viewContext.fetch(request).first
        } catch let error as NSError {
            print("Error fetching machine : \(error)")
        }
        
        return machine ?? MachineEntity()
    }
    
    // MARK: Get Machine by QR Code Number
    func getMachineByQRCode(qrCodeNumber: String) -> MachineEntity {
        let request: NSFetchRequest<MachineEntity> = MachineEntity.fetchRequest()
        request.predicate = NSPredicate(format: "qrCodeNumber = %@", qrCodeNumber)
        
        var machine: MachineEntity?
        
        do {
            
            machine =  try persistentContainer.viewContext.fetch(request).first
        } catch let error as NSError {
            print("Error :: \(error)")
        }
        
        return machine ?? MachineEntity()
    }
    
    // MARK: Update Machine By ID
    func updateMachineById(idMachine: String, name: String, type:String, QRNumber: String, lastMaintain : Date){
        // 1. fetch data
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MachineEntity")
        
        // 2. set predicate (condition)
        fetchRequest.predicate = NSPredicate(format: "id = %@", idMachine)
        
        // 3. execute update
        do {
            let objects = try context.fetch(fetchRequest)
            let objectToBeUpdated = objects[0] as!NSManagedObject
            objectToBeUpdated.setValue(name, forKey: "name")
            objectToBeUpdated.setValue(type, forKey: "type")
            objectToBeUpdated.setValue(QRNumber, forKey: "qrCodeNumber")
            objectToBeUpdated.setValue(lastMaintain, forKey: "maintenanceDate")
        } catch {
            // do something if error
        }
        
        // 4. save
        do {
            try
            context.save()
        } catch let error as NSError {
            // do something if error...
            print("ERROR UPDATE DATA :\(error)")
        }
    }
    
    // MARK: GET LIST IMAGE OF MACHINE
    func getImageMachineThumbnailById(idMachine: String) -> [ImageEntity] {
        let request: NSFetchRequest<ImageEntity> = ImageEntity.fetchRequest()
        request.predicate = NSPredicate(format: "machineImage.id = %@", idMachine)
        
        var imageThumbnail: [ImageEntity] = []
        
        do {
            imageThumbnail =  try persistentContainer.viewContext.fetch(request)
        } catch {
            print("Error fetching image Thumbnail of machine")
        }
        
        return imageThumbnail
    }
    
    // MARK: GET MACHINE IMAGE
    func addMachineImage(machine : MachineEntity, imageString: String) {
        //masukin
        let image = ImageEntity(context: persistentContainer.viewContext)
        image.id = "\(UUID())"
        image.image = imageString
        image.machineImage = machine
        save()
    }
    
    // MARK: DELETE MACHINE IMAGE
    func deleteMachineImageThumbanail(image : ImageEntity) {
        persistentContainer.viewContext.delete(image)
        save()
    }
    
    
    
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

