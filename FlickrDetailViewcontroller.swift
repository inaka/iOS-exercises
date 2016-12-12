//
//  DetailViewcontrollerViewController.swift
//  FlickrSearch
//
//  Created by Oscar Otero on 12/5/16.
//

import UIKit

class FlickrDetailViewcontroller: UIViewController, UINavigationControllerDelegate, UIScrollViewDelegate  {
    
    var selectedImage : UIImage?
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var ecroll:UIScrollView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        ecroll.translatesAutoresizingMaskIntoConstraints  = false;
        imageView.translatesAutoresizingMaskIntoConstraints = false;
        
    }
    
    func setPhoto(image:UIImage) -> Void {
        imageView.fadeOut()
        imageView.image = image
        imageView.fadeIn()
        ecroll.zoomScale = 1.0 ;
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    @IBAction func scaleImage(sender: UIPinchGestureRecognizer) {
        self.imageView.transform = self.imageView.transform.scaledBy(x: sender.scale, y: sender.scale)
        sender.scale = 1
    }
    
    internal func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    override func viewDidDisappear(_ animated: Bool) {
        selectedImage = nil
        imageView.image = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
