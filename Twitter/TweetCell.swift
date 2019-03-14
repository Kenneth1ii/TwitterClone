//
//  TweetCell.swift
//  Twitter
//
//  Created by Kenneth Li on 3/7/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tweetContent: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favButton: UIButton!
    
    var retweet:Bool = false
    var favorited:Bool = false
    var tweetID:Int = -1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
                    // underscore in the function _ parmameter means to ignore/do nothing.
    func setfavorited(_ isfavorited:Bool) {  // get boolean from homeTableController tweet dictionary
        favorited = isfavorited
        if (favorited) {
            favButton.setImage(UIImage(named: "favor-icon-red"), for: UIControl.State.normal)
        }
        else {
            favButton.setImage(UIImage(named: "favor-icon"), for: UIControl.State.normal)
        }
    }
    
    
    @IBAction func favTweet(_ sender: Any) {
        let toBeFavorited:Bool = !favorited
        if(toBeFavorited) {
            TwitterAPICaller.client?.createFavorited(postID: tweetID, success: {
                self.setfavorited( true)
            }, failure: { (Error) in
                print("fail to favorite: \(Error)")
            })
        }
        else {
            TwitterAPICaller.client?.destoryFavorited(postID: tweetID, success: {
                self.setfavorited(false)
            }, failure: { (Error) in
                print("failure to unfavorited: \(Error)")
            })
        }
    }
    
    
    @IBAction func reTweet(_ sender: Any) {
        let toBeTweeted:Bool = !retweet
        if (toBeTweeted) {
            TwitterAPICaller.client?.retweet(postID: tweetID, success: {
                self.setRetweeted(true)
            }, failure: { (Error) in
                print("failed to retweet: \(Error)")
            })
        }
        else {
            TwitterAPICaller.client?.unRetweet(postID: tweetID, success: {
                self.setRetweeted(false)
            }, failure: { (Error) in
                print("failed to untweet: \(Error)")
            })
        }
    }
    
    
    
    func setRetweeted (_ isRetweeted:Bool) {
        retweet = isRetweeted                // Set variable of retweet status. to used Above...
        if (isRetweeted) {
            retweetButton.setImage(UIImage(named: "retweet-icon-green"), for: UIControl.State.normal)
        }
        else {
            retweetButton.setImage(UIImage(named: "retweet-icon"), for: UIControl.State.normal)
        }
    }
    
   // default stuff  below when created uitablecell.
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
