//
//  tweetImageViewCell.swift
//  
//
//  Created by Yiqin Yao on 8/30/16.
//
//

import UIKit

class tweetImageViewCell: UITableViewCell {

    // This cell displays an image view only
    
    @IBOutlet weak var tweetImage: UIImageView!
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    
    var imageURL: NSURL? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        tweetImage.image = nil
        if let url = imageURL {
            loadingSpinner?.startAnimating()
            let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
            dispatch_async(dispatch_get_global_queue(qos, 0)) {
                let imageData = NSData(contentsOfURL: url)
                dispatch_async(dispatch_get_main_queue()) {
                    if url == self.imageURL {
                        if imageData != nil {
                            self.tweetImage.image = UIImage(data: imageData!)
                        } else {
                            self.tweetImage.image = nil
                        }
                        self.loadingSpinner?.stopAnimating()
                    }
                }
            }
        }
    }
    
}
