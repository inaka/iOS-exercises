//
//  ActivityIndicator.swift
//  FlickrSearch
//
//  Created by Oscar Otero on 12/8/16.
//

import UIKit
import Foundation

class ActivityIndicatorView
{
    var view: UIView!
    
    var activityIndicator: UIActivityIndicatorView!
    
    var title: String!
    var titleLabel:UILabel!
    
    init(title: String, center: CGPoint, width: CGFloat = 200.0, height: CGFloat = 50.0)
    {
        self.title = title
        
        let x = center.x - width/2.0
        let y = center.y - height/2.0
        
        self.view = UIView(frame: CGRect(x: x, y: y, width: width, height: height))
        self.view.backgroundColor = UIColor.lightGray
        self.view.layer.cornerRadius = 10
        
        self.activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.activityIndicator.color = UIColor.black
        self.activityIndicator.hidesWhenStopped = false
        
        titleLabel = UILabel(frame: CGRect(x: 60, y: 0, width: 200, height: 50))
        titleLabel.text = title
        titleLabel.textColor = UIColor.black
        
        self.view.addSubview(self.activityIndicator)
        self.view.addSubview(titleLabel)
    }
    
    func getViewActivityIndicator() -> UIView
    {
        return self.view
    }
    
    func startAnimating(page:UInt8)
    {
        titleLabel.text = "Loading Page: \(page)"
        self.activityIndicator.startAnimating()
    }
    
    func stopAnimating()
    {
        self.activityIndicator.stopAnimating()
        self.view.removeFromSuperview()
    }
    //end
}
