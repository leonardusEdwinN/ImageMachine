//
//  ListMachineTableViewCell.swift
//  ImageMachine
//
//  Created by Edwin Niwarlangga on 27/12/21.
//

import UIKit

class ListMachineTableViewCell: UITableViewCell {

    @IBOutlet weak var machineNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        machineNameLabel.text = ""
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUI(title : String){
        machineNameLabel.text = title
    }
    
}
