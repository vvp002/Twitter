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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 170
        
        let skyBlue = UIColor(red: 0.0, green: 172.0/255.0, blue: 237.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.barTintColor = skyBlue
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        TwitterClient.sharedInstance?.homeTimeline(success: { (tweets: [Tweet]) -> () in
                self.tweets = tweets
            
                self.tableView.reloadData()
            
            }, failure: { (error: Error) -> () in
            print("error: \(error.localizedDescription)")
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogoutButton(_ sender: Any) {
        TwitterClient.sharedInstance?.logout()
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = self.tweets {
            return tweets.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TweetsTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "TweetsTableViewCell", for: indexPath) as! TweetsTableViewCell
        
        let tweet = tweets[indexPath.row]
        cell.tweetAuthorUsername.text = tweet.username as String?
        cell.tweetTextLabel.text = tweet.text as String?
        cell.tweetTimestamp.text = tweet.timestamp as String?
        cell.tweetAuthorName.text = tweet.name as String?
        cell.tweetAuthorProfilePic.setImageWith(tweet.profilePhotoUrl! as URL)
        cell.retweetCount.text = String(tweet.retweetCount)
        cell.favoriteCount.text = String(tweet.favoritesCount)
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    @IBAction func onRetweet(_ sender: Any) {
        let button = sender as! UIButton
        let view = button.superview!
        let cell = view.superview as! TweetsTableViewCell
        let indexPath = tableView.indexPath(for: cell)
        self.tweets![indexPath!.row].retweetCount = self.tweets![indexPath!.row].retweetCount + 1
        let retweetImage = UIImage(named: "retweet-icon-green")
        cell.retweetButton.setImage(retweetImage, for: .normal)
        self.tableView.reloadData()
    }
    
    
    @IBAction func onFav(_ sender: Any) {
        let button = sender as! UIButton
        let view = button.superview!
        let cell = view.superview as! TweetsTableViewCell
        let indexPath = tableView.indexPath(for: cell)
        self.tweets![indexPath!.row].favoritesCount = self.tweets![indexPath!.row].favoritesCount + 1
        let favImage = UIImage(named: "favor-icon-red")
        cell.favoriteButton.setImage(favImage, for: .normal)
        self.tableView.reloadData()
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
