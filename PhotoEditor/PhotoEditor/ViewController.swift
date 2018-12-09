//
//  ViewController.swift
//  PhotoEditor
//
//  Created by Mangesh Tekale on 08/12/18.
//  Copyright © 2018 Mangesh. All rights reserved.
//

import UIKit

extension UIView {
    
    /**
     Rotate a view by specified degrees
     
     - parameter angle: angle in degrees
     */
    func rotate(angle: CGFloat) {
        let radians = angle / 180.0 * CGFloat.pi
        let currentTrans = self.transform
        let newTrans = currentTrans.rotated(by: radians)
        self.transform = newTrans
    }
    
    func image(with view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        defer { UIGraphicsEndImageContext() }
        if let context = UIGraphicsGetCurrentContext() {
            view.layer.render(in: context)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            return image
        }
        return nil
    }

}

class ViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var viewForDrawing: UIView!
    var lblText: UILabel!
    var imgView: UIImageView!
    var lastRotation   = CGFloat()

    var rotateGesture  = UIRotationGestureRecognizer()
    var picnhGesture  = UIPinchGestureRecognizer()
    var panGesture  = UIPanGestureRecognizer()
    
    var imgViewRotateGesture  = UIRotationGestureRecognizer()
    var imgViewPicnhGesture  = UIPinchGestureRecognizer()
    var imgViewPanGesture  = UIPanGestureRecognizer()

    var selectedImage: UIImage?
    var selectedText: String?
    
    static func storyboardInstance() -> ViewController {
        let storyboard = UIStoryboard(name: "ViewController", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ViewController")
        return vc as! ViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        lblText = UILabel(frame: CGRect(x: (UIScreen.main.bounds.width / 2) - 100 , y: (UIScreen.main.bounds.height / 2) - 40, width: 200, height: 80))
        imgView = UIImageView(frame: CGRect(x: (UIScreen.main.bounds.width / 2) - 100 , y: (UIScreen.main.bounds.height / 2) - 100, width: 200, height: 200))
        imgView.image = selectedImage
        lblText.text = selectedText
        
        self.viewForDrawing.addSubview(lblText)
        self.viewForDrawing.addSubview(imgView)

        
        rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(ViewController.rotatedView(_:)))
        lblText.addGestureRecognizer(rotateGesture)
        lblText.isUserInteractionEnabled = true
        lblText.isMultipleTouchEnabled = true
        
        imgViewRotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(ViewController.rotatedView(_:)))
        imgView.addGestureRecognizer(imgViewRotateGesture)
        imgView.isUserInteractionEnabled = true
        imgView.isMultipleTouchEnabled = true
        

        picnhGesture = UIPinchGestureRecognizer(target: self, action: #selector(ViewController.pinchedView(sender:) ))
        lblText.isUserInteractionEnabled = true
        lblText.addGestureRecognizer(picnhGesture)
        
        imgViewPicnhGesture = UIPinchGestureRecognizer(target: self, action: #selector(ViewController.pinchedView(sender:)))
        imgView.isUserInteractionEnabled = true
        imgView.addGestureRecognizer(imgViewPicnhGesture)

        panGesture = UIPanGestureRecognizer(target: self, action: #selector(ViewController.draggedView(_:)))
        lblText.isUserInteractionEnabled = true
        lblText.addGestureRecognizer(panGesture)
        
        imgViewPanGesture = UIPanGestureRecognizer(target: self, action: #selector(ViewController.draggedView(_:)))
        imgView.addGestureRecognizer(imgViewPanGesture)

        
        

    }
    
    @objc func draggedView(_ sender:UIPanGestureRecognizer){
        self.viewForDrawing.bringSubview(toFront: sender.view!)
        let translation = sender.translation(in: self.viewForDrawing)
        sender.view?.center = CGPoint(x: (sender.view?.center.x)! + translation.x, y: (sender.view?.center.y)! + translation.y)
        sender.setTranslation(CGPoint.zero, in: self.viewForDrawing)
    }

    
    @objc func pinchedView(sender:UIPinchGestureRecognizer){
        self.viewForDrawing.bringSubview(toFront: sender.view!)
        sender.view?.transform = (sender.view?.transform)!.scaledBy(x: sender.scale, y: sender.scale)
        sender.scale = 1.0
    }

    
    @objc func rotatedView(_ sender : UIRotationGestureRecognizer){
        var lastRotation = CGFloat()
        self.viewForDrawing.bringSubview(toFront: sender.view!)
        if(sender.state == UIGestureRecognizerState.ended){
            lastRotation = 0.0;
        }
        print("Rotation \(sender.rotation)")
        let rotation = 0.0 - (lastRotation - sender.rotation)
        sender.view?.rotate(angle: rotation)
    }

    
}

