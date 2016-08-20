//
//  TweetersUITableViewController.swift
//  smashTweet
//
//  Created by Yiqin Yao on 8/16/16.
//  Copyright © 2016 Yiqin Yao. All rights reserved.
//

import UIKit
import CoreData

class TweetersUITableViewController: CoreDataTableViewController {

    var mention: String? { didSet { updateUI() } }
    var managedObjectContext: NSManagedObjectContext? { didSet { updateUI() } }
    
    private func updateUI() {
        if let context = managedObjectContext where mention?.characters.count > 0{
            let request = NSFetchRequest(entityName: "TweeterUser")
            request.predicate = NSPredicate(format: "any tweets.text contains[c] %@ and !screenName beginswith[c] %@", mention!, "darkside")
            request.sortDescriptors = [NSSortDescriptor(
                key: "screenName",
                ascending: true,
                selector: #selector(NSString.localizedCaseInsensitiveCompare(_:))
            )]
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
            )
        } else {
            fetchedResultsController = nil
        }
    }
    
    private func tweetCountWithMentionByTwitterUser(user: TweeterUser) -> Int? {
        var count: Int?
        user.managedObjectContext?.performBlockAndWait{
            let request = NSFetchRequest(entityName: "Tweet")
            request.predicate = NSPredicate(format: "text contains[c] %@ and tweeter = %@", self.mention!, user)
            count = user.managedObjectContext?.countForFetchRequest(request, error: nil)
        }
        return count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweeterUserCell", forIndexPath: indexPath)
        
        if let twitterUser = fetchedResultsController?.objectAtIndexPath(indexPath) as? TweeterUser{
            var screenName: String?
            twitterUser.managedObjectContext?.performBlockAndWait{
                screenName = twitterUser.screenName // wait until this happens before we can do UI thing
            }
            cell.textLabel?.text = screenName
            if let count = tweetCountWithMentionByTwitterUser(twitterUser) {
                cell.detailTextLabel?.text = (count == 1) ? "1 tweets" : "\(count) tweets"
            } else {
                cell.detailTextLabel?.text = nil
            }
        }
    return cell
    }
}
