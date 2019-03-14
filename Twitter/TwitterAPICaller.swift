//
//  APIManager.swift
//  Twitter
//
//  Created by Dan on 1/3/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterAPICaller: BDBOAuth1SessionManager {    // caches tokens
    static let client = TwitterAPICaller(baseURL: URL(string: "https://api.twitter.com"), consumerKey: "uFTmFW66AAMEUwx3rZlZDMSCf", consumerSecret: "LtlxIoQpBvHcqjpSMIA9Gs2E9wCJbr7xkx9EpSdBYoNedaZUgh")
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    func handleOpenUrl(url: URL){   // Url-Twitter used from token login. to Open back UR APP.
        let requestToken = BDBOAuth1Credential(queryString: url.query)  // form of query string.
        TwitterAPICaller.client?.fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) in 
            self.loginSuccess?()
        }, failure: { (error: Error!) in
            self.loginFailure?(error)
        })
    } // function application delegates of url openning
    
    
// TwitterAPICaller.client?.requestSerializer.saveAccessToken(accessToken) - underhood after success used to form all request.
    
    // request get
/* TwitterAPICaller.client?.get("https://api.twitter.com/1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (operation: URLSessionDataTask, response: Any?) in
    print("\(response)")
}, failure: { (operation: URLSessionDataTask!,error: Error) in
    print("error")
}) */

    
    
    
                        // @escaping keep value of parameter even after function ends.
    func login(url: String, success: @escaping () -> (), failure: @escaping (Error) -> ()){
        loginSuccess = success
        loginFailure = failure
        TwitterAPICaller.client?.deauthorize()
        // fetchRequest url api, "get" , to login.
        TwitterAPICaller.client?.fetchRequestToken(withPath: url, method: "GET", callbackURL: URL(string: "alamoTwitter://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token!)")!    // token we got back.
            UIApplication.shared.open(url)      // open different app depending on url which is our token.
        }, failure: { (error: Error!) -> Void in
            print("Error: \(error.localizedDescription)")
            self.loginFailure?(error)
        })
    }
    // find callbackURL: info specify bundle identifier. "//oauth" - just routing to different part of your application page after the fact we handled "alamoTwitter" bundle identifier.
    // UIApplication from Application delegate we defined to use handleOpenUrl function.
    
    
    
    
    
    func logout (){
        deauthorize()
    }
    
    
    func getDictionaryRequest(url: String, parameters: [String:Any], success: @escaping (NSDictionary) -> (), failure: @escaping (Error) -> ()){
        TwitterAPICaller.client?.get(url, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in       // get request
            success(response as! NSDictionary)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    // all parameters filled in with function we created -> () void.
    
    
    
    
    func getDictionariesRequest(url: String, parameters: [String:Any], success: @escaping ([NSDictionary]) -> (), failure: @escaping (Error) -> ()){
        print(parameters)
        TwitterAPICaller.client?.get(url, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            success(response as! [NSDictionary])
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }

    
    
    func postRequest(url: String, parameters: [Any], success: @escaping () -> (), failure: @escaping (Error) -> ()){
        TwitterAPICaller.client?.post(url, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            success()
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    
    
    
    func postTweet(tweetString: String, success: @escaping () -> (), failure: @escaping (Error) -> ()){
        let url = "https://api.twitter.com/1.1/statuses/update.json"
        
        TwitterAPICaller.client?.post(url, parameters: ["status":tweetString], progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            success()
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    func createFavorited(postID:Int, success: @escaping ()-> (), failure: @escaping(Error) -> () ) {
        let url = "https://api.twitter.com/1.1/favorites/create.json"
        
        TwitterAPICaller.client?.post(url, parameters: ["id":postID], progress: nil, success: { (URLSessionDataTask,response: Any?) in
            success()
        }, failure: { (task: URLSessionDataTask?,error: Error) in
            failure(error)
        })
    }
    
    func destoryFavorited(postID:Int, success: @escaping ()-> (), failure: @escaping(Error) -> () ) {
        let url = "https://api.twitter.com/1.1/favorites/destroy.json"
        
        TwitterAPICaller.client?.post(url, parameters: ["id":postID], progress: nil, success: { (URLSessionDataTask,response: Any?) in
            success()
        }, failure: { (task: URLSessionDataTask?,error: Error) in
            failure(error)
        })
    }
    
    func retweet(postID:Int, success: @escaping ()-> (), failure: @escaping(Error) -> () ) {
        let url = "https://api.twitter.com/1.1/statuses/retweet/\(postID).json"
        
        TwitterAPICaller.client?.post(url, parameters: ["id":postID], progress: nil, success: { (URLSessionDataTask,response: Any?) in
            success()
        }, failure: { (task: URLSessionDataTask?,error: Error) in
            failure(error)
        })
    }
 
    
    func unRetweet(postID:Int, success: @escaping ()-> (), failure: @escaping(Error) -> () ) {
        let url = "https://api.twitter.com/1.1/statuses/unretweet/\(postID).json"
        
        TwitterAPICaller.client?.post(url, parameters: ["id":postID], progress: nil, success: { (URLSessionDataTask,response: Any?) in
            success()
        }, failure: { (task: URLSessionDataTask?,error: Error) in
            failure(error)
        })
    }
}
