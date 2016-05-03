//
//  UserViewController.swift
//  eXchange
//
//  Created by Emanuel Castaneda on 5/3/16.
//  Copyright © 2016 Emanuel Castaneda. All rights reserved.
//

import UIKit
import RSKImageCropper

class UserViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, RSKImageCropViewControllerDelegate {

    @IBOutlet var eXchangeBanner: UIImageView!
    @IBOutlet var userImageView: UIImageView!
    
    override func viewDidLoad() {
        eXchangeBanner.image = UIImage(named:"exchange_banner")!
        userImageView.image = UIImage(named: "princetonTiger")
        self.navigationController?.navigationBarHidden = true
    }
    @IBAction func changeUserImage(sender: AnyObject) {
        let photoPicker = UIImagePickerController()
        photoPicker.delegate = self
        photoPicker.sourceType = .PhotoLibrary
        
        self.presentViewController(photoPicker, animated: true, completion: nil)
    }
    
//    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!) {
//        userImageView.image = image
////        self.dismissViewControllerAnimated(true, completion: nil)
//        
//        self.dismissViewControllerAnimated(false, completion: { () -> Void in
//            
//            var imageCropVC : RSKImageCropViewController!
//            
//            imageCropVC = RSKImageCropViewController(image: image, cropMode: RSKImageCropMode.Circle)
//            
//            imageCropVC.delegate = self
//            
//            self.navigationController?.pushViewController(imageCropVC, animated: true)
//            
//        })
//    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image : UIImage = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
        
        picker.dismissViewControllerAnimated(false, completion: { () -> Void in
            
            var imageCropVC : RSKImageCropViewController!
            
            imageCropVC = RSKImageCropViewController(image: image, cropMode: RSKImageCropMode.Circle)
            
            imageCropVC.delegate = self
            self.navigationController?.pushViewController(imageCropVC, animated: true)
        })
    }
    
    func imageCropViewControllerDidCancelCrop(controller: RSKImageCropViewController) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func imageCropViewController(controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect) {
        userImageView.image = croppedImage
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
