//
//  TweetTableViewCell.swift
//  smashTweet
//
//  Created by Yiqin Yao on 8/13/16.
//  Copyright © 2016 Yiqin Yao. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewCell: UITableViewCell {

    
    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    var tweet: Twitter.Tweet? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        // reset any existing tweet information
        tweetTextLabel?.attributedText = nil
        tweetScreenNameLabel?.text = nil
        tweetProfileImageView?.image = nil
        tweetCreatedLabel?.text = nil
        
        // load information from tweet
        if let tweet = self.tweet {
            tweetTextLabel?.text = tweet.text
            if tweetTextLabel?.text != nil {
                for _ in tweet.media {
                    tweetTextLabel.text! += " 📷"
                }
            }
        
        
        tweetScreenNameLabel?.text = "\(tweet.user)" // tweet.user.description
        
        if let profileImageURL = tweet.user.profileImageURL {
            if let imageData = NSData(contentsOfURL: profileImageURL) {
                tweetProfileImageView?.image = UIImage(data: imageData)
            }
        }
        
        let formatter = NSDateFormatter()
        if NSDate().timeIntervalSinceDate(tweet.created) > 24 * 60 * 60 {
            formatter.dateStyle = NSDateFormatterStyle.ShortStyle
        } else {
            formatter.timeStyle = NSDateFormatterStyle.ShortStyle
        }
        tweetCreatedLabel?.text = formatter.stringFromDate(tweet.created)
    }
  }
}



















