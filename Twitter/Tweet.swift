//
//  Tweet.swift
//  Twitter
//
//  Created by Vivian Pham on 2/27/17.
//  Copyright © 2017 Vivian Pham. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var text:NSString?
    var username: NSString?
    var name: NSString?
    var timestamp:String?
    var retweetCount:Int = 0
    var favoritesCount:Int = 0
    var profilePhotoUrl: URL?
    var favorited: Bool
    var retweeted: Bool
    var tweetID: Int?
    var user: User?
    
    init(dictionary: NSDictionary) {
        //Set the text field to have the contents of the text in the tweet
        text = dictionary["text"] as? NSString
        
        //Instantiate the retweet Count and favoritesCount to 0
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favourites_count"] as? Int) ?? 0
        
        //Instatiante the username and user from a tweet
        let user = dictionary["user"] as! NSDictionary
        username = user["screenname"] as? NSString
        name = user["name"] as? NSString
        
        //Set the profile image of the user
        let profileUrlString = user["profile_image_url_https"] as? String
        if let profileUrlString = profileUrlString {
            profilePhotoUrl = URL(string: profileUrlString)
        }
        
        //Set the timestamp of their tweet in format of MM/dd/yy
        let timestampString = dictionary["created_at"] as? NSString
        if let timestampString = timestampString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            let date = formatter.date(from: timestampString as String) as NSDate?
            formatter.dateFormat = "MM/dd/yy"
            timestamp = formatter.string(from: date as! Date)
        }
        
        tweetID = dictionary["id"] as? Int
        retweeted = dictionary["favorited"] as! Bool
        favorited = dictionary["retweeted"] as! Bool
    }

    //Add a tweet to the [NSDictionary] so you can display any new tweets
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet]{
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            
            tweets.append(tweet)
        }
        
        return tweets
    }
}
