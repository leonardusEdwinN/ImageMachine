//
//  DetailMachineViewController.swift
//  ImageMachine
//
//  Created by Edwin Niwarlangga on 28/12/21.
//

import Foundation
import UIKit

class DetailMachineViewController : UIViewController{
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var editButton: UIButton!
    @IBAction func editButtonPressed(_ sender: Any) {
    }
    
    @IBOutlet weak var trashButton: UIButton!
    @IBAction func trashButtonPressed(_ sender: Any) {
    }
    @IBOutlet weak var titlePage: UILabel!
    
    @IBOutlet weak var machineInformationLabel: UILabel!
    @IBOutlet weak var viewInformation: UIView!
    
    @IBOutlet weak var machineIdLabel: UILabel!
    @IBOutlet weak var machineIdValueLabel: UILabel!
    
    @IBOutlet weak var machineNameLabel: UILabel!
    @IBOutlet weak var machineNameValueLabel: UILabel!
    
    @IBOutlet weak var machineTypeLabel: UILabel!
    @IBOutlet weak var machineTypeValueLabel: UILabel!
    
    @IBOutlet weak var machineMaintainDateLabel: UILabel!
    @IBOutlet weak var machineMaintainDateValueLabel: UILabel!
    
    @IBOutlet weak var machineImageThumbnail: UILabel!
    
    @IBOutlet weak var viewImageThumbnail: UIView!
    
    @IBOutlet weak var imageThumbnailCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        setTitleButton()
        setUIShadow(viewShadow: self.navigationView)
        setUIShadow(viewShadow: self.viewInformation)
        setRoundedCorner(viewCorner: self.viewInformation)
    }
    
    func registerCell(){
        imageThumbnailCollectionView.register(UINib.init(nibName: "ImageThumbnailCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "imageThumbnailCollectionViewCell")
        
        imageThumbnailCollectionView.delegate = self
        imageThumbnailCollectionView.dataSource = self
    }
    
    
    func setTitleButton(){
        editButton.setTitle("", for: .normal)
        trashButton.setTitle("", for: .normal)
    }
    
    func setUIShadow(viewShadow: UIView){
        viewShadow.backgroundColor = UIColor.white
        viewShadow.layer.shadowColor = UIColor.gray.cgColor
        viewShadow.layer.shadowOffset = CGSize(width: 1, height: 1)
        viewShadow.layer.shadowRadius = 1
        viewShadow.layer.shadowOpacity = 5
    }
    func setRoundedCorner(viewCorner: UIView){
        viewCorner.layer.cornerRadius = 15
    }
}


extension DetailMachineViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageThumbnailCollectionViewCell", for: indexPath) as! ImageThumbnailCollectionViewCell
        
        return cell
    }
    
    
}

extension DetailMachineViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var widthCell : CGSize = CGSize(width: 100, height: 100)
        
        if collectionView == self.imageThumbnailCollectionView{
            let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
            layout.minimumInteritemSpacing = 10
            layout.minimumLineSpacing = 10
            layout.invalidateLayout()
            // Set your item size here
            widthCell =  CGSize(width: (collectionView.frame.width - 20) / 3 , height: 100) // Set your item size here
        }else{
            widthCell =  CGSize(width: 100, height:100)
        }
        
        return widthCell
    }
}
