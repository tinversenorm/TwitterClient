//
//  User.swift
//  TwitterClient
//
//  Created by Sita Mulomudi on 2/23/16.
//  Copyright © 2016 TinverseNorm. All rights reserved.
//

import UIKit

class User: NSObject {
    
    var name: String?
    var screenname: String?
    var profileURL: NSURL?
    var tagline: String?
    var profileURLBig: NSURL?
    var profileBGColor: String?
    //var profileBGURL: NSURL?
    var tweetCount: Int?
    var followerCount: Int?
    var followingCount: Int?
    
    var dictionary: NSDictionary?
    
    init(dictionary: NSDictionary) {
        // deserialization code
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenname = "@" + (dictionary["screen_name"] as? String)!
        if let profURLString = dictionary["profile_image_url_https"] {
            profileURL = NSURL(string: profURLString as! String)
            profileURLBig = NSURL(string: (profURLString as! String).stringByReplacingOccurrencesOfString("normal.", withString: "bigger."))
        }
        profileBGColor = dictionary["profile_background_color"] as? String
        tagline = dictionary["description"] as? String
        tweetCount = dictionary["statuses_count"] as? Int
        followerCount = dictionary["followers_count"] as? Int
        followingCount = dictionary["friends_count"] as? Int
    }

    static var _currentUser: User?
    static let userDidLogoutNotification = "UserDidLogout"
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = NSUserDefaults.standardUserDefaults()
                let userData = defaults.objectForKey("currentUserData") as? NSData
                if let userData = userData {
                    let dictionary = try! NSJSONSerialization.JSONObjectWithData(userData, options: []) as! NSDictionary
                    //let dictionary = try! NSKeyedUnarchiver.unarchiveObjectWithData(userData)! as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        } set(user) {
            _currentUser = user // set current user
            let defaults = NSUserDefaults.standardUserDefaults() // access persistent storage
            
            if let user = user {
                let data = try! NSJSONSerialization.dataWithJSONObject(user.dictionary!, options: []) // turn user object into serializable dictionary
                defaults.setObject(data, forKey: "currentUserData") // store object
            } else {
                defaults.setObject(nil, forKey: "currentUserData") // if no user, store nil
            }
            defaults.synchronize() // save it
        }
    }
}
