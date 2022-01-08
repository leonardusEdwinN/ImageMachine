//
//  ListMachineViewModel.swift
//  ImageMachine
//
//  Created by Edwin Niwarlangga on 07/01/22.
//

import Foundation

class ListMachineViewModel{
    private var machineResponse = [MachineViewModel]()
    
    func numberOfRows(_ section: Int) -> Int {
        return machineResponse.count
    }
    
    func modelAt(_ index: Int) -> MachineViewModel {
        return machineResponse[index]
    }
    
    func filterQrNumber(_ qrNumber : String) -> Int {
        var intReturn : Int = 0
        let dataGetFilter = machineResponse.filter({$0.item.qrCodeNumber == qrNumber})
        
        if(dataGetFilter.count == 0){
            intReturn = 0
        }else{
            for (index, data) in machineResponse.enumerated(){
                if(data.item.qrCodeNumber == qrNumber){
                    intReturn = index
                }
            }
        }
        
        return intReturn
    }
    
    func getListMachine(sortBy: String, completion: @escaping ([MachineViewModel]) -> Void) {
        if(machineResponse.count > 0){
            machineResponse = []
        }
        
        let dataGet = PersistanceManager.shared.getListMachines(sortBy: sortBy)
        if(dataGet.count == 0){
            completion(self.machineResponse)
        }else{
            for machine in dataGet {
                self.machineResponse.append(MachineViewModel(machine: machine))
            }
            
            completion(self.machineResponse)
        }
        
        
    }
}



class MachineViewModel {

    let item: MachineEntity

    init(machine: MachineEntity) {
        self.item = machine
    }
    
    init(){
        self.item = MachineEntity(context: PersistanceManager.shared.persistentContainer.viewContext)
    }
    

    
    func setNewDataMachine(name: String, type: String, qrNumber: String, maintenanceDate: Date , completion: @escaping () -> Void) {
        do {
            PersistanceManager.shared.setDataMachine(name: name, type: type, QRNumber: qrNumber, lastMaintain: maintenanceDate, machine: self.item)
            completion()
        } catch let error as NSError  {
            print("Error When Add data machine \(error)")
        }
    }
    
    func updateDataMachine(id: String, name: String, type: String, qrNumber: String, maintenanceDate: Date , completion: @escaping () -> Void) {
        do {
            PersistanceManager.shared.updateMachineById(idMachine: id ,name: name, type: type, QRNumber: qrNumber, lastMaintain: maintenanceDate)
            completion()
        } catch let error as NSError  {
            print("Error When Update data machine \(error)")
        }
    }
    
    func deleteMachine(machine: MachineEntity, completion: @escaping () -> Void) {
        do {
            PersistanceManager.shared.deleteMachine(machine: machine)
            completion()
        } catch let error as NSError  {
            print("Error When Deleting data machine \(error)")
        }
        
    }
    
    
    func getMachineDataByMachineId(machineId: String, completion: @escaping (MachineViewModel) -> Void) {
        
        let dataGet = PersistanceManager.shared.getMachineByMachineId(machineId: machineId)
        
        if let result = dataGet.id {
            let vm = MachineViewModel(machine: dataGet)
            completion(vm)
        }else{
            completion(MachineViewModel())
        }
        
    }
    
    func addMachineImage(machineData: MachineEntity, imgStr: String, completion: @escaping () -> Void) {

        do {
            PersistanceManager.shared.addMachineImage(machine: machineData, imageString: imgStr)
            completion()
        } catch let error as NSError  {
            print("Error When Deleting data machine \(error)")
        }
    }
}
