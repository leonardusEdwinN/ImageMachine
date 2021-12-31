//
//  DetailMachineImageViewController.swift
//  ImageMachine
//
//  Created by Edwin Niwarlangga on 30/12/21.
//

import Foundation
import UIKit

class DetailMachineImageViewController : UIViewController{
    // MARK: Variable
    var imageSelectedString : String = ""
    
    @IBOutlet weak var navigationView: UIView!
    @IBAction func closeButtonPressed(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var imageFullScreen: UIImageView!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let decodedData = Data(base64Encoded: imageSelectedString, options: .ignoreUnknownCharacters) else { return  }
        let decodedimage: UIImage = UIImage(data: decodedData) ?? UIImage(systemName: "camera")!
        
        imageFullScreen.image = decodedimage
        imageFullScreen.contentMode = .scaleAspectFit
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
    }
    
}
