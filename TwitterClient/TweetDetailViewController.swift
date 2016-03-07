//
//  TweetDetailViewController.swift
//  TwitterClient
//
//  Created by Sita Mulomudi on 3/5/16.
//  Copyright © 2016 TinverseNorm. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {
    
    
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var userName: UILabel!
    @IBOutlet var userHandle: UILabel!
    @IBOutlet var tweetContent: UILabel!
    @IBOutlet var timestamp: UILabel!
    @IBOutlet var retweetCount: UILabel!
    @IBOutlet var favoriteCount: UILabel!
    @IBOutlet var replyButton: UIButton!
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

    @IBAction func onReply(sender: AnyObject) {
        
    }
    
    var tweet: Tweet! {
        didSet {
            let user = tweet.user!
            profileImage.setImageWithURL(user.profileURLBig!);
            userName.text = user.name!
            userHandle.text = user.screenname!
            tweetContent.text = tweet.text
            timestamp.text = tweet.timestamp?.description
            retweetCount.text = tweet.retweet_count.description
            favoriteCount.text = tweet.favorite_count.description
            tweetID = tweet.id
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
