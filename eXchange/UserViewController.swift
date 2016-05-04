//
//  UserViewController.swift
//  eXchange
//
//  Created by Emanuel Castaneda on 5/3/16.
//  Copyright © 2016 Emanuel Castaneda. All rights reserved.
//

import UIKit
import RSKImageCropper
import Firebase

class UserViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, RSKImageCropViewControllerDelegate {

    @IBOutlet var eXchangeBanner: UIImageView!
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var clubLabel: UILabel!
    @IBOutlet var netIDlabel: UILabel!
    
    @IBOutlet var logOutButton: UIButton!
    @IBOutlet var changePicButton: UIButton!
    var dataBaseRoot = Firebase(url:"https://princeton-exchange.firebaseIO.com")
    var userNetID: String = ""
    
    override func viewDidLoad() {
        eXchangeBanner.image = UIImage(named:"exchange_banner")!
        self.navigationController?.navigationBarHidden = true
        
        
        changePicButton.layer.cornerRadius = 5
        changePicButton.backgroundColor = UIColor.blackColor()
        logOutButton.layer.cornerRadius = 5
        logOutButton.backgroundColor = UIColor.redColor()
        
        let tbc = self.tabBarController as! eXchangeTabBarController
        self.userNetID = tbc.userNetID;
        nameLabel.text = tbc.currentUser.name
        clubLabel.text = "Club: \(tbc.currentUser.club)"
        netIDlabel.text = "NetID: \(tbc.userNetID)"
        if (tbc.currentUser.image != "") {
            let decodedData = NSData(base64EncodedString: tbc.currentUser.image, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
            userImageView.image = UIImage(data: decodedData!)!
        } else {
            userImageView.image = UIImage(named: "princetonTiger.png")
        }
    }
    @IBAction func changeUserImage(sender: AnyObject) {
        let photoPicker = UIImagePickerController()
        photoPicker.delegate = self
        photoPicker.sourceType = .PhotoLibrary
        
        self.presentViewController(photoPicker, animated: true, completion: nil)
    }
    
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
        let imageData: NSData = UIImageJPEGRepresentation(croppedImage, 0.3)!
        let imageString = imageData.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
        let studentsRoot = dataBaseRoot.childByAppendingPath("students")
        let student = studentsRoot.childByAppendingPath(userNetID)
        let imageFolder = ["image" : imageString]
        student.updateChildValues(imageFolder)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
