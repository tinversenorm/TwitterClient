//
//  ProfileViewController.swift
//  TwitterClient
//
//  Created by Sita Mulomudi on 3/6/16.
//  Copyright © 2016 TinverseNorm. All rights reserved.
//

import UIKit
import AFNetworking

class ProfileViewController: UIViewController {

    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var userName: UILabel!
    @IBOutlet var userHandle: UILabel!
    @IBOutlet var tweetCount: UILabel!
    @IBOutlet var followingCount: UILabel!
    @IBOutlet var followerCount: UILabel!
    @IBOutlet var userBackground: UIView!
    
    var user: User? {
        didSet {
            self.loadView()
            self.view.layoutSubviews()
            profileImage.setImageWithURL((user?.profileURLBig)!)
            userName.text = user?.name
            userHandle.text = user?.screenname
            tweetCount.text = user?.tweetCount?.description
            followerCount.text = user?.followerCount?.description
            followingCount.text = user?.followingCount?.description
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(user?.profileURL)
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
