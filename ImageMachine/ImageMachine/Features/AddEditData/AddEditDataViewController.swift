//
//  AddEditDataViewController.swift
//  ImageMachine
//
//  Created by Edwin Niwarlangga on 27/12/21.
//

import Foundation
import UIKit
protocol ReloadDataListMachineDelegate{
    func reloadDataAfterEditOrAdd()
}

class AddEditDataViewController: UIViewController{
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var machineNameLabel: UILabel!
    @IBOutlet weak var machineNameTextField: UITextField!
    
    @IBOutlet weak var machineTypeLabel: UILabel!
    @IBOutlet weak var machineTypeTextField: UITextField!
    
    @IBOutlet weak var machineQRNumberLabel: UILabel!
    @IBOutlet weak var machineQRNumberTextField: UITextField!
    
    @IBOutlet weak var machineLastMaintainDateLabel: UILabel!
    @IBOutlet weak var machineLastMaintainDatePicker: UIDatePicker!
    
    @IBOutlet weak var machineImageThumbnailLabel: UILabel!
    @IBOutlet weak var machineImageThumbnailTableView: UITableView!
    
    @IBOutlet weak var emptyState: UIView!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        if(isEdit){
            //melakukan update data
            if let machineId = machineData.id{
                //bisa melakukan update
                PersistanceManager.shared.updateMachineById(idMachine: machineId, name: machineNameTextField.text ?? "", type: machineTypeTextField.text ?? "", QRNumber: machineQRNumberTextField.text ?? "1", lastMaintain: machineLastMaintainDatePicker.date )
            }
            
            
        }else{
            PersistanceManager.shared.setDataMachine(name: machineNameTextField.text ?? "", type: machineTypeTextField.text ?? "", QRNumber: machineQRNumberTextField.text ?? "1", lastMaintain: machineLastMaintainDatePicker.date)
            
            
        }
        
        
//        self.dismiss(animated: false, completion: {
//            self.delegate?.reloadDataAfterEditOrAdd()
//        })
        
        self.view.window!.rootViewController?.dismiss(animated: false,completion: {

                self.delegate?.reloadDataAfterEditOrAdd()

        })
        
        
    }
    
    // MARK: Variable Pass
    var machineData : MachineEntity!
    
    // MARK: Variable
    var isEdit : Bool = false
    var delegate : ReloadDataListMachineDelegate?
    var machineImageThumbnail : [ImageEntity] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        hideKeyboardWhenTappedAround()
        setUI()
        checkState()
    }
    
    func checkState(){
        if(machineImageThumbnail.count == 0){
            emptyState.isHidden = false
            machineImageThumbnailTableView.isHidden = true
        }else{
            emptyState.isHidden = true
            machineImageThumbnailTableView.isHidden = false
        }
    }
    
    func setUI(){
        if(machineData != nil){
            //ada data
            self.isEdit = true
            machineNameTextField.text = machineData.name
            machineTypeTextField.text = machineData.type
            machineQRNumberTextField.text = machineData.qrCodeNumber
            machineLastMaintainDatePicker.date = machineData.maintenanceDate ?? Date()
            getListImage() //ambil data imagenya
        }else{
            self.isEdit = false
            machineNameTextField.text = ""
            machineTypeTextField.text = ""
            machineQRNumberTextField.text = ""
            machineLastMaintainDatePicker.date = Date()
        }
        
        saveButton.layer.cornerRadius = 15
        
    }
    
    func registerCell(){
        
        machineImageThumbnailTableView.register(UINib.init(nibName: "MachineImageThumbnailTableViewCell", bundle: nil), forCellReuseIdentifier: "machineImageThumbnailTableViewCell")
        
        machineImageThumbnailTableView.delegate = self
        machineImageThumbnailTableView.dataSource = self
        
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(AddEditDataViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func getListImage(){
        if let id = self.machineData.id{
            machineImageThumbnail = PersistanceManager.shared.getImageMachineThumbnailById(idMachine: id)
        }
        DispatchQueue.main.async {
            self.machineImageThumbnailTableView.reloadData()
            self.checkState()
        }
    }
}

extension AddEditDataViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var cellCount: Int = 0
        if(self.machineData != nil){
            //ada data
            cellCount = machineImageThumbnail.count
            
        }else{
            cellCount = 0
        }
        
        return cellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = tableView.dequeueReusableCell(withIdentifier: "machineImageThumbnailTableViewCell", for: indexPath) as! MachineImageThumbnailTableViewCell
        
        row.setImageName(title: machineImageThumbnail[indexPath.row].image ?? "")
        
        return row
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        // Delete Action action
        let delete = UIContextualAction(style: .normal,
                                         title: "Delete") { [weak self] (action, view, completionHandler) in

            if let deletedImagethumbnail = self?.machineImageThumbnail[indexPath.row]{
                //update data status
                PersistanceManager.shared.deleteMachineImageThumbanail(image: deletedImagethumbnail)
            }

            DispatchQueue.main.async {
                self?.getListImage()
            }
            completionHandler(true)
        }
        
        delete.image = UIImage(systemName: "trash")?.withTintColor(.white)
        delete.backgroundColor = UIColor(named: "DeleteColor")
        
        
        let configuration = UISwipeActionsConfiguration(actions: [delete])

        return configuration
    }
    
    
}


