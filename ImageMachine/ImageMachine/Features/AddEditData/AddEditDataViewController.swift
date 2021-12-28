//
//  AddEditDataViewController.swift
//  ImageMachine
//
//  Created by Edwin Niwarlangga on 27/12/21.
//

import Foundation
import UIKit
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
    
    @IBOutlet weak var addMachineImageButton: UIButton!
    @IBAction func addMachineImageButtonPressed(_ sender: Any) {
        print("ADD DATA")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
    }
    
    func registerCell(){
        
        machineImageThumbnailTableView.register(UINib.init(nibName: "MachineImageThumbnailTableViewCell", bundle: nil), forCellReuseIdentifier: "machineImageThumbnailTableViewCell")
        
        machineImageThumbnailTableView.delegate = self
        machineImageThumbnailTableView.dataSource = self
        
    }
}

extension AddEditDataViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = tableView.dequeueReusableCell(withIdentifier: "machineImageThumbnailTableViewCell", for: indexPath) as! MachineImageThumbnailTableViewCell
        
        return row
    }
    
    
}


