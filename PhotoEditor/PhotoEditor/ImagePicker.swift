//
//  ImagePicker.swift
//  PhotoEditor
//
//  Created by Mangesh Tekale on 09/12/18.
//  Copyright © 2018 Mangesh. All rights reserved.
//

import Foundation
import AVFoundation
import Photos
import UIKit

protocol ImagePickerDelegate {
    func imagePickerDelegate(canUseCamera accessIsAllowed:Bool, delegatedForm: ImagePicker)
    func imagePickerDelegate(canUseGallery accessIsAllowed:Bool, delegatedForm: ImagePicker)
    func imagePickerDelegate(didSelect image: UIImage, imageName:String, delegatedForm: ImagePicker)
    func imagePickerDelegate(didCancel delegatedForm: ImagePicker)
}

extension ImagePickerDelegate {
    func imagePickerDelegate(canUseCamera accessIsAllowed:Bool, delegatedForm: ImagePicker) {}
    func imagePickerDelegate(canUseGallery accessIsAllowed:Bool, delegatedForm: ImagePicker) {}
}

class ImagePicker: NSObject {
    
    var controller = UIImagePickerController()
    var selectedImage: UIImage?
    var delegate: ImagePickerDelegate? = nil
    
    override init() {
        super.init()
        controller.sourceType = .photoLibrary
        controller.delegate = self
    }
    
    func dismiss() {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension ImagePicker {
    
    func cameraAsscessRequest() {
        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) ==  AVAuthorizationStatus.authorized {
            delegate?.imagePickerDelegate(canUseCamera: true, delegatedForm: self)
        } else {
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { granted -> Void in
                self.delegate?.imagePickerDelegate(canUseCamera: granted, delegatedForm: self)
            }
        }
    }
    
    func galleryAsscessRequest() {
        PHPhotoLibrary.requestAuthorization { [weak self] result in
            if let _self = self {
                var access = false
                if result == .authorized {
                    access = true
                }
                _self.delegate?.imagePickerDelegate(canUseGallery: access, delegatedForm: _self)
            }
        }
    }
}

extension ImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let imageName = "img_\(Date().timeIntervalSince1970)"
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            delegate?.imagePickerDelegate(didSelect: image, imageName: imageName,  delegatedForm: self)
        }
        else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            delegate?.imagePickerDelegate(didSelect: image, imageName: imageName, delegatedForm: self)
        } else{
            print("Something went wrong")
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        delegate?.imagePickerDelegate(didCancel: self)
    }
    
}
