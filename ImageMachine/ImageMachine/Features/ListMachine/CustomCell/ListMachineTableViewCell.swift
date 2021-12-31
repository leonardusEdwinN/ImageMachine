//
//  ListMachineTableViewCell.swift
//  ImageMachine
//
//  Created by Edwin Niwarlangga on 27/12/21.
//

import UIKit

class ListMachineTableViewCell: UITableViewCell {

    @IBOutlet weak var viewRounded: UIView!
    @IBOutlet weak var machineNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        machineNameLabel.text = ""
        viewRounded.backgroundColor = UIColor.white
        viewRounded.layer.cornerRadius = 15.0
        viewRounded.layer.shadowColor = UIColor.gray.cgColor
        viewRounded.layer.shadowOffset = CGSize(width: 1, height: 1)
        viewRounded.layer.shadowRadius = 1
        viewRounded.layer.shadowOpacity = 5
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUI(title : String, type: String){
        machineNameLabel.text = "\(title) | \(type) "
    }
    
}
