//
//  TwitterClient.swift
//  Twitter
//
//  Created by Vivian Pham on 2/27/17.
//  Copyright © 2017 Vivian Pham. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    static let sharedInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com")!, consumerKey: "sQmAybJjFlgaR04fI4bgE6bJV", consumerSecret: "TUYgpDKD7F0Kgp8geqdiQxNScGk6qghVcEGOGYLT1U8R0uTf4t")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    func currentAccount(success:@escaping (User) -> (), failure: @escaping (Error) -> ()) {
        //verify credenctials of current user
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask , response: Any?) -> Void in
            
            //if success, save response into userDictionary and user
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            success(user)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
            
            //otherwise, print out error
            failure(error)
        })
    }
    
    func homeTimeline(success: @escaping ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        //get hometimeline of user
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask , response: Any?) -> Void in
            
            //save response into dictionaries and tweets if successful
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            success(tweets)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) -> Void in
            //print error if failure to retrive hometimeline
            failure(error)
        })
    }
    
    func handleOpenUrl (url: URL) {
        //Get request token
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        //Need to get access token for user to access tweets
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) -> Void in
            
            //if login successful, set current user
            self.currentAccount(success: { (user: User) -> () in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: Error) -> () in
                //otherwise fail, and print error
                self.loginFailure?(error)
            })
            
        }, failure: { (error: Error?) in
            print("error: \(error?.localizedDescription)")
            self.loginFailure?(error!)
        })
    }
    
    func login(success: @escaping ()->(), failure: @escaping (Error)->()) {
        
        loginSuccess = success
        loginFailure = failure
        
        //deauthorize any previous user
        TwitterClient.sharedInstance?.deauthorize()
        
        //Get token and log in the new user
        TwitterClient.sharedInstance?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: NSURL(string: "twitter://oauth") as URL!, scope: nil, success: { (requestToken: BDBOAuth1Credential?) -> Void in
            print("I got a token!")
            
            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken!.token!)")!
            UIApplication.shared.openURL(url)
            
        }, failure: { (error: Error?) -> Void in
            //if failure, print out error
            print("error: \(error?.localizedDescription)")
            self.loginFailure?(error!)
        })
    }
    
    func logout() {
        //log out the previous user
        User.currentUser = nil
        deauthorize()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogoutNotification), object: nil)
    }
    
    func retweet(tweetID: Int, success: @escaping (Tweet) -> (), failure: @escaping (Error)->()) {
        post("1.1/statuses/retweet/\(tweetID).json", parameters: ["id": tweetID], progress: nil, success: { (task: URLSessionTask, response: Any?) in
            
            let tweetDictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: tweetDictionary)
            success(tweet)
            
        }) { (task: URLSessionTask?, error: Error) in
            failure(error)
        }
    }
    
    func unretweet(tweetID: Int, success: @escaping (Tweet) -> (), failure: @escaping (Error)->()) {
        post("1.1/statuses/unretweet/\(tweetID).json", parameters: ["id": tweetID], progress: nil, success: { (task: URLSessionTask, response: Any?) in
            
            let tweetDictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: tweetDictionary)
            success(tweet)
            
        }) { (task: URLSessionTask?, error: Error) in
            failure(error)
        }
    }
    
    func favorite(tweetID: Int, success: @escaping (Tweet) -> (), failure: @escaping (Error)->()) {
        post("https://api.twitter.com/1.1/favorites/create.json?id=" + String(tweetID), parameters: ["id": tweetID], progress: nil, success: { (task: URLSessionTask, response: Any?) in
            
            let tweetDictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: tweetDictionary)
            success(tweet)
            
        }) { (task: URLSessionTask?, error: Error) in
            failure(error)
        }
    }
    func unfavorite(tweetID: Int, success: @escaping (Tweet) -> (), failure: @escaping (Error)->()) {
        post("https://api.twitter.com/1.1/favorites/destroy.json?id=" + String(tweetID), parameters: ["id": tweetID], progress: nil, success: { (task: URLSessionTask, response: Any?) in
            
            let tweetDictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: tweetDictionary)
            success(tweet)
            
        }) { (task: URLSessionTask?, error: Error) in
            failure(error)
        }
    }
    class func sendTweet(status: String, callBack: @escaping (_ response: Tweet?, _ error: Error?) -> Void) {
        
        guard let encoded = status.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            else {
                callBack(nil, nil)
                return
        }
        let _ = TwitterClient.sharedInstance?.post("https://api.twitter.com/1.1/statuses/update.json?status=" + encoded, parameters: nil, progress: nil, success: { (URLSessionDataTask, response: Any?) in
            
            if let tweetDictionary = response as? [String: Any] {
                let tweet = Tweet(dictionary: tweetDictionary as NSDictionary)
                callBack(tweet, nil)
            }
            else {
                callBack(nil, nil)
            }
            
        }, failure: { (URLSessionDataTask, error: Error) in
            print(error.localizedDescription)
            callBack(nil, error)
        })
    }
    

    
    
}
