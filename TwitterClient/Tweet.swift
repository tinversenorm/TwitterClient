//
//  Tweet.swift
//  TwitterClient
//
//  Created by Sita Mulomudi on 2/23/16.
//  Copyright © 2016 TinverseNorm. All rights reserved.
//

import UIKit

class Tweet: NSObject {

    var text: String?
    var timestamp: NSDate?
    var retweet_count: Int = 0
    var favorite_count: Int = 0
    var user: User?
    var id: String?
    
    init(dictionary: NSDictionary) {
        text = dictionary["text"] as? String
        retweet_count = (dictionary["retweet_count"] as? Int) ?? 0
        favorite_count = (dictionary["favorite_count"] as? Int) ?? 0
        if let userdict = dictionary["user"] as? NSDictionary {
            //print(userdict)
            self.user = User(dictionary: userdict)
        }
        if let timestampString = dictionary["created_at"] as? String {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timestamp = formatter.dateFromString(timestampString)
        }
        id = (dictionary["id_str"] as? String)
    }
    
    // "static method" like java
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        return tweets
    }
    
}
