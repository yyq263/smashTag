//
//  DetailOfTweetsTableViewController.swift
//  smashTweet
//
//  Created by Yiqin Yao on 8/20/16.
//  Copyright © 2016 Yiqin Yao. All rights reserved.
//

import UIKit
import Twitter

class DetailOfTweetsTableViewController: UITableViewController
{
    
    // Data Source
    var sectionName = [String]()
    
    var screenName = [String]()
    
    var hashTags = [String]()
    
    var URLs = [String]()
    
    var imageURLs = [MediaItem]()
    
    var detailedTweetArray = [AnyObject]()
    
    var tweetItem: Twitter.Tweet? {
        didSet { updateUI() }
    }
    
    private func updateUI() {
        if tweetItem != nil {
            // Get image URL
            if !tweetItem!.media.isEmpty {
                for imageURL in tweetItem!.media {
                    imageURLs.append(imageURL)
                }
                detailedTweetArray.append(imageURLs)
                sectionName.append("Image")
            }
            // Get hashtags
            if !tweetItem!.hashtags.isEmpty {
                for hashtag in tweetItem!.hashtags {
                    hashTags.append(hashtag.keyword)
                }
                detailedTweetArray.append(hashTags)
                sectionName.append("Hashtag")
            }
            // Get urls
            if !tweetItem!.urls.isEmpty {
                for url in tweetItem!.urls {
                    URLs.append(url.keyword)
                }
                detailedTweetArray.append(URLs)
                sectionName.append("URL")
            }
            // Get screenName
            screenName.append("@" + tweetItem!.user.screenName)
            detailedTweetArray.append(screenName)
            sectionName.append("Screenname")
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView.estimatedRowHeight = tableView.rowHeight
        //tableView.rowHeight = UITableViewAutomaticDimension
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }

    // MARK: - Table view data source
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // return the number of sections
        return  detailedTweetArray.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the number of rows
        return detailedTweetArray[section].count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            // Configure the cell that displays text
            if let detailedTweet = detailedTweetArray[indexPath.section] as? [String] {
                let cell = tableView.dequeueReusableCellWithIdentifier("detailedTweets", forIndexPath: indexPath)
                if !detailedTweet.isEmpty {
                    cell.textLabel?.text = detailedTweet[indexPath.row]
                }
                return cell
            } else {
                // Configure the cell that displays images
                let mediaItemInTweet = detailedTweetArray[indexPath.section] as! [MediaItem]
                let cell = tableView.dequeueReusableCellWithIdentifier("imageCell", forIndexPath: indexPath) as! tweetImageViewCell
                if !mediaItemInTweet.isEmpty {
                    let url = mediaItemInTweet[indexPath.row].url
                    cell.imageURL = url
                }
            return cell
            }


    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if detailedTweetArray[indexPath.section] is [String] {
            return UITableViewAutomaticDimension
        }
        
        if let media = detailedTweetArray[indexPath.section][indexPath.row] as? MediaItem {
            return (tableView.frame.size.height / CGFloat(media.aspectRatio))
        }
        return UITableViewAutomaticDimension
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionName[section]
    }

    
    private struct Storyboard {
        static let SearchResultsIdentifier    = "SearchResultsIdentifier" // navigate to the new VC
        static let ShowImageIdentifer         = "showImageIdentifier" // navigate to show image(a scroll view)
        static let WebSegueIdentifier         = "WebSegueIdentifier" // navigate to a blank VC and open the link in safari
    }
    
    // MARK: - Navigation
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool { // should we perform the segue with the identifier? --true yes, --false no
        if identifier == Storyboard.SearchResultsIdentifier{
            if let cell = sender as? UITableViewCell {
                if let url = cell.textLabel?.text {
                    if url.hasPrefix("http") {
                        performSegueWithIdentifier(Storyboard.WebSegueIdentifier, sender: sender)
                        return false // no because we want to connect to this link in safari
                    }
                }
            }
        }
        return true
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
        if segue.identifier == Storyboard.SearchResultsIdentifier {
            if let searchResutTVC = segue.destinationViewController as? tweetTableViewController {
                if let cell = sender as? UITableViewCell {
                    if let cellContents = cell.textLabel?.text{
                        searchResutTVC.searchText = cellContents
                    }
                }
            }
        } else if segue.identifier == Storyboard.WebSegueIdentifier {
            if let webTVC = segue.destinationViewController as? webViewController {
                if let cell = sender as? UITableViewCell {
                    if let url = cell.textLabel?.text{
                        webTVC.url = url
                    }
                }
            }
        } else if segue.identifier == Storyboard.ShowImageIdentifer {
            if let imageVC = segue.destinationViewController as? imageViewContrller {
                if let imageCell = sender as? tweetImageViewCell {
                    imageVC.imageURL = imageCell.imageURL  // get imageURL from the cell, no need to reload the url from 'detailedTweetArray'
                }
            }
        }
    }
 
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


}
