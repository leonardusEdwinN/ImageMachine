//
//  ImageThumbnailCollectionViewCell.swift
//  ImageMachine
//
//  Created by Edwin Niwarlangga on 30/12/21.
//

import UIKit

class ImageThumbnailCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var viewImageThumbnail: UIView!
    @IBOutlet weak var machineImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        machineImage.image = UIImage(systemName: "square.and.arrow.up.circle.fill")
        setUI()
        
        
        // Initialization code
    }
    
    func setUI(){
        viewImageThumbnail.layer.cornerRadius = 15
        viewImageThumbnail.layer.borderWidth = 2
        viewImageThumbnail.layer.borderColor = UIColor.black.cgColor
        
        machineImage.layer.cornerRadius = 15
    }
    
    func setImage(imageStr: String){
        guard let decodedData = Data(base64Encoded: imageStr, options: .ignoreUnknownCharacters) else { return  }
        let decodedimage: UIImage = UIImage(data: decodedData) ?? UIImage(systemName: "camera")!
        
        machineImage.contentMode = .scaleToFill
        machineImage.image = decodedimage
    }
    
}
