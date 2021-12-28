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
        
    }
    @IBAction func moreButtonPressed(_ sender: Any) {
        PresentActionSheet()
    }
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var listMachinveTableView: UITableView!
    @IBOutlet weak var navigationView: UIView!
    
    
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
        }
    }
    
}

extension ListMachineViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listMachineTableViewCell", for: indexPath) as! ListMachineTableViewCell
        
        return cell
    }
    
    
}

extension ListMachineViewController{
    private func PresentActionSheet(){
        
        let actionSheet = UIAlertController(title: "Select Action", message: "Choose", preferredStyle: .actionSheet)
        actionSheet.view.tintColor = UIColor(named: "ActionSheetCustomColor")
        
        //button 1
        let addDatamachine = UIAlertAction(title: "Add Data Machine", style: .default){ (action: UIAlertAction) in
            
            self.performSegue(withIdentifier: "GoToAddDataPage", sender: self)
//            if UIImagePickerController.isSourceTypeAvailable(.camera){
//                self.imagePickerControler.sourceType = .photoLibrary
//                self.imagePickerControler.delegate = self
//                self.imagePickerControler.allowsEditing = true
//                self.present(self.imagePickerControler, animated: true, completion: nil)
//                self.usingCamera = false
//            }else{
//                fatalError("Photo library not avaliable")
//            }
        }
        
        //button camera
        let cameraAction = UIAlertAction(title: "Camera", style: .default){ (action: UIAlertAction) in
            self.performSegue(withIdentifier: "GoToQRScanner", sender: self)
//            if UIImagePickerController.isSourceTypeAvailable(.camera){
//                self.imagePickerControler.sourceType = .camera
//                self.imagePickerControler.delegate = self
//                self.imagePickerControler.allowsEditing = true
//                self.present(self.imagePickerControler, animated: true, completion: nil)
//            }
//            else{
////                Util.displayAlert(title: "Camera Not Available", message: "")
//            }
            
        }
        
        //button 3
        let cancel = UIAlertAction(title: "Cancel", style:.cancel, handler: nil)
        
        actionSheet.addAction(addDatamachine)
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true, completion: nil)
    }
}
