//
//  MachineImageThumbnailTableViewCell.swift
//  ImageMachine
//
//  Created by Edwin Niwarlangga on 28/12/21.
//

import UIKit

class MachineImageThumbnailTableViewCell: UITableViewCell {

    @IBOutlet weak var machineImageDeleteButtonPressed: UIButton!
    @IBOutlet weak var machineImageDeleteButton: UIButton!
    @IBOutlet weak var machineImageName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        machineImageDeleteButton.setTitle("", for: .normal)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
