//
//  TimelineViewController.swift
//  Twitter
//
//  Created by Vivian Pham on 2/28/17.
//  Copyright © 2017 Vivian Pham. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var tweetsLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var navBar: UINavigationBar!
    var user: User!
    var tweets: [Tweet]!
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Change design and color of the view controller to make it look nicer
        let skyBlue = UIColor(red: 0.0, green: 172.0/255.0, blue: 237.0/255.0, alpha: 1.0)
        navBar.barTintColor = skyBlue
        navBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        let twitterClient  = TwitterClient.sharedInstance
        twitterClient?.homeTimeline(success: { (tweets: [Tweet]) -> () in
            self.tweets = tweets
            
            self.tableView.reloadData()
            
        }, failure: { (error: Error) -> () in
            print("error: \(error.localizedDescription)")
        })


        nameLabel.text = String(describing: user.name!)
        tweetsLabel.text = String(user.tweetCount)
        followersLabel.text = String(user.followersCount)
        followingLabel.text = String(user.followersCount)
        
        if user.profileUrl != URL(string: "") {
            profileImage.setImageWith(user.profileUrl! as URL)
        }
        
        self.tableView.reloadData()
        // Do any additional setup after loading the view.
        
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let tweets = self.tweets{
            return tweets.count
        }
        return 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell") as! ProfileTableViewCell
        
        //Get desired tweet from indexPath.row
        let tweet = tweets[indexPath.row]
        
        //Instantiate the cell contents with that of the corresponding parts in the
        //tweet
        cell.nameLabel.text = tweet.name as String?
        cell.usernameLabel.text = tweet.name as String?
        cell.tweetText.text = tweet.text as String?
        cell.retweetCount.text = String(tweet.retweetCount)
        cell.favoriteCount.text = String(tweet.favoritesCount)
        cell.timestampLabel.text = tweet.timestamp as String?
        cell.profileImage.setImageFor(.normal, with: tweet.profilePhotoUrl! as URL)

        return cell
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
