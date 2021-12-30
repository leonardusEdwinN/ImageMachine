//
//  DetailMachineImageViewController.swift
//  ImageMachine
//
//  Created by Edwin Niwarlangga on 30/12/21.
//

import Foundation
import UIKit

class DetailMachineImageViewController : UIViewController{
    @IBOutlet weak var navigationView: UIView!
    @IBAction func closeButtonPressed(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var imageFullScreen: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
