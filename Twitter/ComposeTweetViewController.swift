//
//  ComposeTweetViewController.swift
//  Twitter
//
//  Created by Vivian Pham on 3/4/17.
//  Copyright © 2017 Vivian Pham. All rights reserved.
//

import UIKit

class ComposeTweetViewController: UIViewController, UITextViewDelegate {

   
    @IBOutlet weak var profilePhoto: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var sendTweetButton: UIBarButtonItem!
    
    @IBOutlet weak var navBar: UINavigationBar!
    var tweet: Tweet!
    var user: User!
    var text:String=""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Change design and color of the view controller to make it look nicer
        let skyBlue = UIColor(red: 0.0, green: 172.0/255.0, blue: 237.0/255.0, alpha: 1.0)
        navBar.barTintColor = skyBlue
        navBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        tweetTextView.delegate = self
        nameLabel.text = String(describing: user.name!)
        usernameLabel.text = "@" + String(describing: user.name!)
        tweetTextView.text = text
        sendTweetButton.isEnabled = false
        
        
        if NSData(contentsOf: user.profileUrl! as URL) != nil {
            profilePhoto.setImageFor(.normal, with: user.profileUrl! as URL)
        }
        
        else {
            profilePhoto.setImage( UIImage(named: "profile-Icon"), for: .normal)
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tweetTextViewDidChange (_ textView: UITextView) {
        if tweetTextView.text.isEmpty {
            sendTweetButton.isEnabled = false
        }
        else {
            sendTweetButton.isEnabled = true
        }
    }
    
    @IBAction func cancelTweet(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let text = tweetTextView.text!
        if segue.identifier == "backSegue" {
            TwitterClient.sendTweet(status: text, callBack: { (tweet, error) in
                self.tweetTextView.text = ""
                self.tweetTextView.endEditing(true)
            })
            let vc = segue.destination as! TweetsViewController
            vc.user = user
            return
        }
        let vc = segue.destination as! TweetsDetailViewController
        vc.user = user
        
    }
 

}
