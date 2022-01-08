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
        DispatchQueue.main.async {
            LoadingScreen.sharedInstance.showIndicator()
        }
        
        if(isEdit){
            //melakukan update data
            if let machineId = self.machineViewModel?.item.id{
                //bisa melakukan update
                machineViewModel?.updateDataMachine(id: machineId, name: machineNameTextField.text ?? "", type: machineTypeTextField.text ?? "", qrNumber: machineQRNumberTextField.text ?? "1", maintenanceDate: machineLastMaintainDatePicker.date, completion: {
                    
                    DispatchQueue.main.async {
                        LoadingScreen.sharedInstance.hideIndicator()
                    }
                    
                    self.view.window!.rootViewController?.dismiss(animated: false,completion: {
                            self.delegate?.reloadDataAfterEditOrAdd()

                    })
                })
                
            }
            
            
        }else{
            machineViewModel?.setNewDataMachine(name: machineNameTextField.text ?? "", type: machineTypeTextField.text ?? "", qrNumber: machineQRNumberTextField.text ?? "1", maintenanceDate: machineLastMaintainDatePicker.date, completion: {
                DispatchQueue.main.async {
                    LoadingScreen.sharedInstance.hideIndicator()
                }
                
                self.view.window!.rootViewController?.dismiss(animated: false,completion: {
                        self.delegate?.reloadDataAfterEditOrAdd()

                })
            })
            
            
            
        }
        
       
    }
    
    // MARK: Variable Pass
    var machineViewModel : MachineViewModel?
    
    // MARK: Variable
    var isEdit : Bool = false
    var delegate : ReloadDataListMachineDelegate?
    var listImageThumbnailViewModel = ListImageThumbnailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        hideKeyboardWhenTappedAround()
        setUI()
        checkState()
    }
    
    func checkState(){
        if(listImageThumbnailViewModel.numberOfRows(0) == 0){
            emptyState.isHidden = false
            machineImageThumbnailTableView.isHidden = true
        }else{
            emptyState.isHidden = true
            machineImageThumbnailTableView.isHidden = false
        }
    }
    
    func setUI(){
        if(self.isEdit){
            //ada data,is edit true
            machineNameTextField.text = machineViewModel?.item.name
            machineTypeTextField.text = machineViewModel?.item.type
            machineQRNumberTextField.text = machineViewModel?.item.qrCodeNumber
            machineLastMaintainDatePicker.date = machineViewModel?.item.maintenanceDate ?? Date()
            getListImage() //ambil data imagenya
        }else{
            //is edit false
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
        DispatchQueue.main.async {
            LoadingScreen.sharedInstance.showIndicator()
        }
        
        if let id = self.machineViewModel?.item.id{
            listImageThumbnailViewModel.getListThumbnailByMachine(byId: id, completion: { ListImageThumbnailVM in
                DispatchQueue.main.async {
                    LoadingScreen.sharedInstance.hideIndicator()
                    self.machineImageThumbnailTableView.reloadData()
                    self.checkState()
                }
            })
        }
        
    }
}

extension AddEditDataViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var cellCount: Int = 0
        if(self.machineViewModel?.item != nil){
            //ada data
            cellCount = listImageThumbnailViewModel.numberOfRows(section)
            
        }else{
            cellCount = 0
        }
        
        return cellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = tableView.dequeueReusableCell(withIdentifier: "machineImageThumbnailTableViewCell", for: indexPath) as! MachineImageThumbnailTableViewCell
        
        let imageThumbnails = self.listImageThumbnailViewModel.modelAt(indexPath.row).item
        row.setImageName(title: imageThumbnails.image ?? "")
        
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

            if let deletedImagethumbnailVM = self?.listImageThumbnailViewModel.modelAt(indexPath.row){
                //update data status
                deletedImagethumbnailVM.deleteImage(image: deletedImagethumbnailVM.item) {
                    DispatchQueue.main.async {
                        self?.getListImage()
                    }
                }
            }

            
            completionHandler(true)
        }
        
        delete.image = UIImage(systemName: "trash")?.withTintColor(.white)
        delete.backgroundColor = UIColor(named: "DeleteColor")
        
        
        let configuration = UISwipeActionsConfiguration(actions: [delete])

        return configuration
    }
    
    
}


