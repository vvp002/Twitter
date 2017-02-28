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
    
    init(dictionary: NSDictionary) {
        text = dictionary["text"] as? NSString
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favourites_count"] as? Int) ?? 0
        let user = dictionary["user"] as! NSDictionary
        username = user["screenname"] as? NSString
        name = user["name"] as? NSString
        let profileUrlString = user["profile_image_url_https"] as? String
        
        if let profileUrlString = profileUrlString {
            profilePhotoUrl = URL(string: profileUrlString)
        }
        
        let timestampString = dictionary["created_at"] as? NSString
        
        if let timestampString = timestampString {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            let date = formatter.date(from: timestampString as String) as NSDate?
            formatter.dateFormat = "MM/dd/yy"
            timestamp = formatter.string(from: date as! Date)
        }
    }

    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet]{
        var tweets = [Tweet]()
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            
            tweets.append(tweet)
        }
        
        return tweets
    }
}
