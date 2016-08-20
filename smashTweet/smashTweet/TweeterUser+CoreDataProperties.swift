//
//  TweeterUser+CoreDataProperties.swift
//  smashTweet
//
//  Created by Yiqin Yao on 8/16/16.
//  Copyright © 2016 Yiqin Yao. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension TweeterUser {

    @NSManaged var screenName: String?
    @NSManaged var name: String?
    @NSManaged var tweets: NSSet?

}
