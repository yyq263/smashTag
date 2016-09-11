//
//  searchHistoryTableViewController.swift
//  smashTweet
//
//  Created by Yiqin Yao on 9/4/16.
//  Copyright © 2016 Yiqin Yao. All rights reserved.
//

import UIKit

class searchHistoryTableViewController: UITableViewController {
    
    // MARK: - life cycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        title = "Search History"
    }
    
    // MARK: - table view data source
    
    private struct Storyboard {
        static let searchItemNameReuseIdentifier       = "searchItemName"
        static let searchInTheHistoryList              = "searchInTheHistoryList"
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchHistory().values.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.searchItemNameReuseIdentifier, forIndexPath: indexPath)
        cell.textLabel?.text = searchHistory().values[indexPath.row]
        return cell
    }
    
    // Remove from table
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            searchHistory().removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Storyboard.searchInTheHistoryList {
            if let tweetTVC = segue.destinationViewController as? tweetTableViewController {
                if let HistoryCell = sender as? UITableViewCell {
                    tweetTVC.searchText = HistoryCell.textLabel?.text
                }
            }
        }
    }
    
}
