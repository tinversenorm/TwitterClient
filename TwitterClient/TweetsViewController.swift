//
//  TweetsViewController.swift
//  TwitterClient
//
//  Created by Sita Mulomudi on 3/3/16.
//  Copyright © 2016 TinverseNorm. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var tweets: [Tweet]?
    @IBOutlet var tableView: UITableView!
    
    @IBAction func onLogout(sender: AnyObject) {
        TwitterClient.sharedInstance.logout()
    }
    
    @IBAction func unwindWithCancel(sender: UIStoryboardSegue) {
        
    }
    
    @IBAction func unwindWithTweet(sender: UIStoryboardSegue) {
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        if let tweets = tweets {
            let currentTweet = tweets[indexPath.row]
            cell.tweet = currentTweet
        }
        return cell;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = tweets {
            return tweets.count
        } else {
            return 0;
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension 
        
        TwitterClient.sharedInstance.homeTimeline({ (tweets: [Tweet]) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            }) { (error: NSError) -> () in
                self.tweets = []
                print(error.localizedDescription)
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "detailViewSegue" {
            let vc = segue.destinationViewController as! TweetDetailViewController
            vc.loadView()
            vc.view.layoutSubviews()
            vc.tweet = (sender as! TweetCell).tweet
        } else if segue.identifier == "showProfileFromHome" {
            let vc = segue.destinationViewController as! ProfileViewController;
            vc.loadView()
            vc.view.layoutSubviews()
            vc.user = (sender as! ProfileButton).user
        }
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
