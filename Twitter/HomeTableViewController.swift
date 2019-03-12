//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Kenneth Li on 3/7/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {     //type UItableview not regular controller so
                                                    // dont need datasource/delegates.
    
    
    var tweetArray = [NSDictionary]()  // nsdictionary unspecify type, dictionary is specify.
    var numberOfTweet: Int!
    let myrefreshControl = UIRefreshControl()
   
    
    
    override func viewDidLoad() {       // called once
        super.viewDidLoad()
        loadTweets()
        myrefreshControl.addTarget(self, action: #selector(loadTweets), for: .valueChanged) // target:self
        //        #selector(objc) - to our function to reload as the selector.
        tableView.refreshControl = myrefreshControl
    }
    

    override func viewDidAppear(_ animated: Bool) {   //called everytime cus showing the view.
        super.viewDidAppear(animated)       // always need call to super-class view controller
        loadTweets()
    }
    
        
    
    @objc func loadTweets() {
        numberOfTweet = 20
        
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let myParams = ["count:": numberOfTweet]     // twitterAPi takes optional parameter such as number of tweets as form of dictionary which is "count:" numberoftweet.
        
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams, success: { (tweets: [NSDictionary]) in
            
                            // this whole code is within closure of parameter if success.
                            // NSdictionary here contains our tweets from twitterAPICaller
                // hey when u create this parameter called tweets pls run this line of code. closure
            self.tweetArray.removeAll()
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            self.tableView.reloadData()               // table field itselfs.
            self.myrefreshControl.endRefreshing()       // end refreshing.
            
        }, failure: { (Error) in                // if fail parameter.
            print("Could not retrieve tweets")
        })
    }
    
    
    
    
    func loadMoreTweet(){
        let myUrl = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        numberOfTweet = numberOfTweet + 20
        let myParams = ["count": numberOfTweet]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: myUrl, parameters: myParams, success: { (tweets: [NSDictionary]) in
            
            self.tweetArray.removeAll()
            for tweet in tweets {
                self.tweetArray.append(tweet)
            }
            self.tableView.reloadData()
            
        }, failure: { (Error) in
            print("Could not retrieve tweets")
        })
    }
    
    
    
    
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == tweetArray.count {
            loadMoreTweet()
        }
    }
    
    
    
    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        self.dismiss(animated: true, completion: nil)   // screen dismiss itself. nil at completion nothing:
                                                    // dont want anything happen once its gone.
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCell
        
        let user = tweetArray[indexPath.row]["user"] as! NSDictionary
                                                                //dictionary under dictionary is "name"
        cell.userNameLabel.text = user["name"] as? String     //user within another dictionary ["name"]
        cell.tweetContent.text = tweetArray[indexPath.row]["text"] as? String
        
        
        // Idk how this goes?? learn later.. how to make image display url. w.e
        let imageUrl = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: imageUrl!)
        
        if let imageData = data {
            cell.profileImageView.image = UIImage(data: imageData)
        }
        
        return cell     // -> returns UITableViewCell
    }
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1                        // How many sections? we only have 1 for this for now.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tweetArray.count            // How many rows per section?
    }


}
