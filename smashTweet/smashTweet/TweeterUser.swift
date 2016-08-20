//
//  TweeterUser.swift
//  smashTweet
//
//  Created by Yiqin Yao on 8/16/16.
//  Copyright © 2016 Yiqin Yao. All rights reserved.
//

import Foundation
import CoreData
import Twitter

class TweeterUser: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    class func twitterUserWithTwitterInfo(twitterInfo: Twitter.User, inManagedObjectContext context: NSManagedObjectContext) -> TweeterUser?
    {
        let request = NSFetchRequest(entityName: "TweeterUser")
        request.predicate = NSPredicate(format: "screenName = %@", twitterInfo.screenName)
        if let twitterUser = (try? context.executeFetchRequest(request))?.first as? TweeterUser {
            return twitterUser
        } else if let twitterUser = NSEntityDescription.insertNewObjectForEntityForName("TweeterUser", inManagedObjectContext: context) as? TweeterUser {
            twitterUser.screenName = twitterInfo.screenName
            twitterUser.name = twitterInfo.name
            return twitterUser
        }
        return nil
    
    }
    
}
