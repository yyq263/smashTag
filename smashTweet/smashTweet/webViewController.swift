//
//  webViewController.swift
//  smashTweet
//
//  Created by Yiqin Yao on 9/4/16.
//  Copyright © 2016 Yiqin Yao. All rights reserved.
//

import UIKit

class webViewController: UIViewController {
    var url: String? {
        didSet{ UIApplication.sharedApplication().openURL(NSURL(string: url!)!) }
    }
}
