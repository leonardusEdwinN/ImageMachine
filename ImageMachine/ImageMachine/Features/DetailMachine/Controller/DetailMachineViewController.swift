//
//  DetailMachineViewController.swift
//  ImageMachine
//
//  Created by Edwin Niwarlangga on 28/12/21.
//

import Foundation
import UIKit
import BSImagePicker
import Photos

class DetailMachineViewController : UIViewController{
    
    // MARK: Variable Pass
    var machineVM : MachineViewModel?
    
    // MARK: Variable
    var delegate : ReloadDataListMachineDelegate?
    let imagePicker = ImagePickerController()
    var selectedImageFullScreen : String = ""
    var listImageThumbnailVM = ListImageThumbnailViewModel()
    

    // MARK: UI Component Navigation
    @IBOutlet weak var navigationView: UIView!
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titlePage: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBAction func editButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "GoToAddDataPage", sender: self)
        
    }
    
    @IBOutlet weak var trashButton: UIButton!
    @IBAction func trashButtonPressed(_ sender: Any) {
        DispatchQueue.main.async {
            LoadingScreen.sharedInstance.showIndicator()
        }
        
        machineVM?.deleteMachine(machine: machineVM!.item) {
            self.dismiss(animated: false) { [self] in
                DispatchQueue.main.async {
                    LoadingScreen.sharedInstance.hideIndicator()
                }
                delegate?.reloadDataAfterEditOrAdd()
            }
        }
       
    }
    
    // MARK: UI Component Machine Information
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
    
    // MARK: UI Component Machine Image Thumbnail
    @IBOutlet weak var emptyState: UIView!
    @IBOutlet weak var machineImageThumbnail: UILabel!
    
    @IBOutlet weak var viewImageThumbnail: UIView!
    
    @IBOutlet weak var imageThumbnailCollectionView: UICollectionView!
    
    @IBOutlet weak var addImage: UIButton!
    @IBAction func addImagePressed(_ sender: Any) {
        
        DispatchQueue.main.async {
            LoadingScreen.sharedInstance.showIndicator()
        }
        
        presentImagePicker(imagePicker, select: { (asset) in
            // User selected an asset. Do something with it. Perhaps begin processing/upload?
        }, deselect: { (asset) in
            // User deselected an asset. Cancel whatever you did when asset was selected.
        }, cancel: { (assets) in
            // User canceled selection.
        
        }, finish: { (assets) in
            // User finished selection assets.
            
            for asset in assets{
                let assetThumbnail = self.getAssetThumbnail(asset: asset)
                var imgStrBase64 : String = ""
                
                let imageData:Data = assetThumbnail.pngData()!
                imgStrBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
                
                //add machine image
                self.machineVM?.addMachineImage(machineData: self.machineVM!.item, imgStr: imgStrBase64) {
                    self.getImageThumbnail()
                }
                
            }
            
            
            DispatchQueue.main.async {
                LoadingScreen.sharedInstance.hideIndicator()
            }
            
            
        })
    }
    
    func checkState(){
        if(listImageThumbnailVM.numberOfRows(0) == 0){
            emptyState.isHidden = false
            imageThumbnailCollectionView.isHidden = true
        }else{
            emptyState.isHidden = true
            imageThumbnailCollectionView.isHidden = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        setTitleButton()
        setUIShadow(viewShadow: self.navigationView)
        if(self.machineVM?.item != nil){
            setData()
        }
        getImageThumbnail()
    }
    
    func getImageThumbnail(){
        
        DispatchQueue.main.async {
            LoadingScreen.sharedInstance.showIndicator()
        }
        
        if let id = self.machineVM?.item.id {
            listImageThumbnailVM.getListThumbnailByMachine(byId: id) { ImageThumbnailViewModel in
                DispatchQueue.main.async {
                
                    LoadingScreen.sharedInstance.hideIndicator()
                    self.imageThumbnailCollectionView.reloadData()
                    self.checkState()
                }
            }
        }
        
        
        
    }
    
    func setData(){
        machineNameValueLabel.text = self.machineVM?.item.name
        machineTypeValueLabel.text = self.machineVM?.item.type
        machineIdValueLabel.text = self.machineVM?.item.id
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ssZ"
        dateFormatter.timeZone = TimeZone(abbreviation: "WIB")
        
        let strDate = dateFormatter.string(from: self.machineVM?.item.maintenanceDate ?? Date())
        machineMaintainDateValueLabel.text = strDate
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
        
        addImage.layer.cornerRadius = 15
    }
    func setRoundedCorner(viewCorner: UIView){
        viewCorner.layer.cornerRadius = 15
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToImageFullscreen"{
            if let destVC = segue.destination as? DetailMachineImageViewController {
                destVC.modalPresentationStyle = .fullScreen
                destVC.imageSelectedString = self.selectedImageFullScreen
            }
        }else  if segue.identifier == "GoToAddDataPage"{
            if let destVC = segue.destination as? AddEditDataViewController {
                destVC.machineViewModel = self.machineVM
                destVC.delegate = self
                destVC.isEdit = true
                
            }
        }
    }
    
    func getAssetThumbnail(asset: PHAsset) -> UIImage {
        let manager = PHImageManager.default()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.isSynchronous = true
        manager.requestImage(for: asset, targetSize: CGSize(width: 100.0, height: 100.0), contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
                thumbnail = result!
        })
        return thumbnail
    }
    
}


extension DetailMachineViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listImageThumbnailVM.numberOfRows(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageThumbnailCollectionViewCell", for: indexPath) as! ImageThumbnailCollectionViewCell
        
        let imageThumbnail = listImageThumbnailVM.modelAt(indexPath.row)
        cell.setImage(imageStr: imageThumbnail.item.image ?? "")
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedImageFullScreen = listImageThumbnailVM.modelAt(indexPath.row).item.image ?? ""
        self.performSegue(withIdentifier: "GoToImageFullscreen", sender: self)
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

extension DetailMachineViewController : ReloadDataListMachineDelegate{
    func reloadDataAfterEditOrAdd() {
        self.dismiss(animated: false, completion: {
                self.delegate?.reloadDataAfterEditOrAdd()
        })
    }
    
    
}
