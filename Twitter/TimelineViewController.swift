//
//  TimelineViewController.swift
//  Twitter
//
//  Created by Vivian Pham on 2/28/17.
//  Copyright © 2017 Vivian Pham. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var tweetsLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    var user: User!
    var tweets: [Tweet]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLabel.text = String(describing: user.name!)
        tweetsLabel.text = String(user.tweetCount)
        followersLabel.text = String(user.followersCount)
        followingLabel.text = String(user.followersCount)
        
        if user.profileUrl != URL(string: "") {
            profileImage.setImageWith(user.profileUrl! as URL)
        }
        // Do any additional setup after loading the view.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "composeSegue" {
            let vc = segue.destination as! ComposeTweetViewController
            vc.user = User.currentUser
        }
    }
 

}
