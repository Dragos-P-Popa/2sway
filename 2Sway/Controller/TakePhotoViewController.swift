//
//  TakePhotoViewController.swift
//  progressBar2
//
//  Created by Joe Feest on 17/08/2021.
//

import UIKit
import Firebase
import FirebaseStorage
import MBProgressHUD

class TakePhotoViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var selectPhotoButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    
    private let db = Firestore.firestore()
    private let storage = Storage.storage().reference()
    var imagePicker = UIImagePickerController()
    
    // User can only press continue after they have taken a profile picture
    var canContinue: Bool = false
    
    // Will be set after photo is takenm
    var imageToDisplay: UIImage = UIImage(systemName: "person.fill")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        continueButton.alpha = K.unpressableAlpha
        continueButton.isEnabled = false
        if canContinue {
            configureAfterPhoto(photo: imageToDisplay)
        }
        selectPhotoButton.layer.cornerRadius = selectPhotoButton.frame.height/2
        continueButton.layer.cornerRadius = continueButton.frame.height/2
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotificationNew(notification:)), name: Notification.Name("NotificationProgress"), object: nil)
    }
    @objc func methodOfReceivedNotificationNew(notification: Notification) {
        UserDefaults.standard.set(true, forKey:K.udefalt.IsPhoto)
        let obj = self.storyboard?.instantiateViewController(withIdentifier:"RulesVC") as! RulesVC
        obj.isIntro = true
        self.navigationController?.pushViewController(obj, animated:true)
      //  performSegue(withIdentifier: K.Segues.toIntro, sender: self)
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationItem.hidesBackButton = true
    }
    
    @IBAction func takePhotoButton(_ sender: Any) {
        performSegue(withIdentifier: "toCustomCam", sender: self)
    }
    
    @IBAction func continueButton(_ sender: UIButton) {
        if canContinue {
            guard let profilePicData = profileImage.image?.jpegData(compressionQuality: 0.8) else {return}
            ActiveUser.activeUser.profilePhoto = profileImage.image
            DatabaseManager.shared.uploadImageData(data: profilePicData)
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
    }
    
    @IBAction func selectionButton() {
            
        ImagePickerManager().pickImage(self){ image in
            //let flippedImage = UIImage(cgImage: image.cgImage!, scale: image.scale, orientation: .leftMirrored)
            let imageWidth = image.size.width
            let imageHeight = image.size.height
            // How far down the original image to apply the crop to get a centred, square image
            let xOffset = (imageHeight - imageWidth) / 2.0
            let cropRect = CGRect(x: xOffset,
                                  y: 0,
                                  width: imageWidth,
                                  height: imageWidth).integral
            let croppedImage = image.cgImage!.cropping(to: cropRect)!
            let finalImage = UIImage(cgImage: croppedImage, scale: image.imageRendererFormat.scale, orientation: image.imageOrientation)
            self.imageToDisplay = finalImage
            self.configureAfterPhoto(photo: finalImage)
        }
    }
    
    func configureAfterPhoto(photo: UIImage) {
        canContinue = true
        continueButton.isEnabled = true
        profileImage.image = photo
        profileImage.alpha = 1
     //   takePhotoButton.setTitle("Take a photo", for: .normal)
        self.selectPhotoButton.setTitle("Replace photo", for:.normal)
        continueButton.alpha = 1.0
    }
}
