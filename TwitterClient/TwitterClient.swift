//
//  TwitterClient.swift
//  TwitterClient
//
//  Created by Sita Mulomudi on 2/23/16.
//  Copyright © 2016 TinverseNorm. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com"), consumerKey: "DqqG3GOfHRDNQNmrsJBgmckXm", consumerSecret: "37zszwPhyahlzRX4X0Pxcp2bKD7G7Aabz8jhIBHw5pibtFZfZA")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    func handleOpenURL(url: NSURL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) -> Void in
            
            self.currentAccount({ (user: User) -> () in
                    User.currentUser = user // saves in persistent storage -- computed property
                    self.loginSuccess?()
                }, failure: { (error: NSError) -> () in
                    self.loginFailure?(error)
            })
            
            self.loginSuccess?()
            
            }) { (error: NSError!) -> Void in
                self.loginFailure!(error)
        }
    }
    
    func login(success: () -> (), failure: (NSError) -> ()) {
        loginSuccess = success
        loginFailure = failure
        TwitterClient.sharedInstance.deauthorize()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "mytwitterclient://oauth"), scope: nil, success: { (request:BDBOAuth1Credential!) -> Void in
            
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(request.token)")
            UIApplication.sharedApplication().openURL(url!)
            
            }) { (error:NSError!) -> Void in
                print(error.localizedDescription)
                self.loginFailure?(error)
        }
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotification, object: nil)
    }
    
    func tweet(status: String, success: (NSDictionary) -> (), failure: (NSError) -> ()) {
        POST("1.1/statuses/update.json", parameters: ["status", status], success: { (task: NSURLSessionDataTask, data: AnyObject?) -> Void in
            if let dictionary = data as? NSDictionary {
            success(dictionary)
            }
            }) { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        }
    }
    
    func homeTimeline(success: ([Tweet]) -> (), failure: (NSError) -> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let tweetDicts = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(tweetDicts)
            success(tweets)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print(error.localizedDescription)
                failure(error)
        })
    }
    
    func favorite(create: Bool, tweetID: String, success: (NSDictionary) -> (), failure: (NSError) -> () ) {
        var urlString = "1.1/favorites/create.json"
        if !create {
            urlString = "1.1/favorites/destroy.json"
        }
        POST(urlString, parameters: ["id" : tweetID], success: { (task: NSURLSessionDataTask, data: AnyObject?) -> Void in
            if let dictionary = data as? NSDictionary {
                success(dictionary)
            }
            }) { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        }
    }
    
    func retweet(tweetID: String, success: (NSDictionary) -> (), failure: (NSError) -> () ) {
        POST("1.1/statuses/retweet/\(tweetID).json", parameters: nil, success: { (task: NSURLSessionDataTask, data: AnyObject?) -> Void in
            if let dictionary = data as? NSDictionary {
                success(dictionary)
            }
            }) { (task:NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        }
    }
    
    func getTweet(tweetID: String, success: (NSDictionary) -> (), failure: (NSError) -> ()) {
        GET("1.1/statuses/show.json", parameters: ["id" : tweetID], success: { (task: NSURLSessionDataTask, data: AnyObject?) -> Void in
            if let dictionary = data as? NSDictionary {
                success(dictionary)
            }
            }) { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        }
    }
    
    func currentAccount(success: (User) -> (), failure: (NSError) -> ()) {
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            print(response)
            
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            
            success(user)
            
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                print(error)
                failure(error)
        })
    }
}
