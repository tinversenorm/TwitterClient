//
//  TweetCell.swift
//  TwitterClient
//
//  Created by Sita Mulomudi on 3/4/16.
//  Copyright © 2016 TinverseNorm. All rights reserved.
//

import UIKit
import AFNetworking

class TweetCell: UITableViewCell {
    
    @IBOutlet var userProfileImageButton: ProfileButton!
    
    @IBOutlet var userName: UILabel!
    @IBOutlet var userHandle: UILabel!
    @IBOutlet var tweetContent: UILabel!
    @IBOutlet var retweetCount: UILabel!
    @IBOutlet var favoriteCount: UILabel!
    @IBOutlet var timeStamp: UILabel!
    
    @IBOutlet var retweetButton: UIButton!
    @IBOutlet var favoriteButton: UIButton!
    
    var rtSelected = false
    var favSelected = false
    
    var tweetID: String!
    
    @IBAction func onRetweet(sender: AnyObject) {
        retweetButton.selected = !rtSelected
        rtSelected = !rtSelected
        if rtSelected {
            TwitterClient.sharedInstance.retweet(tweetID, success: { (data: NSDictionary) -> () in
                TwitterClient.sharedInstance.getTweet(self.tweetID, success: { (data: NSDictionary) -> () in
                    self.tweet = Tweet(dictionary: data)
                    }, failure: { (error: NSError) -> () in
                        print(error.localizedDescription)
                })
                }, failure: { (error: NSError) -> () in
                print(error.localizedDescription)
            })
        }
    }
    
    @IBAction func onFavorite(sender: AnyObject) {
        favoriteButton.selected = !favSelected
        favSelected = !favSelected
        if favSelected {
            TwitterClient.sharedInstance.favorite(true, tweetID: tweetID, success: { (data: NSDictionary) -> () in
                self.tweet = Tweet(dictionary: data)
                }, failure: { (error: NSError) -> () in
                    print(error.localizedDescription)
            })
        } else {
            TwitterClient.sharedInstance.favorite(false, tweetID: tweetID, success: { (data: NSDictionary) -> () in
                self.tweet = Tweet(dictionary: data)
                }, failure: { (error: NSError) -> () in
                    print(error.localizedDescription)
            })
        }
    }
    
    var tweet: Tweet! {
        didSet {
            tweetContent.text = tweet.text
            let user = tweet.user
            userName.text = user?.name
            userHandle.text = user?.screenname
            userProfileImageButton.setImageForState(.Normal, withURL: (user?.profileURL)!)
            userProfileImageButton.user = user
            retweetCount.text = tweet.retweet_count.description
            favoriteCount.text = tweet.favorite_count.description
            tweetID = tweet.id
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
