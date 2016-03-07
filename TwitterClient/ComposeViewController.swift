//
//  ComposeViewController.swift
//  TwitterClient
//
//  Created by Sita Mulomudi on 3/6/16.
//  Copyright © 2016 TinverseNorm. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UITextViewDelegate {

    @IBOutlet var userProfileImage: UIImageView!
    @IBOutlet var userName: UILabel!
    @IBOutlet var userHandle: UILabel!
    @IBOutlet var textView: UITextView!
    
    @IBOutlet var charCountLeft: UIBarButtonItem!
    
    var user: User? {
        didSet {
            userProfileImage.setImageWithURL((user?.profileURL)!)
            userName.text = user?.name
            userHandle.text = user?.screenname
        }
    }
    
    func postTweet() {
        let count = textView.text.characters.count
        if count > 140 {
        } else {
            TwitterClient.sharedInstance.tweet(textView.text, success: { (data: NSDictionary) -> () in
                    print("success");
                }, failure: { (error:NSError) -> () in
                    print(error.localizedDescription)
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.user = User.currentUser
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "unwindSegueTweet" {
            
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
