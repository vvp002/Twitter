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
    
    var tweet: Tweet!
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let skyBlue = UIColor(red: 0.0, green: 172.0/255.0, blue: 237.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.barTintColor = skyBlue
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        tweetTextView.delegate = self
        nameLabel.text = String(describing: user.name!)
        tweetTextView.text = String("")
        sendTweetButton.isEnabled = false
        
        if let photoData = NSData(contentsOf: tweet.profilePhotoUrl! as URL) {
            profilePhoto.setImageFor(.normal, with: tweet.profilePhotoUrl! as URL)
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
        
    }
 

}
