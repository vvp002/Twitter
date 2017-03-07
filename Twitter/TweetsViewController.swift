//
//  TweetsViewController.swift
//  Twitter
//
//  Created by Vivian Pham on 2/27/17.
//  Copyright © 2017 Vivian Pham. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet]!
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //instantiate the table view
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 170
        
        
        //Change design and color of the view controller to make it look nicer
        let skyBlue = UIColor(red: 0.0, green: 172.0/255.0, blue: 237.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.barTintColor = skyBlue
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
 
        
        //Display the user's hometimeline unless error
        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) -> () in
                self.tweets = tweets
            
                self.tableView.reloadData()
            
            }, failure: { (error: Error) -> () in
            print("error: \(error.localizedDescription)")
        })
        self.tableView.reloadData()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
        }, failure: { (error: Error) in
            print(error.localizedDescription)
        })
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Log the user out if pressed the log out button
    @IBAction func onLogoutButton(_ sender: Any) {
        TwitterClient.sharedInstance?.logout()
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //display the total number of tweets in their own rows
        if let tweets = self.tweets {
            return tweets.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Use reusable cell for tweets
        let cell: TweetsTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "TweetsTableViewCell", for: indexPath) as! TweetsTableViewCell
        
        //Get desired tweet from indexPath.row
        let tweet = tweets[indexPath.row]
        
        //Instantiate the cell contents with that of the corresponding parts in the
        //tweet
        cell.tweetAuthorUsername.text = tweet.username as String?
        cell.tweetTextLabel.text = tweet.text as String?
        cell.tweetTimestamp.text = tweet.timestamp as String?
        cell.tweetAuthorName.text = tweet.name as String?
        cell.tweetAuthorProfilePic.setImageFor(.normal, with: tweet.profilePhotoUrl! as URL)
        cell.retweetCount.text = String(tweet.retweetCount)
        cell.favoriteCount.text = String(tweet.favoritesCount)
        
        return cell
    }
    
    //deselect the row once clicked on to make it look nicer
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    @IBAction func onRetweet(_ sender: Any) {
        //Instantiate button, view, cell, and indexpath
        let button = sender as! UIButton
        let view = button.superview!
        let cell = view.superview as! TweetsTableViewCell
        let indexPath = tableView.indexPath(for: cell)
        
        //Increment retweetCount once user has tapped on retweet button
        self.tweets![indexPath!.row].retweetCount = self.tweets![indexPath!.row].retweetCount + 1
        
        //Set the retweet button image to green one to announce retweet
        let retweetImage = UIImage(named: "retweet-icon-green")
        cell.retweetButton.setImage(retweetImage, for: .normal)
        
        //reload data
        self.tableView.reloadData()
    }
    
    
    @IBAction func onFav(_ sender: Any) {
        //instantiate the button, view, cell, and indexpath
        let button = sender as! UIButton
        let view = button.superview!
        let cell = view.superview as! TweetsTableViewCell
        let indexPath = tableView.indexPath(for: cell)
        
        //Incremenet favorites count once user has tapped on the favorite button
        self.tweets![indexPath!.row].favoritesCount = self.tweets![indexPath!.row].favoritesCount + 1
        
        //Set the favorite button image to the red one to announce fav
        let favImage = UIImage(named: "favor-icon-red")
        cell.favoriteButton.setImage(favImage, for: .normal)
        
        //reload data
        self.tableView.reloadData()
    }
    
     /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
 */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "tweetSegue"{
            let vc = segue.destination as! TweetsDetailViewController
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell)
            let tweet = tweets[(indexPath?.row)!]
            vc.tweet = tweet
            vc.user = tweet.user
            let cell = sender as! UITableViewCell
            cell.selectionStyle = .gray
        }
        else if segue.identifier == "profileSegue" {
            let vc = segue.destination as! TimelineViewController
            let button = sender as? UIButton
            let cell = button?.superview?.superview as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            let tweet = tweets[(indexPath?.row)!]
            vc.user = User.currentUser
        }
        else if segue.identifier == "replySegue" {
            let vc = segue.destination as! ComposeTweetViewController
            if let button = sender as? UIButton {
                let cell = button.superview?.superview as! UITableViewCell
                let indexPath = tableView.indexPath(for: cell)
                let tweet = tweets[(indexPath?.row)!]
                vc.user = User.currentUser
                vc.text = "@" + String(describing: tweet.name)
            }
        }
        
    }
 

}
