//
//  ImageThumbnailViewModel.swift
//  ImageMachine
//
//  Created by Edwin Niwarlangga on 07/01/22.
//

import Foundation

class ListImageThumbnailViewModel{
    private var listThumbnailResponse = [ImageThumbnailViewModel]()
    
    func numberOfRows(_ section: Int) -> Int {
        return listThumbnailResponse.count
    }
    
    func modelAt(_ index: Int) -> ImageThumbnailViewModel {
        return listThumbnailResponse[index]
    }
    
    func getListThumbnailByMachine(byId machineId: String, completion: @escaping ([ImageThumbnailViewModel]) -> Void) {
        
        if(listThumbnailResponse.count > 0){
            listThumbnailResponse = []
        }
        
        let dataGet = PersistanceManager.shared.getImageMachineThumbnailById(idMachine: machineId)
        if(dataGet.count == 0){
            completion(self.listThumbnailResponse)
        }else{
            for imageThumbnail in dataGet {
                self.listThumbnailResponse.append(ImageThumbnailViewModel(image: imageThumbnail))
            }
            
            completion(self.listThumbnailResponse)
        }
        
        
    }
    
    
    
}



class ImageThumbnailViewModel {

    let item: ImageEntity

    init(image: ImageEntity) {
        self.item = image
    }
    
    func deleteImage(image: ImageEntity, completion: @escaping () -> Void) {
        do {
            PersistanceManager.shared.deleteMachineImageThumbanail(image: image)
            completion()
        } catch let error as NSError  {
            print("Error When Deleting data Image Thumbnail \(error)")
        }
        
    }
}

