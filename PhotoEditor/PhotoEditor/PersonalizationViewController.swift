//
//  PersonalizationViewController.swift
//  PhotoEditor
//
//  Created by Mangesh Tekale on 09/12/18.
//  Copyright © 2018 Mangesh. All rights reserved.
//

import UIKit

class PersonalizationViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var imgViewOriginal: UIImageView!
    @IBOutlet weak var imgViewEdited: UIImageView!
    @IBOutlet weak var btnUploadPhotos: UIButton!
    @IBOutlet weak var btnAddText: UIButton!
    @IBOutlet weak var lblRemainingPhotos: UILabel!
    @IBOutlet weak var lblRemainingText: UILabel!
    @IBOutlet weak var lblStaticCommentBox: UILabel!
    @IBOutlet weak var scrollViewImageEditing: UIScrollView!
    fileprivate var imagePicker = ImagePicker()
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imagePicker.delegate = self

    }

    fileprivate func presentImagePicker(sourceType: UIImagePickerControllerSourceType) {
        imagePicker.controller.sourceType = sourceType
        DispatchQueue.main.async {
            self.present(self.imagePicker.controller, animated: true, completion: nil)
        }
    }
    
    @IBAction func presentPickerAndRequestPermission(_ sender: UIButton) {
        presentImagePicker(sourceType: .savedPhotosAlbum)
    }
    
    @IBAction func requestPermissionAndPresentPicker(_ sender: UIButton) {
        imagePicker.galleryAsscessRequest()
    }
    
    @IBAction func cameraButtonTapped(_ sender: Any) {
        imagePicker.cameraAsscessRequest()
    }


    func textViewDidBeginEditing(_ textView: UITextView) {
        scrollViewImageEditing.contentOffset = CGPoint(x: 0, y: 340)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        scrollViewImageEditing.contentOffset = CGPoint(x: 0, y: 0)

    }
}

extension PersonalizationViewController: ImagePickerDelegate {
    
    func imagePickerDelegate(didSelect image: UIImage, imageName:String, delegatedForm: ImagePicker) {
// Selected Image
        let vc = ViewController.storyboardInstance()
        vc.selectedImage = image
        self.present(vc, animated: true) {
            self.imagePicker.dismiss()

        }
    }
    
    func imagePickerDelegate(didCancel delegatedForm: ImagePicker) {
        imagePicker.dismiss()
    }
    
    func imagePickerDelegate(canUseGallery accessIsAllowed: Bool, delegatedForm: ImagePicker) {
        if accessIsAllowed {
            presentImagePicker(sourceType: .photoLibrary)
        }
    }
    
    func imagePickerDelegate(canUseCamera accessIsAllowed: Bool, delegatedForm: ImagePicker) {
        if accessIsAllowed {
            // works only on real device (crash on simulator)
            presentImagePicker(sourceType: .camera)
        }
    }
}

