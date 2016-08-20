//
//  Tweet.swift
//  smashTweet
//
//  Created by Yiqin Yao on 8/16/16.
//  Copyright © 2016 Yiqin Yao. All rights reserved.
//

import Foundation
import CoreData
import Twitter

class Tweet: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    class func tweetWithTwitterInfo(twitterInfo: Twitter.Tweet, inManagedObjectContext context: NSManagedObjectContext) -> Tweet? {
        
        let request = NSFetchRequest(entityName: "Tweet")
        request.predicate = NSPredicate(format: "unique = %@", twitterInfo.id)
        
        if let tweet = (try? context.executeFetchRequest(request))?.first as? Tweet {
            return tweet // if exists, just return it, if not, insert new tweet
        } else if let tweet = NSEntityDescription.insertNewObjectForEntityForName("Tweet", inManagedObjectContext: context) as? Tweet {
            tweet.unique = twitterInfo.id
            tweet.text = twitterInfo.text
            tweet.posted = twitterInfo.created
            tweet.tweeter = TweeterUser.twitterUserWithTwitterInfo(twitterInfo.user, inManagedObjectContext: context)
            return tweet
        }
        
        
        //do {
        //    let queryResults = try context.executeFetchRequest(request)
        //    if let tweet = queryResults.first as? Tweet { // if exists, just return it.
        //        return tweet
        //    }
        //} catch let error {
        //    // ignore
        //}
        
        
        return nil
    }
    
}
