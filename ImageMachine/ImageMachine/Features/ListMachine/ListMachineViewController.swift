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
    @IBOutlet weak var emptyState: UIView!
    
    var listMachine : [MachineEntity] = []
    var selectedMachineId : String = ""
    var selectedMachine : MachineEntity!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getDataListMachine(sortedBy: "name")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        setUINavigation()
        setTitleButton()
        checkState()
//        whereIsMySQLite()
    }
    
    func checkState(){
        if(listMachine.count == 0){
            emptyState.isHidden = false
            listMachinveTableView.isHidden = true
        }else{
            emptyState.isHidden = true
            listMachinveTableView.isHidden = false
        }
    }
    
//    func whereIsMySQLite() {
//        let path = FileManager
//            .default
//            .urls(for: .applicationSupportDirectory, in: .userDomainMask)
//            .last?
//            .absoluteString
//            .replacingOccurrences(of: "file://", with: "")
//            .removingPercentEncoding
//
//        print(path ?? "Not found")
//    }
    
    func registerCell(){
        
        listMachinveTableView.register(UINib.init(nibName: "ListMachineTableViewCell", bundle: nil), forCellReuseIdentifier: "listMachineTableViewCell")
        
        listMachinveTableView.delegate = self
        listMachinveTableView.dataSource = self
    }
    
    func setTitleButton(){
        sortButton.setTitle("", for: .normal)
        moreButton.setTitle("", for: .normal)
    }
    
    func getDataListMachine(sortedBy : String){
        
        listMachine = PersistanceManager.shared.getListMachines(sortBy: sortedBy)
        DispatchQueue.main.async {
            self.listMachinveTableView.reloadData()
            self.checkState()
        }
    }
    
    func setUINavigation(){
        navigationView.backgroundColor = UIColor.white
        navigationView.layer.shadowColor = UIColor.gray.cgColor
        navigationView.layer.shadowOffset = CGSize(width: 1, height: 1)
        navigationView.layer.shadowRadius = 1
        navigationView.layer.shadowOpacity = 5
    }
    
    func setAscending(){
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToQRScanner"{
            if let destVC = segue.destination as? QRScannerViewController {

                destVC.modalPresentationStyle = .fullScreen
                destVC.delegate = self
            }
        }else if segue.identifier == "GoToDetail"{
            if let destVC = segue.destination as? DetailMachineViewController {
                destVC.selectedIdMachine = self.selectedMachineId
                destVC.machineDetail = self.selectedMachine
                destVC.delegate = self
                
            }
        }else if segue.identifier == "GoToAddDataPage"{
            if let destVC = segue.destination as? AddEditDataViewController {
                destVC.machineData = self.selectedMachine
                destVC.delegate = self
                
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
        
        
        
        cell.setUI(title: listMachine[indexPath.row].name ?? "", type: listMachine[indexPath.row].type ?? "")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let id = listMachine[indexPath.row].id{
            
            self.selectedMachineId = id
            self.selectedMachine = listMachine[indexPath.row]
        }
        
            self.performSegue(withIdentifier: "GoToDetail", sender: self)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        // Delete Action action
        let delete = UIContextualAction(style: .normal,
                                         title: "Delete") { [weak self] (action, view, completionHandler) in

            if let deletedMachine = self?.listMachine[indexPath.row]{
                //update data status
                PersistanceManager.shared.deleteMachine(machine: deletedMachine)
            }

            DispatchQueue.main.async {
                self?.getDataListMachine(sortedBy: "name")
            }
            completionHandler(true)
        }
        
        delete.image = UIImage(systemName: "trash")?.withTintColor(.white)
        delete.backgroundColor = UIColor(named: "DeleteColor")
        
        
        let configuration = UISwipeActionsConfiguration(actions: [delete])

        return configuration
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let edit = UIContextualAction(style: .normal,
                                         title: "Edit") { [weak self] (action, view, completionHandler) in
            
            self?.selectedMachine = self?.listMachine[indexPath.row]
            self?.performSegue(withIdentifier: "GoToAddDataPage", sender: self)
            
            completionHandler(true)
        }
        
        edit.image = UIImage(systemName: "pencil")?.withTintColor(.white)
        edit.backgroundColor = UIColor(named: "EditColor")
        
        
        
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
            
            self.selectedMachine = nil
            
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
            self.getDataListMachine(sortedBy: "name")
        }
        
        //button camera
        let sortByMachineType = UIAlertAction(title: "Machine Type", style: .default){ (action: UIAlertAction) in
            self.getDataListMachine(sortedBy: "type")
        }
        
        //button 3
        let cancel = UIAlertAction(title: "Cancel", style:.cancel, handler: nil)
        
        actionSheet.addAction(sortByMachineName)
        actionSheet.addAction(sortByMachineType)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true, completion: nil)
    }
}

extension ListMachineViewController : ReloadDataListMachineDelegate{
    func reloadDataAfterEditOrAdd() {
        DispatchQueue.main.async {
            self.getDataListMachine(sortedBy: "name")
        }
    }
}
extension ListMachineViewController : GetDataAndGoToDetailDelegate{
    func getDataAndPerformSegueToDetail(qrNumber : String) {
        let selectedMachine = PersistanceManager.shared.getMachineByQRCode(qrCodeNumber: qrNumber)
        
        if let id = selectedMachine.id{
            
            self.selectedMachineId = id
            self.selectedMachine = selectedMachine
            
            self.performSegue(withIdentifier: "GoToDetail", sender: self)
        }
        
    }
}
