//
//  searchHistory.swift
//  smashTweet
//
//  Created by Yiqin Yao on 9/4/16.
//  Copyright © 2016 Yiqin Yao. All rights reserved.
//

import Foundation

class searchHistory {
    private struct HistoryConstant {
        static let ValuesKey = "RecentSearches.Values"
        static let NumberOfSearches = 100
    }
    
    private let defaults = NSUserDefaults.standardUserDefaults()
    
    var values: [String] {
        get { return defaults.objectForKey(HistoryConstant.ValuesKey) as? [String] ?? [] } // Get the default list
        set { defaults.setObject(newValue, forKey: HistoryConstant.ValuesKey) } // renew the list
    }
    
    func add(search: String) {
        var currentSearches = values
        // If the search item exists, move it to the top one of the table
        if let index = currentSearches.indexOf(search) {
            currentSearches.removeAtIndex(index)
        }
        currentSearches.insert(search, atIndex: 0)
        while currentSearches.count > HistoryConstant.NumberOfSearches {
            currentSearches.removeLast()
        }
        values = currentSearches
    }
    
    func removeAtIndex(index: Int) {
        var currentSearches = values
        currentSearches.removeAtIndex(index)
        values = currentSearches
    }
    
}