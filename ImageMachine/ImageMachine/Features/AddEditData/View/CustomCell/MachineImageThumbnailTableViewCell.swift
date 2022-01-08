//
//  MachineImageThumbnailTableViewCell.swift
//  ImageMachine
//
//  Created by Edwin Niwarlangga on 28/12/21.
//

import UIKit

class MachineImageThumbnailTableViewCell: UITableViewCell {

    @IBOutlet weak var viewRounded: UIView!
    @IBOutlet weak var machineImageName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        viewRounded.backgroundColor = UIColor.white
        viewRounded.layer.cornerRadius = 15.0
        viewRounded.layer.shadowColor = UIColor.gray.cgColor
        viewRounded.layer.shadowOffset = CGSize(width: 1, height: 1)
        viewRounded.layer.shadowRadius = 1
        viewRounded.layer.shadowOpacity = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setImageName(title : String){
        machineImageName.text = title
    }
    
}
