//
//  ListMachineViewController.swift
//  ImageMachine
//
//  Created by Edwin Niwarlangga on 27/12/21.
//

import Foundation
import UIKit

class ListMachineViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    
    
    private var imagePickerControler =  UIImagePickerController()
    
    // MARK: UI Component
    @IBOutlet weak var labelTitle: UILabel!
    @IBAction func sortButtonPressed(_ sender: Any) {
        PresentActionSheetSort()
    }
    @IBAction func moreButtonPressed(_ sender: Any) {
        PresentActionSheetMore()
    }
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var listMachinveTableView: UITableView!
    @IBOutlet weak var navigationView: UIView!
    
    var listMachine : [Machine] = []
    var selectedMachineId : String = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getDataListMachine()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        setUINavigation()
        setTitleButton()
    }
    
    func registerCell(){
        
        listMachinveTableView.register(UINib.init(nibName: "ListMachineTableViewCell", bundle: nil), forCellReuseIdentifier: "listMachineTableViewCell")
        
        listMachinveTableView.delegate = self
        listMachinveTableView.dataSource = self
    }
    
    func setTitleButton(){
        sortButton.setTitle("", for: .normal)
        moreButton.setTitle("", for: .normal)
    }
    
    func getDataListMachine(){
        listMachine = PersistanceManager.shared.getListMachines()
    }
    
    func setUINavigation(){
        navigationView.backgroundColor = UIColor.white
        navigationView.layer.shadowColor = UIColor.gray.cgColor
        navigationView.layer.shadowOffset = CGSize(width: 1, height: 1)
        navigationView.layer.shadowRadius = 1
        navigationView.layer.shadowOpacity = 5
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToQRScanner"{
            if let destVC = segue.destination as? QRScannerViewController {

                destVC.modalPresentationStyle = .fullScreen
            }
        }else if segue.identifier == "GoToDetail"{
            if let destVC = segue.destination as? DetailMachineViewController {
                destVC.selectedIdMachine = self.selectedMachineId
                
            }
        }
    }
    
}

extension ListMachineViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listMachine.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listMachineTableViewCell", for: indexPath) as! ListMachineTableViewCell
        
        
        
        cell.setUI(title: listMachine[indexPath.row].name ?? "")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let id = listMachine[indexPath.row].id{
            
            self.selectedMachineId = id
        }
        
            self.performSegue(withIdentifier: "GoToDetail", sender: self)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        // Delete Action action
        let delete = UIContextualAction(style: .normal,
                                         title: "Delete") { [weak self] (action, view, completionHandler) in

//            if let deletedRemindner = self?.reminders[indexPath.row]{
//                //update data status
//                PersistanceManager.shared.deleteReminder(reminder: deletedRemindner)
//            }

            print("DELETE DATA UHUY")
//            self?.fetchDataReminder()
//
//            self?.timerReminderTableView.reloadData()
            completionHandler(true)
        }
        
        delete.image = UIImage(systemName: "trash")?.withTintColor(.white)
        delete.backgroundColor = .red
        
        
        let configuration = UISwipeActionsConfiguration(actions: [delete])

        return configuration
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let edit = UIContextualAction(style: .normal,
                                         title: "Edit") { [weak self] (action, view, completionHandler) in

//            if let deletedRemindner = self?.reminders[indexPath.row]{
//                //update data status
//                PersistanceManager.shared.deleteReminder(reminder: deletedRemindner)
//            }

            print("Edit DATA UHUY")
//            self?.fetchDataReminder()
//
//            self?.timerReminderTableView.reloadData()
            completionHandler(true)
        }
        
        edit.image = UIImage(systemName: "pencil")?.withTintColor(.white)
        edit.backgroundColor = .green
        
        
        
        let configuration = UISwipeActionsConfiguration(actions: [edit])

        return configuration
    }
    
    
}

extension ListMachineViewController{
    private func PresentActionSheetMore(){
        
        let actionSheet = UIAlertController(title: "Select Action", message: "", preferredStyle: .actionSheet)
        actionSheet.view.tintColor = UIColor(named: "ActionSheetCustomColor")
        
        //button 1
        let addDatamachine = UIAlertAction(title: "Add Data Machine", style: .default){ (action: UIAlertAction) in
            
            self.performSegue(withIdentifier: "GoToAddDataPage", sender: self)
        }
        
        //button camera
        let cameraAction = UIAlertAction(title: "Scan QR Code", style: .default){ (action: UIAlertAction) in
            self.performSegue(withIdentifier: "GoToQRScanner", sender: self)
        }
        
        //button 3
        let cancel = UIAlertAction(title: "Cancel", style:.cancel, handler: nil)
        
        actionSheet.addAction(addDatamachine)
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    private func PresentActionSheetSort(){
        
        let actionSheet = UIAlertController(title: "Sort By", message: "", preferredStyle: .actionSheet)
        actionSheet.view.tintColor = UIColor(named: "ActionSheetCustomColor")
        
        //button 1
        let sortByMachineName = UIAlertAction(title: "Machine Name", style: .default){ (action: UIAlertAction) in
        }
        
        //button camera
        let sortByMachineType = UIAlertAction(title: "Machine Type", style: .default){ (action: UIAlertAction) in
        }
        
        //button 3
        let cancel = UIAlertAction(title: "Cancel", style:.cancel, handler: nil)
        
        actionSheet.addAction(sortByMachineName)
        actionSheet.addAction(sortByMachineType)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true, completion: nil)
    }
}
