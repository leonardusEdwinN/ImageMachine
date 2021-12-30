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
        viewImageThumbnail.backgroundColor = UIColor.white
        viewImageThumbnail.layer.shadowColor = UIColor.gray.cgColor
        viewImageThumbnail.layer.shadowOffset = CGSize(width: 1, height: 1)
        viewImageThumbnail.layer.shadowRadius = 1
        viewImageThumbnail.layer.shadowOpacity = 5
        viewImageThumbnail.layer.cornerRadius = 15
    }
    
    func setImage(image: String){
        
    }

}
