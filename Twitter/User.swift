//
//  User.swift
//  Twitter
//
//  Created by Vivian Pham on 2/27/17.
//  Copyright © 2017 Vivian Pham. All rights reserved.
//

import UIKit

class User: NSObject {

    var name: NSString?
    var screenname: NSString?
    var profileUrl: URL?
    var tagline: NSString?
    
    var dictionary: NSDictionary?
    
    var tweetCount: Int = 0
    var followingCount: Int = 0
    var followersCount: Int = 0
    var backgroundUrl: URL?
    
    init(dictionary: NSDictionary) {
        //initialize the dictionary
        self.dictionary = dictionary
        
        //Set the name and screenname for the author of the tweet
        name = dictionary["name"] as? NSString
        screenname = dictionary["screen_name"] as? NSString
        
        //Set the profile picture for the author of the tweet
        let profileUrlString = dictionary["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString {
            profileUrl = URL(string: profileUrlString)
        }
        //Set the tweet text to the description of the tweet
        tagline = dictionary["description"] as? NSString
        
        let backgroundUrlStr = dictionary["profile_background_image_url_https"] as? String
        if let backgroundUrlStr = backgroundUrlStr {
            backgroundUrl = URL(string: backgroundUrlStr)
        } else {
            backgroundUrl = URL(string: "")
        }
        
        tweetCount = (dictionary["statuses_count"] as? Int)!
        followingCount = (dictionary["friends_count"] as? Int)!
        followersCount = (dictionary["followers_count"] as? Int)!
        
    }
    
    static var _currentUser: User?
    static let userDidLogoutNotification = "UserDidLogout"
    
    class var currentUser: User? {
        //Get the information from current user that is logged in
        get {
            if _currentUser == nil {
            let defaults = UserDefaults.standard
            let userData = defaults.object(forKey: "currentUserData") as? Data
            
            if let userData = userData {
                let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! NSDictionary
            
                _currentUser = User(dictionary: dictionary)
            }
            }
            
            return _currentUser
        }
        
        //Set current information and data to that of new user that has signed in
        set(user) {
            _currentUser = user
            
            let defaults = UserDefaults.standard
            if let user = user {
                _ = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                
                defaults.removeObject(forKey: "currentUserData")
            } else {
                defaults.removeObject(forKey: "currentUserData")
            }
            
            defaults.synchronize()
        }
    }
}
