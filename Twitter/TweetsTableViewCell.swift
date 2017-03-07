//
//  TweetsTableViewCell.swift
//  Twitter
//
//  Created by Vivian Pham on 2/27/17.
//  Copyright © 2017 Vivian Pham. All rights reserved.
//

import UIKit

class TweetsTableViewCell: UITableViewCell {

    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetAuthorUsername: UILabel!
    @IBOutlet weak var tweetAuthorName: UILabel!
    @IBOutlet weak var tweetAuthorProfilePic: UIButton!
    @IBOutlet weak var tweetTimestamp: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var favoriteCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
