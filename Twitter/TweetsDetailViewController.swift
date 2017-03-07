//
//  TweetsDetailViewController.swift
//  Twitter
//
//  Created by Vivian Pham on 2/28/17.
//  Copyright © 2017 Vivian Pham. All rights reserved.
//

import UIKit

class TweetsDetailViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    var tweet:Tweet!
    var user: User!
    var tweetID: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        let skyBlue = UIColor(red: 0.0, green: 172.0/255.0, blue: 237.0/255.0, alpha: 1.0)
        navigationBar.barTintColor = skyBlue
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        */
        
        nameLabel.text = tweet.name as String!
        usernameLabel.text = "@" + String(describing: tweet.name!)
        tweetLabel.text = tweet.text as String!
        
        timestampLabel.text = tweet.timestamp
        
        if let photoData = NSData(contentsOf: tweet.profilePhotoUrl! as URL) {
            profileImageButton.setImageFor(.normal, with: tweet.profilePhotoUrl! as URL)
        }
        else {
            profileImageButton.setImage(UIImage(named: "profile-Icon"), for: .normal)
        }
        
        favoriteButton.setImage(UIImage(named: "favor-icon"), for: .normal)
        retweetButton.setImage(UIImage(named: "retweet-icon"), for: .normal)
        tweetID = tweet.tweetID!
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        retweetCountLabel.text = String(tweet.retweetCount)
        favoriteCountLabel.text = String(tweet.favoritesCount)
        
        if tweet.retweeted {
            retweetButton.setImage((UIImage(named: "retweet-icon-green")), for: .normal)
        }
        else {
            retweetButton.setImage((UIImage(named: "retweet-icon")), for: .normal)
        }
        if tweet.favorited {
            favoriteButton.setImage((UIImage(named: "favor-icon-red")), for: .normal)
        }
        else{
            favoriteButton.setImage((UIImage(named: "favor-icon")), for: .normal)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func homeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func retweetPressed(_ sender: Any) {
        if tweet.retweeted {
            TwitterClient.sharedInstance?.unretweet(tweetID: tweetID, success: { (tweet: Tweet) in
                self.retweetButton.setImage((UIImage(named: "retweet-icon")), for: .normal)
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            })
            tweet.retweetCount -= 1
            
        }
        else {
            TwitterClient.sharedInstance?.retweet(tweetID: tweetID, success: { (tweet: Tweet) in
                self.retweetButton.setImage((UIImage(named: "retweet-icon-green")), for: .normal)
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            })
            tweet.retweetCount += 1
        }
        self.retweetCountLabel.text = String(tweet.retweetCount)
        tweet.retweeted = !(tweet.retweeted)
    }

    @IBAction func favoritePressed(_ sender: Any) {
        if tweet.favorited {
            TwitterClient.sharedInstance?.unfavorite(tweetID: tweetID, success: { (tweet: Tweet) in
                self.favoriteButton.setImage((UIImage(named: "favor-icon")), for: .normal)
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            })
            tweet.favoritesCount -= 1
            
        }
        else {
            TwitterClient.sharedInstance?.favorite(tweetID: tweetID, success: { (tweet: Tweet) in
                self.favoriteButton.setImage((UIImage(named: "favor-icon-red")), for: .normal)
            }, failure: { (error: Error) in
                print(error.localizedDescription)
            })
            tweet.favoritesCount += 1
        }
        self.favoriteCountLabel.text = String(tweet.favoritesCount)
        tweet.favorited = !(tweet.favorited)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "profileSegue" {
            let vc = segue.destination as! TimelineViewController
            vc.user = User.currentUser
        }
        
        else if segue.identifier == "replySegue" {
            let vc = segue.destination as! ComposeTweetViewController
            vc.user = User.currentUser
            vc.text = "@" + String(describing: tweet.name!)
        }
    }

}
