//
//  tweetTableViewController.swift
//  smashTweet
//
//  Created by Yiqin Yao on 8/11/16.
//  Copyright © 2016 Yiqin Yao. All rights reserved.
//

import UIKit
import Twitter
import CoreData

class tweetTableViewController: UITableViewController, UITextFieldDelegate {
    
    // MARK: model
    
    var managedObjectContext: NSManagedObjectContext? =
        (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext // where we gonna store our database by default
    
    var attributedText: NSAttributedString?
    
    var tweets = [Array<Twitter.Tweet>]() {
        didSet {
            // print("\(tweets.count)") // only 1 section
            tableView.reloadData()
        }
    }
    
    
    
    var searchText: String? {
        didSet{
            lastSuccessfulRequest = nil
            tweets.removeAll()
            searchForTweets()   
            title = searchText
        }
    }
    
    
    //private var twitterRequest: Twitter.Request? {
    //    if let query = searchText where !query.isEmpty {
    //        return Twitter.Request(search: query + "-filter:retweets", count: 100)
    //    }
    //    return nil
    //}
    
    //private var lastTwitterRequest: Twitter.Request?
    
    private func searchForTweets() {
        
        refreshControl?.beginRefreshing()
        refresh(refreshControl)
    }
    
    var lastSuccessfulRequest: Twitter.Request?
    
    var nextRequesttoAttempt: Twitter.Request? {
        if lastSuccessfulRequest == nil {
            if searchText != nil {
                return Twitter.Request(search: searchText! + "-filter:retweets", count: 100)
            } else {
                return nil
            }
        } else {
            return lastSuccessfulRequest!.requestForNewer
        }
    }
    
    @IBAction private func refresh(sender: UIRefreshControl?) {
        //if let request = twitterRequest {
            //lastTwitterRequest = request
            if let request = nextRequesttoAttempt {
                request.fetchTweets{ [weak weakSelf = self] newTweets in
                    dispatch_async(dispatch_get_main_queue()) {
                        //if request == weakSelf?.nextRequesttoAttempt {
                            if !newTweets.isEmpty {
                                weakSelf?.lastSuccessfulRequest = request
                                weakSelf?.tweets.insert(newTweets, atIndex: 0)
                                weakSelf?.updateDatabase(newTweets)
                            }
                        //}
                        sender?.endRefreshing()
                    }
                }
            } else {
                sender?.endRefreshing()
            }
        }
    
    
    
    /* Every time we access the database we have to do it with performBlock because these managedObjectContexts are only thread safe within the thread where they are created on  */
    private func updateDatabase(newTweets: [Twitter.Tweet]) {
        managedObjectContext?.performBlock{
            for twitterInfo in newTweets {
                // Create a new, unique Tweet with that twitterInfo
                _ = Tweet.tweetWithTwitterInfo(twitterInfo, inManagedObjectContext: self.managedObjectContext!)
            }
            do{
                try self.managedObjectContext?.save()
            } catch let error {
                print("Core Data Error \(error)")
            }
        }
        printDatabaseStatistics()
        print("Done printing database statistics")
    }
    
    
    
    private func printDatabaseStatistics() {
        managedObjectContext?.performBlock{
            if let results = try? self.managedObjectContext!.executeFetchRequest(NSFetchRequest(entityName: "TweeterUser")) {
                print("\(results.count) TwitterUsers.")
            }
            // A more efficient way to count objects
            let tweetCount = self.managedObjectContext!.countForFetchRequest(NSFetchRequest(entityName: "Tweet"), error: nil)
                print("\(tweetCount) Tweets")
        }
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Storyboard.SegueIdentifierOfTweetersMentioningSearchTerm {
            if let tweetersTVC = segue.destinationViewController as? TweetersUITableViewController {
                tweetersTVC.mention = searchText
                tweetersTVC.managedObjectContext = managedObjectContext
            }
        }
        if segue.identifier == Storyboard.SegueIdentifierOfDetailedTweets {
            if let detailedTweetsTVC = segue.destinationViewController as? DetailOfTweetsTableViewController {
                if let selectedCell = sender as? UITableViewCell {
                    if let selectedIndex = tableView.indexPathForCell(selectedCell) {
                        print("aaaaa")
                        detailedTweetsTVC.tweetItem = tweets[selectedIndex.section][selectedIndex.row]// TODO
                    }
                }
            }
        }
    }
    

    
    
    // MARk: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.delegate = self
        //searchText = "#stanford" //initial thing
        searchForTweets()
    }
    
    
    
    // MARK: - UITableViewDataSource
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tweets.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets[section].count
    }

    private struct Storyboard {
        static let CellReuseIdentifier = "Tweet"
        static let SegueIdentifierOfTweetersMentioningSearchTerm = "tweetersMentioningSearchTerm"
        static let SegueIdentifierOfDetailedTweets = "DetailOfTweets"
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellReuseIdentifier, forIndexPath: indexPath) as UITableViewCell
        
        let tweet = tweets[indexPath.section][indexPath.row]
        if let tweetCell = cell as? TweetTableViewCell {
            tweetCell.tweet = tweet
            
        }
        
        return cell
    }
    @IBOutlet weak var searchTextField: UITextField! {
        didSet{
            searchTextField.delegate = self
            searchTextField.text = searchText
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        searchText = textField.text
        return true
    }
}
