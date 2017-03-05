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
    
    var tweet:Tweet!
    var tweetID: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let skyBlue = UIColor(red: 0.0, green: 172.0/255.0, blue: 237.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.barTintColor = skyBlue
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        nameLabel.text = tweet.name as String!
        usernameLabel.text = "@"
        tweetLabel.text = tweet.text as String!
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        let date = formatter.date(from: tweet.timestamp! as String) as NSDate?
        formatter.dateFormat = "MM/dd/yy HH:mm::ss"
        timestampLabel.text = formatter.string(from: date as! Date)
        
        if let photoData = NSData(contentsOf: tweet.profilePhotoUrl! as URL) {
            profileImageButton.setImageFor(.normal, with: tweet.profilePhotoUrl! as URL)
        }
        
        tweetID = tweet.tweetID!
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        retweetCountLabel.text = String(tweet.retweetCount)
        favoriteCountLabel.text = String(tweet.favoritesCount)
        
        if tweet.retweeted! {
            retweetButton.setImage((UIImage(named: "retweet-icon-green")), for: .normal)
        }
        else {
            retweetButton.setImage((UIImage(named: "retweet-icon")), for: .normal)
        }
        if tweet.favorited! {
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
        if tweet.retweeted! {
            
            tweet.retweetCount -= 1
            
        }
        else {
            tweet.retweetCount += 1
        }
        self.retweetCountLabel.text = String(tweet.retweetCount)
        tweet.retweeted = !(tweet.retweeted!)
    }

    @IBAction func favoritePressed(_ sender: Any) {
        if tweet.favorited! {
            
            tweet.favoritesCount -= 1
            
        }
        else {
            tweet.favoritesCount += 1
        }
        self.favoriteCountLabel.text = String(tweet.favoritesCount)
        tweet.favorited = !(tweet.favorited!)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
