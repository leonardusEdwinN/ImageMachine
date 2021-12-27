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
    
    @IBAction func sortButtonPressed(_ sender: Any) {
        PresentActionSheet()
    }
    @IBOutlet weak var sortButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
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
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                self.imagePickerControler.sourceType = .camera
                self.imagePickerControler.delegate = self
                self.imagePickerControler.allowsEditing = true
                self.present(self.imagePickerControler, animated: true, completion: nil)
            }
            else{
//                Util.displayAlert(title: "Camera Not Available", message: "")
            }
            
        }
        
        //button 3
        let cancel = UIAlertAction(title: "Cancel", style:.cancel, handler: nil)
        
        actionSheet.addAction(addDatamachine)
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true, completion: nil)
    }
}
